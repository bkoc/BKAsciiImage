//
//  BKAsciiConverter.m
//  BKAsciiImage
//
//  Copyright (c) 2014 Barış Koç (https://github.com/bkoc)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "BKAsciiConverter.h"
#import "BKAsciiConverter_Internal.h"
#import "BKAsciiDefinition.h"

#define kDefaultFontSize 10.0

@interface BKAsciiConverter ()
@property (strong, nonatomic) BKAsciiDefinition* definition;
@end


@implementation BKAsciiConverter

- (instancetype)init{
    self = [super init];
    if (self) {
        _definition = [[BKAsciiDefinition alloc] init];
        [self initDefaults];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)luminanceToStringMapping{
    self = [super init];
    
    if (self) {
        _definition = [[BKAsciiDefinition alloc] initWithDictionary:luminanceToStringMapping];
        [self initDefaults];
    }
    return self;
}

- (instancetype)initWithDefinition:(BKAsciiDefinition*)definition{
    self = [super init];
    if (self) {
        _definition = definition;
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults{
    _font = [UIFont systemFontOfSize:kDefaultFontSize];
    _backgroundColor = [UIColor clearColor];
    _grayscale = NO;
    _reversedLuminance = YES; // reverse by default assuming used with a dark bg color
    _columns = 0;
}

#pragma mark - Ascii Image
-(UIImage*)convertImage:(UIImage *)input{
    
    CGFloat asciiGridWidth = [self _gridWidth:input.size.width];
    
    UIImage *output = [self convertImage:input
                                WithFont:self.font
                                 bgColor:self.backgroundColor
                                 columns:asciiGridWidth
                                reversed:self.reversedLuminance
                               grayscale:self.grayscale];
    return output;
}

- (void)convertImage:(UIImage*)input completionHandler:(void (^)(UIImage *asciiImage))handler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat asciiGridWidth = [self _gridWidth:input.size.width];
        UIImage *output = [self convertImage:input
                                    WithFont:self.font
                                     bgColor:self.backgroundColor
                                     columns:asciiGridWidth
                                    reversed:self.reversedLuminance
                                   grayscale:self.grayscale];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(output);
        });
    });
}


-(UIImage *)convertImage:(UIImage*)input WithFont:(UIFont*)font bgColor:(UIColor*)bgColor
                 columns:(int)columns reversed:(BOOL)reversed grayscale:(BOOL)grayscale{
    
    if (input == nil) {
        NSLog(@"BKAsciiConverter: input image is nil!");
        return nil;
    }
    
    
    BOOL opaque = ![self isTransparent];
    CGFloat fontSize = [font pointSize];
    CGFloat asciiGridWidth = columns;
    UIImage *scaledImage = [self downscaleImage:input WithFactor: asciiGridWidth];
    BlockGrid *pixelGrid = [self pixelGridForImage:scaledImage];
    
    UIGraphicsBeginImageContextWithOptions(input.size, opaque, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(0, 0, scaledImage.size.width, scaledImage.size.height);
    
    if (opaque && bgColor) {
        CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
    }
    else{
        CGContextClearRect(ctx, rect);
    }
    
    CGContextFillRect (ctx, CGRectMake(0, 0, input.size.width, input.size.height));
    
    const char *fontName = [[font fontName] cStringUsingEncoding:NSMacOSRomanStringEncoding];
    CGContextSelectFont(ctx, fontName, fontSize, kCGEncodingMacRoman);
    // CGContextSetCharacterSpacing(ctx, 10);
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0); // reflect about x axis
    CGContextSetTextMatrix(ctx, transform);
    
    BKAsciiDefinition *asciiDefinition = self.definition;
    
    CGFloat blockWidth = input.size.width / pixelGrid.width;
    CGFloat blockHeight = input.size.height / pixelGrid.height;
    
    for (int x=0; x < pixelGrid.width; x++) {
        for (int y=0; y < pixelGrid.height; y++) {
            
            int col = x; int row = y;
            
            block_t block = [pixelGrid blockAtRow:row col:col];
            
            CGFloat luminance = [self _luminance:block];
            
            NSString *asciiResult = [asciiDefinition stringForLuminance:luminance];
            CGRect rect = CGRectMake(blockWidth * col, blockHeight * row, blockWidth, blockHeight);

            if (!grayscale)
                CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:block.r green:block.g blue:block.b alpha:1.0].CGColor);
            else
                CGContextSetGrayFillColor(ctx, luminance, 1.0);
            
            const char *cString = [asciiResult UTF8String];
            CGContextShowTextAtPoint(ctx, rect.origin.x, rect.origin.y, cString, strlen(cString));
        }
    }
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return renderedImage;
}


