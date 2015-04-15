//
//  BKAsciiConverter_Internal.h
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
//
//  BlockGrid class and block struct are adapted from
//  https://github.com/oxling/iphone-ascii/blob/master/ASCII/BlockGrid.h
//  BlockGrid.h
//  ASCII
//
//  Created by Amy Dyer on 8/21/12.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


typedef struct block {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
} block_t;

/* BlockGrid is a wrapper around a buffer of block_t objects, which represent individual "pixels" in the
 ASCII art. Each block_t is just a list of CGFloat components, which can be used directly by Quartz. */

@interface BlockGrid : NSObject

@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;

- (instancetype) initWithWidth:(int)width height:(int)height NS_DESIGNATED_INITIALIZER;

- (block_t) blockAtRow:(int)row col:(int)col;
- (void) copyBlock:(block_t *)block toRow:(int)row col:(int)col;
@end

