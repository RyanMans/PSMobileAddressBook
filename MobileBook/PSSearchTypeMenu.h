//
//  PSSearchTypeMenu.h
//  MobileBook
//
//  Created by Ryan_Man on 16/8/19.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSSearchTypeMenu : UIScrollView
+ (PSSearchTypeMenu*)SearchTypeMenuWithY:(CGFloat)y;

@property (nonatomic,copy)void(^SearchTypeBlock)(NSInteger tag);
@end
