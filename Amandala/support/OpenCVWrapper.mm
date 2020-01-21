//
//  OpenCVWrapper.mm
//  MyRecolor
//
//  Created by Linsw on 16/4/27.
//  Copyright © 2016年 Linsw. All rights reserved.
//


#include <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"

#import "opencv2/imgcodecs/ios.h"

using namespace cv;
using namespace std;

@implementation OpenCVWrapper : NSObject
    + (UIImage *)floodFill:(UIImage*)inputImage point:(CGPoint)point replacementColor:(UIColor*)replacementColor {
        
        
        cv::Mat cvImage;
        UIImageToMat(inputImage, cvImage);
        if (cvImage.channels() == 4) {
            cv::cvtColor(cvImage, cvImage, COLOR_RGBA2RGB);
        }
        switch (cvImage.channels()) {
            case 4:
                cv::cvtColor(cvImage, cvImage, COLOR_RGBA2RGB);
                break;
            case 1:
                cv::cvtColor(cvImage, cvImage, COLOR_GRAY2RGB);
                break;
            default:
                break;
        }
//        assert(cvImage.channels() == 3);
        CGFloat r = 0;
        CGFloat g = 0;
        CGFloat b = 0;
        [replacementColor getRed:&r green:&g blue:&b alpha:nil];
//        assert(r != 0);
        
        int loDiff = (r < 0 && g < 0 && b < 0) ? 0 : 20;
        
        floodFill(cvImage, cv::Point(point.x, point.y), Scalar(UInt8(r * 255), UInt8(g * 255), UInt8(b * 255)), 0,  Scalar(UInt8(loDiff), UInt8(loDiff), UInt8(loDiff)), Scalar(0, 0, 0), 8);
//        medianBlur(cvImage, cvImage, 3);
        return MatToUIImage(cvImage);
    }

    + (UIImage *)medianBlur:(UIImage*)inputImage {
        cv::Mat cvImage;
        UIImageToMat(inputImage, cvImage);
        medianBlur(cvImage, cvImage, 3);
        return MatToUIImage(cvImage);
    }

@end
