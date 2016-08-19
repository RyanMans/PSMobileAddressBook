//
//  PSContactNullView.m
//  MobileBook
//
//  Created by Ryan_Man on 16/8/18.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSContactNullView.h"
@interface PSContactNullView ()
{
    UILabel * _detailTextLabel;
}
@end
@implementation PSContactNullView

- (instancetype)initWithSize:(CGSize)size OriginY:(CGFloat)y
{
    self = [super initWithFrame:CGRectMake( 0, y, size.width, size.height )];
    if (self) {
        
        self.clipsToBounds = YES;
        self.hidden = YES;
        
        self.backgroundColor =  RGB(235, 239, 246);
        
        UIImage * headImage = [UIImage imageNamed:@"search_contact"];
        
        UIImageView * contactView = [UIImageView new];
        contactView.contentMode = UIViewContentModeScaleToFill;
        contactView.image = headImage;
        contactView.size = headImage.size;
        contactView.y = 90;
        contactView.x = (self.width - headImage.size.width) / 2;
        [self addSubview:contactView];
        
        
        _detailTextLabel = [UILabel new];
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
        _detailTextLabel.textColor = RGB(37, 177, 232);
        _detailTextLabel.font = FontOfSize(14);
        _detailTextLabel.width = self.width;
        _detailTextLabel.height = 30;
        _detailTextLabel.y = CGRectGetMaxY(contactView.frame) + 23;
        _detailTextLabel.x = 0 ;
        _detailTextLabel.text = @"请输入姓名、手机号进行搜索";
        [self addSubview:_detailTextLabel];
        
    }
    return self;
}

- (void)show
{
    self.hidden = NO;
//    [self.superview bringSubviewToFront:self];
}

- (void)disAppear
{
    self.hidden = YES;
//    [self.superview sendSubviewToBack:self];
}

- (void)setDetailText:(NSString *)detailText
{
    _detailText = detailText;
    _detailTextLabel.text = _detailText;
}


@end
