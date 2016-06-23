//
//  PSMobileContactCell.h
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSMobileContactCell : UITableViewCell
@property (nonatomic,copy)NSString * mobile;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,strong,readonly)UIView * lineView;
@property (nonatomic,strong,readonly)UIImageView * avatarView;

+ (CGFloat)cellHeight;
+ (PSMobileContactCell*)cellWithTableView:(UITableView*)tableView;
@end
