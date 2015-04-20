# BKAsciiImage

[![Version](https://img.shields.io/cocoapods/v/BKAsciiImage.svg?style=flat)](http://cocoapods.org/pods/BKAsciiImage)
[![License](https://img.shields.io/cocoapods/l/BKAsciiImage.svg?style=flat)](http://cocoapods.org/pods/BKAsciiImage)
[![Platform](https://img.shields.io/cocoapods/p/BKAsciiImage.svg?style=flat)](http://cocoapods.org/pods/BKAsciiImage)


![Example gif image](./Screenshots/example.gif)

### As seen on Cmd.fm iOS App

https://itunes.apple.com/app/cmd.fm-radio-for-geeks-hackers/id935765356

![Cmd.fm screenshot 1](./Screenshots/cmdfm_01.jpg)
![Cmd.fm screenshot 2](./Screenshots/cmdfm_02.jpg)

## Installation

BKAsciiImage is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "BKAsciiImage"
```

## Usage

Import BKAsciiConverter header file

```objective-c
#import <BKAsciiImage/BKAsciiConverter.h>
```

Create a BKAsciiConverter instance

```objective-c
BKAsciiConverter *converter = [BKAsciiConverter new];
```

Convert synchronously

```objective-c
UIImage *inputImage = [UIImage imageNamed:@"anImage"];
UIImage *asciiImage = [converter convertImage:inputImage];
```

Convert in the background providing a completion block

```objective-c
[converter convertImage:self.inputImage completionHandler:^(UIImage *asciiImage) {
	// do whatever you want with the resulting asciiImage
}];
```

Convert to NSString
```objective-c
NSLog(@"%@",[converter convertToString:self.inputImage]);

// asynchronous
[converter convertToString:self.inputImage completionHandler:^(NSString *asciiString) {
    NSLog(@"%@",asciiString);
}];
```

## Author

Barış Koç, https://github.com/bkoc

## License

BKAsciiImage is available under the MIT license. See the LICENSE file for more info.
