//
//  PSSearchBar.m
//  MobileBook
//
//  Created by Ryan_Man on 16/8/18.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSSearchBar.h"
@interface PSSearchBar ()<UITextFieldDelegate>
{
    UIButton * _backButton;
    
    UIImageView * _searchImageView;
    
    UIButton * _cancelButton;
    
    UIButton * _cleanButton;
    
    UIView * _seachContentView;
    
    
    CGFloat _placeholderW;
    
    CGFloat _lastVerioty;
    
}
@property (nonatomic,strong,readonly)UITextField * textfield;
@end
@implementation PSSearchBar

+ (PSSearchBar*)searchBar
{
    return [[PSSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HalfF(128))];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = HEXCOLOR(0xf8f8f9);
        self.layer.anchorPoint = CGPointMake(0, 0.5); //修改中心点，圆轴
        
        _backButton = NewClass(UIButton);
        _backButton.backgroundColor = [UIColor clearColor];
        _backButton.height = HalfF(88);
        _backButton.width = HalfF(60);
        _backButton.x = - _backButton.width;
        _backButton.y = HalfF(40);
        [_backButton setTitle:@"<" forState:(UIControlStateNormal)];
        _backButton.titleLabel.font = FontOfSize(20);
        [_backButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        _backButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        [_backButton addTarget:self action:@selector(backEvent:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:_backButton];
        
        //取消按钮
        _cancelButton = NewButton();
        [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelButton setTitleColor:HEXCOLOR(0x007aff) forState:(UIControlStateNormal)];
        [_cancelButton  addTarget:self action:@selector(cancelEvent:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _cancelButton.width = HalfF(88);
        _cancelButton.height = _cancelButton.width;
        _cancelButton.x = self.width - _cancelButton.width - HalfF(25);
        _cancelButton.y = HalfF(40);
        _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_cancelButton];

        
        //背景
        _seachContentView = NewClass(UIView);
        _seachContentView.backgroundColor =  HEXCOLOR(0x007aff); // HEXCOLOR(0xebeff6);
        _seachContentView.x = HalfF(30);
        _seachContentView.y = HalfF(50);
        _seachContentView.width = _cancelButton.x - HalfF(25) - _seachContentView.x;
        _seachContentView.height = HalfF(60);
        _seachContentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_seachContentView setLayerWithCr:5.0];
        [self addSubview:_seachContentView];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearchEvent:)];
        [_seachContentView addGestureRecognizer:tap];
        
        
        //搜索图标
        _searchImageView = NewClass(UIImageView);
        _searchImageView.contentMode = UIViewContentModeScaleAspectFit;
        _searchImageView.image = [UIImage imageNamed:@"nd_icon_search"];;
        _searchImageView.width = HalfF(30);
        _searchImageView.height = HalfF(30);;
        _searchImageView.x = HalfF(10);
        _searchImageView.y = (_seachContentView.height - _searchImageView.height) / 2;
        _searchImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_seachContentView addSubview:_searchImageView];
        
        
        //清除按钮
        
        _cleanButton = NewButton();
        _cleanButton.userInteractionEnabled = YES;
        _cleanButton.width = HalfF(30);
        _cleanButton.height = HalfF(30);
        _cleanButton.x = _seachContentView.width - _cleanButton.width - HalfF(10);
        _cleanButton.y = (_seachContentView.height - _cleanButton.height) / 2;
        [_cleanButton setImage:[UIImage imageNamed:@"icon_grxx_sr_gb"] forState:(UIControlStateNormal)];
        [_cleanButton addTarget:self action:@selector(cleanEvent:) forControlEvents:(UIControlEventTouchUpInside)];
        _cleanButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _cleanButton.contentMode = UIViewContentModeScaleAspectFit;
        [_seachContentView addSubview:_cleanButton];
        
        
        //输入
        _textfield = NewClass(UITextField);
        _textfield.backgroundColor = [UIColor clearColor];
        _textfield.delegate = self;
        _textfield.returnKeyType = UIReturnKeySearch;
        _textfield.placeholder = @"请输入关键字";
        _textfield.font = FontOfSize(13);
        
        
        _textfield.x = CGRectGetMaxX(_searchImageView.frame) + HalfF(10);
        _textfield.y = 0 ;
        _textfield.width = _cleanButton.x - _textfield.x - HalfF(10);
        _textfield.height = _seachContentView.height;
        
        _textfield.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        [_seachContentView addSubview:_textfield];
        
        _cleanButton.hidden = YES;
    
        UIView * line = NewClass(UIView);
        line.backgroundColor = HEXCOLOR(0xEAEAEA);
        line.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
        
        [self addSubview:line];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
        [self ps_SearchBarWillBeginEditing];
        
        self.style = PSSearchBarStyleDefault;
    }
    return self;
}

#pragma mark - 属性 -

- (void)setStyle:(PSSearchBarStyle)style
{

    _style = style;
    
    [self animationStart:_style];
}
- (void)animationStart:(PSSearchBarStyle)style
{
    
    _backButton.hidden = style == PSSearchBarStyleDefault;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        if (style == PSSearchBarStyleDefault)
        {
            _backButton.x = - _backButton.width;
            _seachContentView.x = HalfF(30);
            _seachContentView.width = _cancelButton.x - HalfF(25) - _seachContentView.x;
            
        }
        else if (style == PSSearchBarStyleCanBack)
        {
            _backButton.x = 0;
            _seachContentView.x = CGRectGetMaxX(_backButton.frame);
            _seachContentView.width = _cancelButton.x - HalfF(25) - _seachContentView.x;
            
        }
        
    }];

}

