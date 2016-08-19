//
//  PSCustomMenu.m
//  MobileBook
//
//  Created by Ryan_Man on 16/8/18.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSCustomMenu.h"
@interface PSCustomMenu ()
{
    UIButton * _searchBtn;
    UIButton * _timeBtn;
}
@end
@implementation PSCustomMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        
        _searchBtn = NewButton();
        _searchBtn.tag = 1;
        _searchBtn.userInteractionEnabled = YES;
        _searchBtn.titleLabel.font = FontOfSize(12);
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:HEXCOLOR(0x82939e) forState:UIControlStateNormal];
        [_searchBtn setImage:[UIImage imageNamed:@"nd_icon_search"] forState:UIControlStateNormal];
        
        _searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _searchBtn.contentMode = UIViewContentModeScaleToFill;
        [_searchBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        _searchBtn.frame = CGRectMake(0, 0, self.width / 2, self.height);

        [self addSubview:_searchBtn];
        
        UIView * space_line = NewClass(UIView);
        space_line.backgroundColor = HEXCOLOR(0xEAEAEA);
        space_line.frame = CGRectMake(CGRectGetMaxX(_searchBtn.frame), 10, 1, self.height - 20);
        [self addSubview:space_line];
        
        _timeBtn = NewButton();
        _timeBtn.userInteractionEnabled = YES;
        _timeBtn.tag = 2;
        _timeBtn.frame = CGRectMake(CGRectGetMaxX(space_line.frame), 0, _searchBtn.width, _searchBtn.height);
        _timeBtn.titleLabel.font = FontOfSize(12);
        [_timeBtn setTitle:@"按时间" forState:UIControlStateNormal];
        [_timeBtn setTitleColor:HEXCOLOR(0x82939e) forState:UIControlStateNormal];
        [_timeBtn setImage:[UIImage imageNamed:@"nd_order_time_small"] forState:UIControlStateNormal];
        _timeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_timeBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_timeBtn];
        
                
        UIView * line = NewClass(UIView);
        line.frame = CGRectMake(0, self.height - 1, self.width, 1);
        line.backgroundColor = HEXCOLOR(0xEAEAEA);
        [self addSubview:line];
    }
    return self;
}

- (void)clickEvent:(UIButton*)sender
{
    if (self.ClickMeunBlock) {
        self.ClickMeunBlock (sender.tag);
    }
    
}
@end