#pragma mark - Ascii String
- (NSString*)convertToString:(UIImage*)input{
    CGFloat asciiGridWidth = [self _gridWidth:input.size.width];
    
    UIImage *scaledImage = [self downscaleImage:input WithFactor: asciiGridWidth];
    BlockGrid *pixelGrid = [self pixelGridForImage:scaledImage];
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
    for (int y=0; y < pixelGrid.height; y++) {
        for (int x=0; x < pixelGrid.width; x++) {
            int col = x; int row = y;
            block_t block = [pixelGrid blockAtRow:row col:col];
            CGFloat luminance = [self _luminance:block];
            NSString *ascii = [self.definition stringForLuminance: luminance];
            [str appendString:ascii];
            [str appendString:@" "];
        }
        [str appendString:@"\n"];
    }

    // NSLog(@"%@",str);
    return [NSString stringWithString:str];
}

- (void)convertToString:(UIImage*)input completionHandler:(void (^)(NSString *asciiString))handler{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *output = [self convertToString:input];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(output);
        });
    });
}

#pragma mark - Helpers

-(BlockGrid*)pixelGridForImage:(UIImage*)image{
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    //  Determine the desired index by multiplying row * column.
    BlockGrid * grid = [[BlockGrid alloc] initWithWidth:(int)width height:(int)height];
    block_t block;
    for (int row = 0; row < width; row++) {
        for (int col = 0; col < height; col++) {
            // Now rawData contains the image data in the RGBA8888 pixel format.
            int byteIndex = ((int)bytesPerRow * col) + row * (int)bytesPerPixel;
            
            block.r = (rawData[byteIndex]) / 255.0;
            block.g = (rawData[byteIndex + 1]) / 255.0;;
            block.b = (rawData[byteIndex + 2]) / 255.0;;
            block.a = (rawData[byteIndex + 3]) / 255.0;
            
            [grid copyBlock:&block toRow:col col:row]; // the image is in the wrong orientation. Rotate row & col
        }
    }
    free(rawData);
    
    return grid;
}

-(UIImage*)downscaleImage:(UIImage*)image WithFactor:(CGFloat)scaleFactor{
    
    if (scaleFactor <= 1)
        return image;
    
    if (scaleFactor > MIN(image.size.height, image.size.width))
        scaleFactor = MIN(image.size.height, image.size.width);
    
    CGFloat ratio = scaleFactor / image.size.width;
    
    CGFloat newWidth = scaleFactor;
    CGFloat newHeight = ratio * image.size.height;
    
    CGSize size = CGSizeMake(newWidth, newHeight);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0);
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (BOOL)isTransparent{
    if (self.backgroundColor == nil || [self.backgroundColor isEqual:[UIColor clearColor]])
        return YES;
    else
        return NO;
}


- (CGFloat)_gridWidth:(CGFloat)width{
    CGFloat asciiGridWidth;
    if (self.columns == 0) {
        asciiGridWidth = width/self.font.pointSize;
    }
    else{
        asciiGridWidth = self.columns;
    }
    return asciiGridWidth;
}

- (CGFloat)_luminance:(block_t)block{
    // See wikipedia article on grayscale for an explanation of this formula.
    // http://en.wikipedia.org/wiki/Grayscale
    float luminance = 0.2126 * block.r + 0.7152 * block.g + 0.0722 * block.b;
    if (self.reversedLuminance) {
        luminance = (1.0 - luminance);
    }
    return luminance;
}
@end


