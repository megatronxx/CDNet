//
//  UIActionSheet+Blocks.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/5/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "UIActionSheet+Blocks.h"
#import <objc/runtime.h>

static char keys;


@implementation UIActionSheet (Blocks)


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CompleteActionBlock block = objc_getAssociatedObject(self, &keys);
    if (block) {
        ///block传值
        block(buttonIndex);
    }
}


// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showActionSheetWithCompleteBlock:(CompleteActionBlock) block
{
    if (block) {
        ////移除所有关联
        objc_removeAssociatedObjects(self);
        /**
         1 创建关联（源对象，关键字，关联的对象和一个关联策略。)
         2 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
         3 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。
         */
        objc_setAssociatedObject(self, &keys, block, OBJC_ASSOCIATION_COPY);
        ////设置delegate
        self.delegate = self;
    }
    ////show
    [self showInView:[[[UIApplication sharedApplication] keyWindow] window]];
}
@end

