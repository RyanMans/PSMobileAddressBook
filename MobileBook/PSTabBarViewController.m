//
//  PSTabBarViewController.m
//  MobileBook
//
//  Created by Ryan_Man on 16/8/18.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSTabBarViewController.h"
#import "PSMobileBookViewController.h"
#import "PSCustomViewController.h"
@interface PSTabBarViewController ()

@end

@implementation PSTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //手机通讯录
    
    PSMobileBookViewController * mobileVC = NewClass(PSMobileBookViewController);
    [self addChildVC:mobileVC WithTitle:@"手机通讯录" WithImageName:nil WithSelectedImageName:nil];
     mobileVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:(UITabBarSystemItemBookmarks) tag:0];
    
    
    //自定义
    
    PSCustomViewController * customVC = NewClass(PSCustomViewController);
    [self addChildVC:customVC WithTitle:@"自定义动画" WithImageName:nil WithSelectedImageName:nil];
    customVC.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:(UITabBarSystemItemBookmarks) tag:1];
}

//添加子控制器
-(void)addChildVC:(UIViewController*)childVC WithTitle:(NSString*)title WithImageName:(NSString*)imageName WithSelectedImageName:(NSString*)selectedImageName
{
    LogFunctionName();
    //标题
    childVC.title = title;
    
    //图片
    childVC.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    childVC.tabBarItem.selectedImage = selectedImage;
    
    //基类导航
    UINavigationController * navigationVC = [[UINavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:navigationVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
