//
//  BKViewController.m
//  BKAsciiImage
//
//  Created by Barış Koç on 04/08/2015.
//  Copyright (c) 2014 Barış Koç. All rights reserved.
//

#import "BKViewController.h"

#import <BKAsciiImage/BKAsciiConverter.h>
#import <BKAsciiImage/UIImage+BKAscii.h>

@interface BKViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation BKViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.imageView.image = [UIImage imageNamed:@"daft.jpg"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)processImage:(id)sender {
    [self processUsingConverter];
}

- (void)processUsingConverter{
    UIImage *daft = [UIImage imageNamed:@"daft.jpg"];
    self.imageView.image = daft; // reset image
    
    BKAsciiConverter *_converter = [BKAsciiConverter new];
    // _converter.backgroundColor = [UIColor whiteColor];
    // _converter.grayscale = YES;
    // _converter.font = [UIFont systemFontOfSize:4];

    [_converter convertImage:daft completionHandler:^(UIImage *asciiImage) {
        [UIView transitionWithView:self.imageView duration:3.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.imageView.image = asciiImage;
                        }
                        completion:nil];
    }];
    
    [_converter convertToString:daft completionHandler:^(NSString *asciiString) {
        NSLog(@"%@",asciiString);
    }];
}

- (void)processUsingUIImageCategory{
    self.imageView.image = [UIImage imageNamed:@"daft.jpg"]; // reset image
    
    UIImage *input = self.imageView.image;
    [input bk_asciiImageCompletionHandler:^(UIImage *asciiImage) {
        [UIView transitionWithView:self.imageView duration:3.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.imageView.image = asciiImage;
                        }
                        completion:nil];
    }];
    
    [input bk_asciiStringCompletionHandler:^(NSString *asciiString) {
        NSLog(@"%@",asciiString);
    }];
}


@end
