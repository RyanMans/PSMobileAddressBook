//
//  PSSearchBar.h
//  MobileBook
//
//  Created by Ryan_Man on 16/8/18.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSSearchBar : UIView
@property (nonatomic,strong,readonly)UITextField * textfield;
@property (nonatomic,assign)BOOL isSearchState;
@property (nonatomic,copy)void (^cancelBlock)();
@property (nonatomic,copy)void (^seachBlock)(NSString* text);
@property (nonatomic,assign)NSInteger type;

+ (PSSearchBar*)searchBar;

@end
