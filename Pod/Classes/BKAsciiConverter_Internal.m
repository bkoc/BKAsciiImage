//
//  BKAsciiConvert_Internal.m
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

#import "BKAsciiConverter_Internal.h"

@interface BlockGrid () {
    block_t * _blocks;
    int _width;
    int _height;
}

@end

@implementation BlockGrid

#pragma mark - Memory Management

- (instancetype) init {
    return [self initWithWidth:0 height:0];
}

- (instancetype) initWithWidth:(int)width height:(int)height {
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        
        _blocks = malloc(sizeof(block_t) * _width * _height);
    }
    return self;
}

- (void) dealloc {
    free(_blocks);
}

#pragma mark - Block manipulation

- (void) copyBlock:(block_t *)block toRow:(int)row col:(int)col {
    NSAssert(col < _width && row < _height, @"Tried to set block (%i, %i) outside of range (%i, %i)", col, row, _width, _height);
    
    size_t offset = _width * row + col;
    memcpy(_blocks + offset, block, sizeof(block_t));
}

- (block_t) blockAtRow:(int)row col:(int)col {
    NSAssert(col < _width && row < _height, @"Tried to retrieve block (%i, %i) outside of range (%i, %i)", col, row, _width, _height);
    
    block_t result;
    size_t offset = _width * row + col;
    result = *(_blocks + offset);
    
    return result;
}

@end

