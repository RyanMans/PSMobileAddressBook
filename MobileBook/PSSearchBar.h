//
//  PSSearchBar.h
//  MobileBook
//
//  Created by Ryan_Man on 16/8/18.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,PSSearchBarStyle)
{
    PSSearchBarStyleDefault = 0,
    PSSearchBarStyleCanBack
};

@protocol PSSearchBarDelegate;
@interface PSSearchBar : UIView
@property (nonatomic,weak)id<PSSearchBarDelegate>delegate;
@property (nonatomic,assign)PSSearchBarStyle style;


+ (PSSearchBar*)searchBar;

- (void)ps_SearchBarWillBeginEditing;

- (void)ps_SearchBarWillEndEditing;


- (void)ps_CleanSearchText;

- (BOOL)ps_BecomeFirstResponder;

- (BOOL)ps_ResignFirstResponder;

- (void)ps_SearchBarStrle:(PSSearchBarStyle)style   AmiantionWithVelocity:(CGFloat)velocity;

@end

//代理
@protocol PSSearchBarDelegate <NSObject>

@optional

//点击返回按钮
- (void)ps_SearchBarBackButtonClicked:(PSSearchBar *)searchBar;

//点击取消
- (void)ps_SearchBarCancelButtonClicked:(PSSearchBar *)searchBar;

//点击搜索按钮
- (void)ps_SearchBarSearchButtonClicked:(PSSearchBar *)searchBar;

//开始编辑
- (void)ps_SearchBarTextDidBeginEditing:(PSSearchBar *)searchBar;

//结束编辑
- (void)ps_SearchBarTextDidEndEditing:(PSSearchBar *)searchBar;

//搜索的text 改变
- (void)ps_SearchBar:(PSSearchBar *)searchBar textDidChange:(NSString *)searchText;
@end
