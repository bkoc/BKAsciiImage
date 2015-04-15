//
//  BKAsciiDefinition.m
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

#import "BKAsciiDefinition.h"
#import <CoreGraphics/CoreGraphics.h>

#pragma mark BKAsciiMetrics
#pragma mark -

@interface BKAsciiMetrics : NSObject
@property (copy, nonatomic) NSString *ascii;
@property (copy, nonatomic) NSNumber *luminance;
- (instancetype)initWithString:(NSString*)characters luminance:(NSNumber*)luminance NS_DESIGNATED_INITIALIZER;
@end


@implementation BKAsciiMetrics
- (instancetype)initWithString:(NSString *)characters luminance:(NSNumber*)luminance{
    self = [super init];
    if (self) {
        _ascii = characters;
        _luminance = luminance;
    }
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"ascii: %@ luminance: %@ ", self.ascii, self.luminance];
}
@end



#pragma mark BKAsciiDefinition
#pragma mark -
@interface BKAsciiDefinition ()
@property (copy, nonatomic) NSArray *metrics;
@end


@implementation BKAsciiDefinition

+ (NSDictionary*)defaultDictionary{
    NSDictionary *dictionary = @{  @1.0: @" ",
                                   @0.95:@"`",
                                   @0.92:@".",
                                   @0.9 :@",",
                                   @0.8 :@"-",
                                   @0.75:@"~",
                                   @0.7 :@"+",
                                   @0.65:@"<",
                                   @0.6 :@">",
                                   @0.55:@"o",
                                   @0.5 :@"=",
                                   @0.35:@"*",
                                   @0.3 :@"%",
                                   @0.1 :@"X",
                                   @0.0 :@"@"
                                   };
    return dictionary;
}

- (instancetype)init{
    self = [self initWithDictionary:[BKAsciiDefinition defaultDictionary]];
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)luminanceToStringMapping{
    self = [super init];
    if (self) {
        [self buildDataFromMapping:luminanceToStringMapping];
    }
    return self;
}

- (void)buildDataFromMapping:(NSDictionary*)stringToLumMapping{
    NSMutableArray *temp = [NSMutableArray new];
    [stringToLumMapping enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        NSString *characters = obj;
        NSNumber *luminance = key;
        BKAsciiMetrics *asciiMetric = [[BKAsciiMetrics alloc] initWithString:characters luminance:luminance];
        [temp addObject:asciiMetric];
    }];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"luminance" ascending:YES];
    _metrics = [temp sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSString*)stringForLuminance:(CGFloat)luminance{
    BKAsciiMetrics *target = [[BKAsciiMetrics alloc] initWithString:nil luminance:@(luminance)];
    
    NSRange searchRange = NSMakeRange(0, [self.metrics count]);
    NSInteger searchIndex = [self.metrics indexOfObject: target
                                          inSortedRange:searchRange
                                                options:NSBinarySearchingInsertionIndex
                                        usingComparator:^NSComparisonResult(BKAsciiMetrics *obj1, BKAsciiMetrics *obj2) {
                                            return [obj1.luminance compare:obj2.luminance];
                                        }];
    searchIndex = MIN(searchIndex, ([self.metrics count]-1));
    
    BKAsciiMetrics *result;
    
    if (searchIndex == 0) {
        result = self.metrics[searchIndex];
    }
    else if (searchIndex > 0) {
        BKAsciiMetrics *leftMetric = self.metrics[searchIndex -1];
        BKAsciiMetrics *rightMetric = self.metrics[searchIndex];
        
        CGFloat leftDiff = fabs([leftMetric.luminance doubleValue] - [target.luminance doubleValue]);
        CGFloat rightDiff = fabs([rightMetric.luminance doubleValue] - [target.luminance doubleValue]);
        
        result = leftDiff < rightDiff ? leftMetric : rightMetric;
        if (result == nil) {
            int i = 0;
            i++;
        }
    }
    
    return result.ascii;
}

#pragma mark - debug
- (void)logDefinition{
    for (BKAsciiMetrics *m in self.metrics) {
        NSLog(@"%@", m);
    }
}

@end


