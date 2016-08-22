//
//  PSPyqView.m
//  MobileBook
//
//  Created by Ryan_Man on 16/8/19.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSPyqView.h"

@implementation PSPyqView

+ (PSPyqView*)ps_PyqViewWithY:(CGFloat)y
{
    PSPyqView * menu = [[PSPyqView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_WIDTH-y)];
    return menu;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
 
        self.backgroundColor =[UIColor purpleColor]; //HEXCOLOR(0xebeff6);
        
        
        NSArray * titles = @[@"一周朋友精选",@"朋友分享的音乐"];
        
        
        for (int i = 0 ; i < 2; i ++)
        {
            
            UIButton * button = NewButton();
            button.userInteractionEnabled = YES;
            
            button.tag = 1000 +i;
            button.width = HalfF(260);
            button.height = HalfF(60);
            
            button.x = button.width * i + (self.width - button.width * 2) / 4 * (i + 1);
            
            button.y = HalfF(88);
            
            button.backgroundColor = [UIColor orangeColor];
            
            [button setTitle:titles[i] forState:(UIControlStateNormal)];
            
            [button setLayerWithCr:10.0f];
//            [button addTarget:self action:@selector(clickEvent:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self addSubview:button];
            
        }

        
        
    }
    return self;
}

@end
