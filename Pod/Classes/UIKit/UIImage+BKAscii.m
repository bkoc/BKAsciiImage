//
//  UIImage+BKAscii.m
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

#import "UIImage+BKAscii.h"
#import "BKAsciiConverter.h"

@implementation UIImage (BKAscii)

- (UIImage*)bk_asciiImage{
    BKAsciiConverter *converter = [BKAsciiConverter new];
    return [converter convertImage:self];
}

- (UIImage*)bk_asciiImageWithFont:(UIFont*)font{
    BKAsciiConverter *converter = [BKAsciiConverter new];
    converter.font = font;
    return [converter convertImage:self];
}

- (NSString*)bk_asciiString{
    BKAsciiConverter *converter = [BKAsciiConverter new];
    return [converter convertToString:self];
}


- (void)bk_asciiImageCompletionHandler:(void (^)(UIImage *asciiImage))handler{
    BKAsciiConverter *converter = [BKAsciiConverter new];
    [converter convertImage:self completionHandler:^(UIImage *asciiImage) {
        handler(asciiImage);
    }];
}

- (void)bk_asciiImageWithFont:(UIFont*)font completionHandler:(void (^)(UIImage *asciiImage))handler{
    BKAsciiConverter *converter = [BKAsciiConverter new];
    converter.font = font;
    [converter convertImage:self completionHandler:^(UIImage *asciiImage) {
        handler(asciiImage);
    }];
}

- (void)bk_asciiImageWithFont:(UIFont*)font
                      bgColor:(UIColor*)bgColor
                      columns:(int)columns
                     reversed:(BOOL)reversed
                    grayscale:(BOOL)grayscale
            completionHandler:(void (^)(UIImage *asciiImage))handler{
    BKAsciiConverter *converter = [BKAsciiConverter new];
    converter.backgroundColor = bgColor;
    converter.columns = columns;
    converter.reversedLuminance = reversed;
    converter.grayscale = grayscale;
    [converter convertImage:self completionHandler:^(UIImage *asciiImage) {
        handler(asciiImage);
    }];
}

-(void)bk_asciiStringCompletionHandler:(void (^)(NSString *asciiString))handler{
    BKAsciiConverter *converter = [BKAsciiConverter new];
    [converter convertToString:self completionHandler:^(NSString *asciiString) {
        handler(asciiString);
    }];
}
@end
