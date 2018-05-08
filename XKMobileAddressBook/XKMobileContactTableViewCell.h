//
//  XKMobileContactTableViewCell.h
//  XKMobileAddressBook
//
//  Created by Allen、 LAS on 2018/5/8.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKMobileContactModel.h"
@interface XKMobileContactTableViewCell : UITableViewCell
@property (nonatomic,strong)XKMobileContactModel * statusModel;

+ (XKMobileContactTableViewCell*)xk_CellWithTableView:(UITableView *)tableView;
@end

//分区
@interface XKMobileHeaderInSectionView : UIView
+ (XKMobileHeaderInSectionView*)xk_MobileHeaderInSectionView:(NSString *)letter;
@end

//索引
@interface XKMobileLetterSectionIndexView : UIView

- (void)animationsLetterDisplay:(NSString*)letter;

@end
