//
//  PSHeaderInSectionView.m
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSHeaderInSectionView.h"

@interface PSHeaderInSectionView ()
{
    UILabel * _titleLabel;
}
@end
@implementation PSHeaderInSectionView

+ (PSHeaderInSectionView*)viewForHeaderInSectionH:(CGFloat)height
{
    PSHeaderInSectionView * sectionView = [[PSHeaderInSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    return sectionView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = RGB(235, 237, 240);
        _titleLabel = [UILabel  new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = RGB(102, 102, 102);
        _titleLabel.font = [UIFont systemFontOfSize:HalfF(28)];
        _titleLabel.frame = self.bounds;
        _titleLabel.x = HalfF(30);
        _titleLabel.width = self.width - 2 * _titleLabel.x;
        [self addSubview:_titleLabel];
    }
    return self;
}
- (void)setText:(NSString *)text
{
    _text = text;
    if (_titleLabel) _titleLabel.text = _text;
}
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    if (_titleLabel)_titleLabel.textColor = _textColor;
}
- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    if (_titleLabel)_titleLabel.font = _textFont;
}

- (void)setLeftInsetsX:(CGFloat)leftInsetsX
{
    _leftInsetsX = leftInsetsX;
    if (_titleLabel) _titleLabel.x = _leftInsetsX;
}
- (void)setTextHeight:(CGFloat)textHeight
{
    _textHeight = textHeight;
    if (_titleLabel) _titleLabel.height = _textHeight;
}
@end
