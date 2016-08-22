//
//  PSSearchTypeMenu.m
//  MobileBook
//
//  Created by Ryan_Man on 16/8/19.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSSearchTypeMenu.h"

@interface PSSearchTypeMenu ()

@end

@implementation PSSearchTypeMenu
+ (PSSearchTypeMenu*)SearchTypeMenuWithY:(CGFloat)y
{
    PSSearchTypeMenu * menu = [[PSSearchTypeMenu alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-y)];
    return menu;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        
        self.backgroundColor = HEXCOLOR(0xebeff6);
        NSArray * titles = @[@"朋友圈",@"文章",@"公众号"];
        
        
        for (int i = 0 ; i < 3; i ++)
        {
        
            UIButton * button = NewButton();
            button.userInteractionEnabled = YES;
            
            button.tag = 1000 +i;
            button.width = HalfF(120);
            button.height = button.width;
            
            button.x = button.width * i + (self.width - button.width * 3) / 4 * (i + 1);
            
            button.y = HalfF(88);
            
            button.backgroundColor = [UIColor redColor];
            
            [button setTitle:titles[i] forState:(UIControlStateNormal)];
            [button setLayerWithCr:button.width / 2];
            
            [button addTarget:self action:@selector(clickEvent:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self addSubview:button];
            
        }
    }
    return self;
}
- (void)clickEvent:(UIButton*)sender
{
    LogFunctionName();
    if (self.SearchTypeBlock) {
        self.SearchTypeBlock (sender.tag - 1000);
    }
}


@end
