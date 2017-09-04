//
//  UIViewController+ChooseImage.h
//  ZGHMS
//
//  Created by 海莱 on 15/10/23.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseImageHandler)(UIImage *img,NSError *err);

@interface UIViewController (ChooseImage)<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
-(void)chooseImageWithHandler:(ChooseImageHandler)handler;
//
-(void)showAction:(UIView *)content;

@end
