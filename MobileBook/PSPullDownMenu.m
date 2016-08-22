//
//  PSPullDownMenu.m
//  MobileBook
//
//  Created by Ryan_Man on 16/8/22.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSPullDownMenu.h"




@interface PSPullDownMenu ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _normalTableView;

}
@property (nonatomic,strong)NSArray * allDataSource;
@end

@implementation PSPullDownMenu

+ (PSPullDownMenu*)pullDownMenuWithSource:(NSArray *)source  // dict @{@"title": @"xxxx",@"icon":@"xxx"}
{
    PSPullDownMenu * menu = [PSPullDownMenu new];
    menu.allDataSource = source;
    return menu;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        
        self.selectedIndex = 0;
        
        self.rowHeight = HalfF(88);
        
        _normalTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _normalTableView.rowHeight = self.rowHeight;
        _normalTableView.dataSource = self;
        _normalTableView.delegate = self;
        _normalTableView.showsVerticalScrollIndicator = NO;
        _normalTableView.scrollEnabled = NO;
        
        [self addSubview:_normalTableView];
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event //手指触摸事件
{
    UIView * temp = [super hitTest:point withEvent:event];
    
    if (temp == self) {
        
        [self hideMenuAnimation:YES];
    }
    return temp;
}

- (void)setAllDataSource:(NSArray *)allDataSource
{
    _allDataSource = allDataSource;
    
    [_normalTableView reloadData];
}


#pragma mark - public -

- (void)showInView:(UIView *)view underView:(UIView *)underView
{
    if (_isShow) return;
    
    self.frame = view.bounds;
    
    if (underView)
    {
        self.frame = CGRectMake(0, CGRectGetMaxY(underView.frame), view.width, view.height);
    }
    
    [view addSubview:self];

    _normalTableView.frame = CGRectMake(0, 0, self.width, 0);
    
    [self animateTableView:_normalTableView show:YES complete:^{
        
    }];
    _isShow = YES;
    
    if (self.pullDownMenuShowHideBlock) {
        self.pullDownMenuShowHideBlock(_isShow);
    }
    
}

- (void)hideMenuAnimation:(BOOL)animation
{
    if (!_isShow) return;

    if (animation)
    {
        [self  animateTableView:_normalTableView show:NO complete:^{
            
            [self removeFromSuperview];
        }];
    }
    else
    {
        [self animateTableView:_normalTableView show:NO complete:^{
            
        }];
        
        [self removeFromSuperview];
    }
    
    _isShow = NO;
    
    if (self.pullDownMenuShowHideBlock) {
        self.pullDownMenuShowHideBlock(_isShow);
    }
}


#pragma mark - function Method -
- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete
{
    
    if (show)
    {
        tableView.frame = CGRectMake(tableView.x, tableView.y, tableView.width, 0);
        
//        NSInteger num = [tableView numberOfRowsInSection:0];
//        if (num > 5) {
//            num = 5;
//        }
        
        CGFloat tableViewHeight = tableView.rowHeight * _allDataSource.count;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            
            tableView.frame = CGRectMake(tableView.x, tableView.y, tableView.width, tableViewHeight);
            
        } completion:^(BOOL finished) {
            
            complete();
        }];
        
      return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backgroundColor = [UIColor clearColor];
        tableView.frame = CGRectMake(tableView.x, tableView.y, tableView.width, 0);

        
    } completion:^(BOOL finished) {
        
        complete();

    }];
}

#pragma mark -UITableViewDelegate UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allDataSource.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellIdentity = @"PSPullDownMenuCellId";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentity];
        
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.separatorInset = UIEdgeInsetsZero;
    
    NSDictionary *dic = _allDataSource[indexPath.row];
    
    cell.textLabel.text = dic[@"title"];
    cell.imageView.image = [UIImage imageNamed:dic[@"icon"]];
    
    if (indexPath.row == _selectedIndex) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nd_sort_tick"]];
        iv.frame = (CGRect){0,0,18,12};
        cell.accessoryView = iv;
    }
    else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    lastCell.accessoryView = nil;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nd_sort_tick"]];
    iv.frame = (CGRect){0,0,19,13};
    cell.accessoryView = iv;
    
    
    _selectedIndex = indexPath.row;
    
    if (self.pullDownMenuActionBlock) {
        self.pullDownMenuActionBlock(_selectedIndex);
    }
    
    [self hideMenuAnimation:YES];

}

@end
