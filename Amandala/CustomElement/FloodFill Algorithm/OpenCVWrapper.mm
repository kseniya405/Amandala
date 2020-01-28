//
//  OpenCVWrapper.mm
//  Amandala
//
//   Создано Linsw 16/4/27.
//   Copyright © 2016 年 Linsw. Все права защищены.
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
        CGFloat r = 0;
        CGFloat g = 0;
        CGFloat b = 0;
        [replacementColor getRed:&r green:&g blue:&b alpha:nil];
        
        
        floodFill(cvImage, cv::Point(point.x, point.y), Scalar(UInt8(r * 255), UInt8(g * 255), UInt8(b * 255)), 0,  Scalar(0, 0, 0), Scalar(0, 0, 0), 8);
        return MatToUIImage(cvImage);
    }


@end
