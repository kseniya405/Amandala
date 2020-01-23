//
//  OpenCVWrapper.h
//  Amandala
//
//  Created by Ксения Шкуренко on 09.11.2017.
//  Copyright © 2017 Kseniia Shkurenko. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVWrapper : NSObject
+ (UIImage *)floodFill:(UIImage*)inputImage point:(CGPoint)point replacementColor:(UIColor*)replacementColor;

@end
