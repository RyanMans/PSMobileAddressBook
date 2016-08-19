//
//  PSCustomViewController.m
//  MobileBook
//
//  Created by Ryan_Man on 16/8/18.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSCustomViewController.h"
#import "PSCustomMenu.h"
#import "PSSearchBar.h"

@interface PSCustomViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    PSCustomMenu * _menu;
    
    PSSearchBar * _searchBar;
    
    UITableView * _displayTableView;
    
    NSMutableArray * _allDataSource;
    
    BOOL _isSearchState;
        
   CGPoint  _panGestureStartLocation;
    
}
@end

@implementation PSCustomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self  setupMenu];
 
    [self  setupTableView];
    
    [self  loadAllDataSource];
}

- (void)setupMenu
{
    weakSelf(ws);
    _menu = [[PSCustomMenu alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HalfF(88))];
    _menu.ClickMeunBlock = ^(NSInteger type)
    {
        [ws clickType:type];
    };
    [self.view addSubview:_menu];
}

- (void)setupTableView
{
    _displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _menu.height, SCREEN_WIDTH, VALID_VIEW_HEIGHT - _menu.height)];
    _displayTableView.delegate = self;
    _displayTableView.dataSource = self;
    _displayTableView.showsVerticalScrollIndicator = NO;
    _displayTableView.backgroundColor =  RGB(248, 248, 248);
    [self.view addSubview:_displayTableView];
}

- (void)loadAllDataSource
{
    _allDataSource = NewMutableArray();
    
    while (_allDataSource.count < 20) {
    
        [_allDataSource addObject:@"1"];
    }
    [_displayTableView reloadData];
    
}

- (void)clickType:(NSInteger)type
{
    LogFunctionName();
    
    //搜索
    if (type == 1)
    {
        
        [self showSearchMode:YES];
        
    }
    //展开列表
    else if (type == 2)
    {
        
        [self showSearchMode:NO];
    }
}

- (void)showSearchMode:(BOOL)isSearch
{
    if (_isSearchState == isSearch) return;
    
    _isSearchState = isSearch;
    
    if (_isSearchState)
    {
        if (!_searchBar) {
            
            weakSelf(ws);
            _searchBar = [PSSearchBar searchBar];
            _searchBar.cancelBlock = ^()
            {
                [ws showSearchMode:NO];
            };
        }
        
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, HalfF(128));
        _searchBar.transform = CGAffineTransformMakeScale(0, 0.4);
        [self.view addSubview:_searchBar];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        [UIView animateWithDuration:0.3f animations:^{
          
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            _searchBar.transform = CGAffineTransformMakeScale(1, 1);
            _displayTableView.y = 64;
            
        } completion:^(BOOL finished) {
            
            [_searchBar.textfield becomeFirstResponder];
        }];
        
        return;
    }
    
    _searchBar.textfield.text = nil;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        _searchBar.height = _menu.height;
        _searchBar.transform = CGAffineTransformMakeScale(0.01, 1);
        _displayTableView.y = _menu.height;
        
    } completion:^(BOOL finished) {
        
        [_searchBar.textfield resignFirstResponder];
        _searchBar.transform = CGAffineTransformMakeScale(1, 1);

        [_searchBar removeFromSuperview];
    }];
    
}

- (void)resumeFromSearch
{
    _searchBar.textfield.text = nil;
    
}

#pragma mark - UITableViewDelegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allDataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentity = @"PSCustomCellId";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellIdentity];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"PSCustomCell -- %ld",(long)indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
