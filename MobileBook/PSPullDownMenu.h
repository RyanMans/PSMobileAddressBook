//
//  PSPullDownMenu.h
//  MobileBook
//
//  Created by Ryan_Man on 16/8/22.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSPullDownMenu : UIView
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign)CGFloat rowHeight;

@property (nonatomic,assign)BOOL isShow;

@property (nonatomic,copy)void(^pullDownMenuShowHideBlock)(BOOL isShow);
@property (nonatomic,copy)void (^pullDownMenuActionBlock)(NSInteger selectedIndex);


+ (PSPullDownMenu *)pullDownMenuWithSource:(NSArray *)source;

- (void)showInView:(UIView *)view underView:(UIView*)underView;

- (void)hideMenuAnimation:(BOOL)animation;

@end
