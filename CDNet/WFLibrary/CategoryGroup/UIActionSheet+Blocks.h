//
//  UIActionSheet+Blocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 1/5/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteActionBlock) (NSInteger buttonIndex);

@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showActionSheetWithCompleteBlock:(CompleteActionBlock) block;

@end
