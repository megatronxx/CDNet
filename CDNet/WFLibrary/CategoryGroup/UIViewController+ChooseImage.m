//
//  UIViewController+ChooseImage.m
//  ZGHMS
//
//  Created by 海莱 on 15/10/23.
//  Copyright (c) 2015年 海莱. All rights reserved.
//

#import "UIViewController+ChooseImage.h"
#import <objc/runtime.h>
#import "WFHead.h"

static NSString *ChooseImageKey;
@implementation UIViewController (ChooseImage)
#pragma mark - event
-(void)maskPressed:(UITapGestureRecognizer *)gesture
{
    UIView *mask = gesture.view;
    UIView *content = mask.subviews[0];
    
    [UIView animateWithDuration:0.3 animations:^{
        [content setFrame:CGRectMake(0, mask.height, content.width, content.height)];
    } completion:^(BOOL finished) {
        [mask removeFromSuperview];
    }];
}

#pragma mark - method
-(void)chooseImageWithHandler:(ChooseImageHandler)handler
{
    if (handler) {
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &ChooseImageKey, handler, OBJC_ASSOCIATION_COPY);
    }
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [action showActionSheetWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            //相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.navigationController presentViewController:picker animated:YES completion:nil];
                for (UIView *view in picker.parentViewController.view.subviews) {
                    NSLog(@"图片选择器的子视图：%@",view);
                }
                [picker setTitle:@"zx"];
            }
            else
            {
                [self showHint:@"不支持相机"];
            }
        }
        if (buttonIndex == 1) {
            //相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                for (UIView *view in picker.parentViewController.view.subviews) {
                    NSLog(@"图片选择器的子视图：%@",view);
                }
                [self.navigationController presentViewController:picker animated:YES completion:nil];
                [picker setTitle:@"xc"];
            }
            else
            {
            }
        }
    }];
}
-(void)showAction:(UIView *)content
{
    UIView *mask = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskPressed:)];
    [mask addGestureRecognizer:tap];
    [content setFrame:CGRectMake(0, mask.height, content.width, content.height)];
    [mask addSubview:content];
    [self.navigationController.view addSubview:mask];
    [UIView animateWithDuration:0.3 animations:^{
        [content setFrame:CGRectMake(0, mask.height - content.height, content.width, content.height)];
        [mask setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    }];
}

#pragma mark - 委托
#pragma mark - 相机委托
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //如果图大，等比缩放，在公有方法里
    
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    ChooseImageHandler handler = objc_getAssociatedObject(self, &ChooseImageKey);
    if (handler) {
        handler(image,nil);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}
@end
