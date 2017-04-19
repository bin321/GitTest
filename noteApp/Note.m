//
//  Note.m
//  noteApp
//
//  Created by user42 on 2017/4/10.
//  Copyright © 2017年 user42. All rights reserved.
//

#import "Note.h"

@implementation Note
@dynamic noteID;
@dynamic imageName;
@dynamic name;
@dynamic order;
-(void)awakeFromInsert{
    self.noteID = [[NSUUID UUID]UUIDString];
}
-(UIImage *)getImage{
    NSString *doc = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imagePath = [doc stringByAppendingPathComponent:self.imageName];
    return [UIImage imageWithContentsOfFile:imagePath];
}
-(UIImage *)getSmallImage{
    UIImage *image = [self getImage];
    if ( !image){
        return nil;
    }
    CGSize thumbnailSize = CGSizeMake(50, 50); //設定縮圖大小
    CGFloat scale = [UIScreen mainScreen].scale; //找出目前螢幕的scale，視網膜技術為2.0
    //產生畫布，第一個參數指定大小,第二個參數YES:不透明（黑色底）,false表示透明背景,scale為螢幕scale
    UIGraphicsBeginImageContextWithOptions(thumbnailSize, NO, scale);
    
    //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
    //最小值MIN會變成UIViewContentModeScaleAspectFit
    CGFloat widthRatio = thumbnailSize.width / image.size.width;
    CGFloat heightRadio = thumbnailSize.height / image.size.height;
    CGFloat ratio = MAX(widthRatio,heightRadio);
    
    CGSize imageSize = CGSizeMake(image.size.width*ratio, image.size.height*ratio);
    
    //切成圓
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
    [circlePath addClip];
    
    
    [image drawInRect:CGRectMake(-(imageSize.width-thumbnailSize.width)/2.0, -(imageSize.height-thumbnailSize.height)/2.0,
                                 imageSize.width, imageSize.height)];
    
    //取得畫布上的縮圖
    image = UIGraphicsGetImageFromCurrentImageContext();
    //關掉畫布
    UIGraphicsEndImageContext();
    return image;
}
@end
