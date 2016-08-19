//
//  PSContactNullView.h
//  MobileBook
//
//  Created by Ryan_Man on 16/8/18.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSContactNullView : UIView
@property (nonatomic,copy)NSString * detailText;

- (instancetype)initWithSize:(CGSize)size OriginY:(CGFloat)y;

- (void)show;
- (void)disAppear;
@end
