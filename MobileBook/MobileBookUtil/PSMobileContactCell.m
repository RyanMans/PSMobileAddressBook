//
//  PSMobileContactCell.m
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSMobileContactCell.h"

#define CELL_ROE_HEIGHT  65

@interface PSMobileContactCell ()
{
    UILabel * _nameLabel;
    
    UILabel * _mobileLabel;
    
}
@end
@implementation PSMobileContactCell
+ (PSMobileContactCell*)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellIdentity = @"PSMobileContactCellId";
    PSMobileContactCell * mcell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!mcell)
    {
        mcell = [[PSMobileContactCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentity];
    }
    return mcell;
}

+ (CGFloat)cellHeight
{
    return CELL_ROE_HEIGHT;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.userInteractionEnabled = YES;
        
        _avatarView = NewClass(UIImageView);
        _avatarView.image =[UIImage imageNamed:@"userhead"];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.clipsToBounds = YES;
        _avatarView.width = HalfF(90);
        _avatarView.height = _avatarView.width;
        _avatarView.x = HalfF(30);
        _avatarView.y = (CELL_ROE_HEIGHT - _avatarView.height) / 2;
        [_avatarView setLayerWithCr:5.0f];
        [self.contentView addSubview:_avatarView];
        
        _nameLabel = NewClass(UILabel);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = FontOfSize(16);
        _nameLabel.textColor = RGB(102, 102, 102);
        _nameLabel.x = CGRectGetMaxX(_avatarView.frame) + HalfF(20);
        _nameLabel.y = _avatarView.y;
        _nameLabel.height = HalfF(34);
        _nameLabel.width = SCREEN_WIDTH - _nameLabel.x - HalfF(30);
        [self.contentView addSubview:_nameLabel];
        
        
        _mobileLabel = NewClass(UILabel);
        _mobileLabel.textAlignment = NSTextAlignmentLeft;
        _mobileLabel.font = FontOfSize(14);
        _mobileLabel.textColor = RGB(102, 102, 102);
        _mobileLabel.x = _nameLabel.x;
        _mobileLabel.width = _nameLabel.width;
        _mobileLabel.height = HalfF(30);
        _mobileLabel.y = CGRectGetMaxY(_avatarView.frame) - _mobileLabel.height;
        [self.contentView addSubview:_mobileLabel];
        
        _lineView = NewClass(UIView);
        _lineView.backgroundColor = HEXCOLOR(0xdadfe6);
        _lineView.height = 1.0;
        _lineView.x = _nameLabel.x;
        _lineView.y = CELL_ROE_HEIGHT - _lineView.height;
        _lineView.width = SCREEN_WIDTH - _lineView.x;
        [self.contentView addSubview:_lineView];
        
        
        
        
        
    }
    return self;
}
- (void)setMobile:(NSString *)mobile
{
    _mobile = mobile;
    _mobileLabel.text = _mobile;
}
- (void)setName:(NSString *)name
{
    _name = name;
    _nameLabel.text = _name;
}

@end
