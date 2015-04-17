//
//  BKAsciiConverter.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BKAsciiDefinition;

/// Instances
@interface BKAsciiConverter : NSObject

/// default: System font of size 10
@property (strong, nonatomic) UIFont *font;
/// default: Clear color. Image background is transparent
@property (strong, nonatomic) UIColor *backgroundColor;
/// default: Calculated by the font size
@property (nonatomic) CGFloat columns;
/// Reverses the luminance mapping. default: YES
@property (nonatomic) BOOL reversedLuminance;
/// default: NO
@property (nonatomic) BOOL grayscale;

/// Expects a dictionary of floats as keys and strings as values
- (instancetype)initWithDictionary:(NSDictionary*)luminanceToStringMapping;

- (instancetype)initWithDefinition:(BKAsciiDefinition*)definition;

/// Renders a new image as ascii art
- (UIImage*)convertImage:(UIImage*)input;

/// Process in the background queue. Handler will be called on main thread
- (void)convertImage:(UIImage*)input completionHandler:(void (^)(UIImage *asciiImage))handler;

/// Returns ascii art as string
- (NSString*)convertToString:(UIImage*)input;

/// Process in the background queue. Handler will be called on main thread
- (void)convertToString:(UIImage*)input completionHandler:(void (^)(NSString *asciiString))handler;

@end
