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

#define kTestImage @"testImage"

@interface BKViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *pickImageBtn;
@property (weak, nonatomic) IBOutlet UISlider *fontSizeSlider;
@property (weak, nonatomic) IBOutlet UILabel *fontSizeLabel;
- (IBAction)changeFontSize:(id)sender;
- (IBAction)pickNewImage:(id)sender;
- (IBAction)switchLuminance:(id)sender;
- (IBAction)switchGrayscale:(id)sender;

@property (strong, nonatomic) BKAsciiConverter *converter;
@property (strong, nonatomic) UIImage *inputImage;

- (IBAction)resetImage:(id)sender;

@end

@implementation BKViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.inputImage = [UIImage imageNamed:kTestImage];
    self.imageView.image = self.inputImage;
    self.converter = [BKAsciiConverter new];
    self.fontSizeSlider.value = self.converter.font.pointSize;
    self.pickImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
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
    
    // self.imageView.image = testImage; // reset image
    
    // BKAsciiConverter *_converter = [BKAsciiConverter new];
    // _converter.backgroundColor = [UIColor whiteColor];
    // _converter.grayscale = YES;
    // _converter.font = [UIFont systemFontOfSize:4];
    // _converter.reversedLuminance = NO;
    
    [_converter convertImage:self.inputImage completionHandler:^(UIImage *asciiImage) {
        [UIView transitionWithView:self.imageView duration:3.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.imageView.image = asciiImage;
                        }
                        completion:nil];
    }];
    
    [_converter convertToString:self.inputImage completionHandler:^(NSString *asciiString) {
        NSLog(@"%@",asciiString);
    }];
}

- (void)processUsingUIImageCategory{
    
    [self.inputImage bk_asciiImageCompletionHandler:^(UIImage *asciiImage) {
        [UIView transitionWithView:self.imageView duration:3.0f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.imageView.image = asciiImage;
                        }
                        completion:nil];
    }];
    
    [self.inputImage bk_asciiStringCompletionHandler:^(NSString *asciiString) {
        NSLog(@"%@",asciiString);
    }];
}


- (IBAction)changeFontSize:(id)sender {
    UISlider *slider = self.fontSizeSlider;
    self.converter.font = [UIFont systemFontOfSize: lroundf(slider.value)];
    self.fontSizeLabel.text = [NSString stringWithFormat:@"Font size: %0.1f", slider.value];
}

- (IBAction)pickNewImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)switchLuminance:(id)sender {
    _converter.reversedLuminance = !_converter.reversedLuminance;
}

- (IBAction)switchGrayscale:(id)sender {
    _converter.grayscale = !_converter.grayscale;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = self.inputImage = chosenImage;
    [self.pickImageBtn setImage:self.inputImage forState:UIControlStateNormal];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)resetImage:(id)sender {
    
    self.fontSizeSlider.value = 12.0f;
    self.fontSizeLabel.text = [NSString stringWithFormat:@"Font size: %0.1f", self.fontSizeSlider.value];

    [self.fontSizeSlider setNeedsDisplay];

    [UIView transitionWithView:self.imageView duration:3.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.imageView.image = self.inputImage;
                    }
                    completion:nil];
}
@end
