//
//  OpenCVWrapper.h
//  Amandala
//
//   Создано Linsw 16/4/27.
//   Copyright © 2016 年 Linsw. Все права защищены.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/// third party library
@interface OpenCVWrapper : NSObject
+ (UIImage *)floodFill:(UIImage*)inputImage point:(CGPoint)point replacementColor:(UIColor*)replacementColor;

@end
