//
//  PSCustomMenu.h
//  MobileBook
//
//  Created by Ryan_Man on 16/8/18.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSCustomMenu : UIView
@property (nonatomic,copy)void(^ClickMeunBlock)(NSInteger tag);
@end
