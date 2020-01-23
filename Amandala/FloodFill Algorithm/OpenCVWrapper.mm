//
//  OpenCVWrapper.mm
//  Amandala
//
//  Created by Ксения Шкуренко on 09.11.2017.
//  Copyright © 2017 Kseniia Shkurenko. All rights reserved.
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
        
        
        floodFill(cvImage, cv::Point(point.x, point.y), Scalar(UInt8(r * 255), UInt8(g * 255), UInt8(b * 255)), 0,  Scalar(0, 0, 0), Scalar(0, 0, 0), 8);
//        medianBlur(cvImage, cvImage, 3);
        return MatToUIImage(cvImage);
    }


@end
