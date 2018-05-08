//
//  XKMobileContactTableViewCell.m
//  XKMobileAddressBook
//
//  Created by Allen、 LAS on 2018/5/8.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import "XKMobileContactTableViewCell.h"
#import "masonry.h"
@interface XKMobileContactTableViewCell ()
@property (nonatomic,strong)UIImageView * avatarImageView;
@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * mobileNumberLabel;
@end

@implementation XKMobileContactTableViewCell

+ (XKMobileContactTableViewCell*)xk_CellWithTableView:(UITableView *)tableView{
    
    static NSString * cellIdentity = @"XKMobileContactTableViewCellld";
    
    XKMobileContactTableViewCell * xkCell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!xkCell) {
        xkCell = [[XKMobileContactTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentity];
    }
    return xkCell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.mobileNumberLabel];

        __weak typeof(self) ws = self;
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView).offset(16);
            make.size.mas_equalTo(CGSizeMake(45, 45));
            make.centerY.equalTo(ws.contentView);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.avatarImageView.mas_right).offset(10);
            make.top.equalTo(ws.avatarImageView);
            make.right.equalTo(ws.contentView).offset(-16);
        }];
        
        [self.mobileNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.nameLabel);
            make.right.equalTo(ws.nameLabel);
            make.bottom.equalTo(ws.avatarImageView);
        }];

    }
    return self;
}

- (void)setStatusModel:(XKMobileContactModel *)statusModel{
    _statusModel = statusModel;
    
    _nameLabel.text = _statusModel.name;
    _mobileNumberLabel.text = _statusModel.mobile;
}

- (UIImageView*)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.image =[UIImage imageNamed:@"userhead"];
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.layer.masksToBounds = YES; //没这句话它圆不起来
        _avatarImageView.layer.cornerRadius = 5; //设置图片圆角的尺度。
    }
    return _avatarImageView;
}

- (UILabel*)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor lightGrayColor];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UILabel*)mobileNumberLabel{
    if (!_mobileNumberLabel) {
        _mobileNumberLabel = [UILabel new];
        _mobileNumberLabel.font = [UIFont systemFontOfSize:14];
        _mobileNumberLabel.textColor = [UIColor lightGrayColor];
        _mobileNumberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _mobileNumberLabel;
}

- (void)dealloc{
    _avatarImageView = nil;
    _nameLabel = nil;
    _mobileNumberLabel = nil;
}
@end

//分区
@interface XKMobileHeaderInSectionView ()
@property (nonatomic,strong)UILabel * letterLabel;
@end

@implementation XKMobileHeaderInSectionView

+ (XKMobileHeaderInSectionView*)xk_MobileHeaderInSectionView:(NSString *)letter{
    
    XKMobileHeaderInSectionView * temp = [[XKMobileHeaderInSectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    temp.letterLabel.text = letter;
    return temp;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        __weak typeof(self) ws = self;
        
        [self addSubview:self.letterLabel];
        
        [self.letterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws).offset(16);
            make.right.equalTo(ws).offset(-16);
            make.top.equalTo(ws);
            make.bottom.equalTo(ws);
        }];
    }
    return self;
}

- (UILabel*)letterLabel{
    
    if (!_letterLabel) {
        _letterLabel = [UILabel new];
        _letterLabel.font = [UIFont systemFontOfSize:14];
        _letterLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _letterLabel;
}

- (void)dealloc{
    _letterLabel = nil;
}
@end



@interface XKMobileLetterSectionIndexView ()
@property (nonatomic,strong)UILabel * letterLabel;
@end

@implementation XKMobileLetterSectionIndexView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.hidden = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        self.layer.masksToBounds = YES; //没这句话它圆不起来
        self.layer.cornerRadius = 10; //设置图片圆角的尺度。

        __weak typeof(self) ws = self;
        
        [self addSubview:self.letterLabel];
        
        [self.letterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ws);
        }];
    }
    return self;
}

- (void)animationsLetterDisplay:(NSString*)letter{
    
    _letterLabel.text = letter;
    self.hidden = NO;
    [UIView beginAnimations:@"LetterDisplayView" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.alpha = 1.0;
    self.alpha = 0.0;
    [UIView commitAnimations];
}

- (UILabel*)letterLabel{
    
    if (!_letterLabel) {
        _letterLabel = [UILabel new];
        _letterLabel.font = [UIFont systemFontOfSize:15];
        _letterLabel.textColor = [UIColor whiteColor];
        _letterLabel.textAlignment = NSTextAlignmentCenter;
        _letterLabel.backgroundColor = [UIColor clearColor];
    }
    return _letterLabel;
}

- (void)dealloc{
    _letterLabel = nil;
}
@end

