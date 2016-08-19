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
}
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
        _seachContentView.backgroundColor = HEXCOLOR(0xebeff6);
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
        
        _placeholderW = [_textfield.placeholder sizeWithAttributes:@{NSFontAttributeName:_textfield.font}].width;
        
        self.isSearchState = YES;

    }
    return self;
}

- (void)backEvent:(UIButton*)sender
{
    self.type = 0;
    
}

- (void)setType:(NSInteger)type
{
    
    if (type == 0)
    {
        [UIView animateWithDuration:0.25f animations:^{
            
            _backButton.x = - _backButton.width;
            _seachContentView.x = HalfF(30);
            _seachContentView.width = _cancelButton.x - HalfF(25) - _seachContentView.x;
        }];
        
    }
    
    else if (type == 1)
    {
        [UIView animateWithDuration:0.25f animations:^{
            
            _backButton.x = 0;
            _seachContentView.x = CGRectGetMaxX(_backButton.frame);
            _seachContentView.width = _cancelButton.x - HalfF(25) - _seachContentView.x;
        }];
        
    }
}

- (void)tapSearchEvent:(UITapGestureRecognizer*)aTap
{
    if (_isSearchState) return;
    
    [_textfield becomeFirstResponder];
}

- (void)setIsSearchState:(BOOL)isSearchState
{
    _isSearchState = isSearchState;
    
    if (_isSearchState)
    {
        [self textFieldWillBeginEditing];
    }
    else
    {
        [self textFieldWillEndEditing];
    }
}

- (void)textFieldWillBeginEditing
{
    LogFunctionName();
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _searchImageView.x = HalfF(10);
        _textfield.x = CGRectGetMaxX(_searchImageView.frame) + HalfF(10);
        _textfield.width = _cleanButton.x - _textfield.x - HalfF(10);
        
    }];
}

- (void)textFieldWillEndEditing
{
    LogFunctionName();

    
    [UIView animateWithDuration:0.25f animations:^{
        
       CGFloat w = _searchImageView.width + _placeholderW + HalfF(20);

        _searchImageView.x = _seachContentView.centerX - w / 2 ;
        
        _textfield.x = CGRectGetMaxX(_searchImageView.frame) +  HalfF(10);
        _textfield.width = _cleanButton.x - _textfield.x - HalfF(10);
    }];
}



- (void)cancelEvent:(UIButton*)sender
{
    LogFunctionName();
    

    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)cleanEvent:(UIButton*)sender
{
    _cleanButton.hidden = YES;
    _textfield.text = @"";
}

BOOL isChineseTextInputMode()
{
    NSString * lang =  [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if (IsSameString(lang, @"zh-Hans")) return YES ;
    return NO;
}

- (void)textFieldTextDidChange:(NSNotification*)noti
{
    NSString * text =  _textfield.text;
    
    _cleanButton.hidden =  text.length == 0 ? YES : NO ;

     BOOL isChina = isChineseTextInputMode();
    
    if (isChina == YES)
    {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_textfield markedTextRange];
        UITextPosition *position = [_textfield positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (self.seachBlock) {
                self.seachBlock(text);
            }
        };
    }
    else
    {
        if (self.seachBlock) {
            self.seachBlock(text);
        }
    };

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}



@end