- (void)ps_SearchBarStrle:(PSSearchBarStyle)style AmiantionWithVelocity:(CGFloat)velocity
{
    
    if (style == PSSearchBarStyleDefault) return;
    
    if (velocity == 0 || velocity < 0)
    {
        [self animationStart:PSSearchBarStyleCanBack];
        return;
    }
    if (velocity == SCREEN_HEIGHT)
    {
        [self animationStart:PSSearchBarStyleDefault];
        return;
    }

    CGFloat max_W = _seachContentView.x;
    CGFloat distance = max_W  * (velocity / SCREEN_HEIGHT) * 0.4;
    
    NSLog(@"distance -- %f",distance);
    
    [UIView animateWithDuration:0.25f animations:^{
        
        if (_lastVerioty > velocity)
        {
            _backButton.x = _backButton.x + distance * 1.08;
            _seachContentView.x = _seachContentView.x + distance;
            
            if (_backButton.x >= 0) {
                _backButton.x = 0;
            }
            if (_seachContentView.x >= _backButton.width)
            {
                _seachContentView.x = _backButton.width;
            }
            
        }
        else
        {
            _backButton.x = _backButton.x - distance  * 1.08;
            _seachContentView.x = _seachContentView.x - distance;
            
            if (_backButton.x <= -_backButton.width)
            {
                _backButton.x = - _backButton.width;
            }
            
            if (_seachContentView.x <= HalfF(30))
            {
                _seachContentView.x = HalfF(30);
            }
        }
        
        _seachContentView.width = _cancelButton.x - HalfF(25) - _seachContentView.x;
    }];
    
    _lastVerioty = velocity;

}

#pragma mark - 事件 -
- (void)ps_SearchBarWillBeginEditing
{
    LogFunctionName();
    [UIView animateWithDuration:0.25f animations:^{
        
        _searchImageView.x = HalfF(10);
        _textfield.x = CGRectGetMaxX(_searchImageView.frame) + HalfF(10);
        _textfield.width = _cleanButton.x - _textfield.x - HalfF(10);
        
    }];
}

- (void)ps_SearchBarWillEndEditing
{
    LogFunctionName();
    
    _placeholderW = [_textfield.placeholder sizeWithAttributes:@{NSFontAttributeName:_textfield.font}].width;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        CGFloat w = _searchImageView.width + _placeholderW + HalfF(20);
        
        _searchImageView.x =  _seachContentView.centerX - (w + _searchImageView.width + 20) / 2;
        _textfield.x = CGRectGetMaxX(_searchImageView.frame) +  HalfF(10);
        _textfield.width = _cleanButton.x - _textfield.x - HalfF(10);
    }];
}

- (BOOL)ps_BecomeFirstResponder
{
    return [_textfield becomeFirstResponder];
}

- (BOOL)ps_ResignFirstResponder
{
    return [_textfield resignFirstResponder];
}

- (void)ps_CleanSearchText
{
    [self cleanEvent:nil];
}

- (void)tapSearchEvent:(UITapGestureRecognizer*)aTap
{
    if ([_textfield isFirstResponder] == YES) return;

    [self ps_BecomeFirstResponder];
}

- (void)backEvent:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ps_SearchBarBackButtonClicked:)])
    {
        [self animationStart:PSSearchBarStyleDefault];
        [self.delegate ps_SearchBarBackButtonClicked:self];
    }
}

- (void)cancelEvent:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ps_SearchBarCancelButtonClicked:)])
    {
        [self animationStart:PSSearchBarStyleDefault];
        [self.delegate ps_SearchBarCancelButtonClicked:self];
    }
}

- (void)cleanEvent:(UIButton*)sender
{
    _cleanButton.hidden = YES;
    _textfield.text = @"";
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ps_SearchBar:textDidChange:)])
    {
        [self.delegate ps_SearchBar:self textDidChange:@""];
    }

}

#pragma mark -代理-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self ps_SearchBarWillBeginEditing];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self ps_SearchBarWillEndEditing];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ps_SearchBarTextDidBeginEditing:)])
    {
        [self.delegate ps_SearchBarTextDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ps_SearchBarTextDidEndEditing:)])
    {
        [self ps_CleanSearchText];
        [self.delegate ps_SearchBarTextDidEndEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ps_SearchBarSearchButtonClicked:)])
    {
        [self.delegate ps_SearchBarSearchButtonClicked:self];
    }
    return YES;
}
//是否为中文
- (BOOL)isChineseTextInputMode
{
    NSString * lang =  [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if (IsSameString(lang, @"zh-Hans")) return YES ;
    return NO;
}

- (void)textFieldTextDidChange:(NSNotification*)noti
{
    NSString * text =  _textfield.text;
    
    _cleanButton.hidden =  text.length == 0 ? YES : NO ;

     BOOL isChina = [self isChineseTextInputMode];
    
    
    if (isChina == NO)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ps_SearchBar:textDidChange:)])
        {
            [self.delegate ps_SearchBar:self textDidChange:text];
        }
        return;
    }
    
    // 简体中文输入，包括简体拼音，健体五笔，简体手写
    UITextRange *selectedRange = [_textfield markedTextRange];
    UITextPosition *position = [_textfield positionFromPosition:selectedRange.start offset:0];

    // 没有高亮选择的字

    if (!position)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ps_SearchBar:textDidChange:)])
        {
            [self.delegate ps_SearchBar:self textDidChange:text];
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}



@end
