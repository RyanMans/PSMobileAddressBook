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

#import "PSPyqView.h"
#import "PSSearchTypeMenu.h"
#import "PSPullDownMenu.h"

static const NSTimeInterval kISControllerAnimationDuration = 0.5;
static const CGFloat kISControllerOpeningAnimationSpringDamping = 0.7f;
static const CGFloat kISControllerOpeningAnimationSpringInitialVelocity = 0.1f;
static const CGFloat kISControllerClosingAnimationSpringDamping = 1.0f;
static const CGFloat kISControllerClosingAnimationSpringInitialVelocity = 0.5f;

typedef NS_ENUM(NSUInteger, ISControllerState)
{
    ISControllerStateClosed = 0,
    ISControllerStateOpening,
    ISControllerStateOpen,
    ISControllerStateClosing
};

@interface PSCustomViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,PSSearchBarDelegate>
{
    PSPullDownMenu * _pullDownMenu;
    PSCustomMenu * _menu;
    
    PSSearchBar * _searchBar;
    
    PSPyqView * _pyqView;

    UITableView * _displayTableView;
    
    NSMutableArray * _allDataSource;
    
    PSSearchTypeMenu * _typeMenu;
    
    BOOL _isSearchState;
        
    BOOL _isPyq;
}
@property(nonatomic, assign) ISControllerState vcState;
@property(nonatomic, assign) CGPoint panGestureStartLocation;
@end

@implementation PSCustomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self  setupMenu];
 
    [self  setupTableView];
    
    [self  setupPullDownMenu];
    
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
    
    _displayTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
}

- (void)setupPullDownMenu
{
    weakSelf(ws);
    
    NSArray *typeArr = @[@{@"title":@"按时间排序",@"icon":@"nd_order_time_big"},
                         @{@"title":@"按文件名排序",@"icon":@"nd_order_cha_big"},
                         @{@"title":@"全部",@"icon":@"nd_sort_all"},
                         @{@"title":@"文档",@"icon":@"nd_sort_doc"},
                         @{@"title":@"图片",@"icon":@"nd_sort_pic"},
                         @{@"title":@"其他",@"icon":@"nd_sort_other"}];
    
    _pullDownMenu = [PSPullDownMenu pullDownMenuWithSource:typeArr];
    
    _pullDownMenu.pullDownMenuActionBlock = ^(NSInteger selectIndex)
    {
        
    };
    
}

- (void)keyHide:(UITapGestureRecognizer*)aTap
{
    [_searchBar ps_ResignFirstResponder];
}

- (void)loadAllDataSource
{
    _allDataSource = NewMutableArray();
    
    
    [_allDataSource addObject:@"朋友圈"];

    [_allDataSource addObject:@"文章"];

    [_allDataSource addObject:@"公众号"];

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
        if (_pullDownMenu.isShow)
        {
            [_pullDownMenu hideMenuAnimation:YES];
        }
        else
        {
            [_pullDownMenu showInView:self.view underView:_menu];
        }
        
    }
}

- (void)showSearchMode:(BOOL)isSearch
{
    if (_isSearchState == isSearch) return;
    
    _isSearchState = isSearch;
    weakSelf(ws);

    if (_isSearchState)
    {
        if (!_searchBar) {
            
            _searchBar = [PSSearchBar searchBar];
            _searchBar.delegate = self;
        }
        
        if (!_typeMenu)
        {
            _typeMenu = [PSSearchTypeMenu SearchTypeMenuWithY:64];
            
            _typeMenu.SearchTypeBlock = ^(NSInteger type)
            {
                [ws clickSearchType:type];
            };
            
            _typeMenu.delegate = self;
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyHide:)];
            
            [_typeMenu addGestureRecognizer:tap];

        }
        
        //理解为编辑状态
        _searchBar.style = PSSearchBarStyleDefault;
        
        //开始进入编辑
        [_searchBar ps_SearchBarWillBeginEditing];
        
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, HalfF(128));
        _searchBar.transform = CGAffineTransformMakeScale(0, 0.4);
        
        _typeMenu.frame = CGRectMake(0, 64, SCREEN_WIDTH, VALID_VIEW_HEIGHT);
        
        _typeMenu.contentSize = CGSizeMake(SCREEN_WIDTH, VALID_VIEW_HEIGHT + 10);
        
        [self.view addSubview:_searchBar];
        [self.view addSubview:_typeMenu];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
        self.tabBarController.tabBar.hidden = YES;

        [UIView animateWithDuration:0.3f animations:^{
          
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            _searchBar.transform = CGAffineTransformMakeScale(1, 1);
            
            _displayTableView.hidden = YES;
            _typeMenu.hidden = NO;
            [self.view bringSubviewToFront:_typeMenu];
            
        } completion:^(BOOL finished) {
            
            self.tabBarController.tabBar.hidden = YES;

            [_searchBar ps_BecomeFirstResponder];
        }];
        
        return;
    }
    [_searchBar ps_CleanSearchText];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.tabBarController.tabBar.hidden = NO;

    [UIView animateWithDuration:0.3f animations:^{
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        _searchBar.height = _menu.height;
        _searchBar.transform = CGAffineTransformMakeScale(0.01, 1);
        
        _displayTableView.hidden = NO;
        _typeMenu.hidden = NO;
        [self.view sendSubviewToBack:_typeMenu];
        
    } completion:^(BOOL finished) {
        
        [_searchBar resignFirstResponder];
        _searchBar.transform = CGAffineTransformMakeScale(1, 1);

        [_searchBar removeFromSuperview];
        
        [_typeMenu removeFromSuperview];
    }];
    
}

- (void)clickSearchType:(NSInteger)type
{
    [self showPyqView:YES];
}

#pragma mark - PSSearchDelegate -
- (void)ps_SearchBarCancelButtonClicked:(PSSearchBar *)searchBar
{
    LogFunctionName();
    [self showPyqView:NO];
    [self showSearchMode:NO];
}

- (void)ps_SearchBarBackButtonClicked:(PSSearchBar *)searchBar
{
    LogFunctionName();
    
    [self showPyqView:NO];
}

- (void)ps_SearchBarSearchButtonClicked:(PSSearchBar *)searchBar
{
    
    LogFunctionName();
    
}

- (void)ps_SearchBar:(PSSearchBar *)searchBar textDidChange:(NSString *)searchText
{
    LogFunctionName();

}

- (void)ps_SearchBarTextDidBeginEditing:(PSSearchBar *)searchBar
{
    
    LogFunctionName();

}

- (void)ps_SearchBarTextDidEndEditing:(PSSearchBar *)searchBar
{
    LogFunctionName();

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
    
    cell.textLabel.text = _allDataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self keyHide:nil];
}

#pragma mark - 手势-
- (void)showPyqView:(BOOL)isPyq
{
    if (_isPyq == isPyq)  return;
    
    _isPyq = isPyq;
    
    if (_isPyq)
    {
        if (!_pyqView)
        {
            _pyqView = [PSPyqView ps_PyqViewWithY:HalfF(128)];
            _pyqView.delegate = self;
        }

        _pyqView.frame = CGRectMake(SCREEN_WIDTH, HalfF(128), SCREEN_WIDTH, VALID_VIEW_HEIGHT);
        _pyqView.contentSize = CGSizeMake(SCREEN_WIDTH, VALID_VIEW_HEIGHT + 10);

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyHide:)];

        [_pyqView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer  * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
        pan.delegate = self;
        
        [_pyqView addGestureRecognizer:pan];
        
        [self.view addSubview:_pyqView];
        
        _searchBar.style = PSSearchBarStyleCanBack;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _pyqView.x = 0;
        }];

        return;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        
        _pyqView.x = SCREEN_WIDTH;
        
        [_searchBar ps_SearchBarStrle:PSSearchBarStyleCanBack AmiantionWithVelocity:_pyqView.x];
        
    } completion:^(BOOL finished) {
        
        [_pyqView removeFromSuperview];
        self.vcState = ISControllerStateClosed;
    }];

    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self.view];
    
    CGPoint location = [(UIPanGestureRecognizer *)gestureRecognizer locationInView:_pyqView];

    if (location.x <= HalfF(100))
    {
        if (self.vcState == ISControllerStateClosed && velocity.x > 0.0f) {
            return YES;
        }
        else if (self.vcState == ISControllerStateOpen && velocity.x < 0.0f) {
            return YES;
        }
    }
    return NO;
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)panGestureRecognizer

{
    NSParameterAssert(_pyqView);
    
    
    UIGestureRecognizerState  state = panGestureRecognizer.state;
    
    CGPoint location = [panGestureRecognizer translationInView:_pyqView];
    
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    switch (state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.panGestureStartLocation = location;
            
            if (self.vcState == ISControllerStateClosed)
            {
                [self willOpen];
            }
            else {
                [self willClose];
            }
        }
        break;
        
        case UIGestureRecognizerStateChanged:
        {
            
            CGFloat  delta = 0.0f;
            
            if (self.vcState == ISControllerStateOpening)
            {
                delta = location.x - self.panGestureStartLocation.x;
                
            }
            else if (self.vcState == ISControllerStateClosing)
            {
                delta = SCREEN_WIDTH - (self.panGestureStartLocation.x - location.x);
            }
         
            
            CGFloat _pyqX = _pyqView.x;
            
            if (delta > SCREEN_WIDTH)
            {
                _pyqX = SCREEN_WIDTH;
            }
            else if (delta < 0.0f)
            {
                _pyqX = 0.0f;
            }
            else {
                
                _pyqX = delta;
            }
            
            _pyqView.x = _pyqX;
            
            [_searchBar ps_SearchBarStrle:PSSearchBarStyleCanBack AmiantionWithVelocity:_pyqView.x];
            
//            NSLog(@"-- py %f----",_pyqView.x);
            
        }
        break;
            
        case UIGestureRecognizerStateEnded:
        {
            if (self.vcState == ISControllerStateOpening)
            {
                CGFloat _pyqX = _pyqView.x;
                
                if (_pyqX == SCREEN_WIDTH)
                {
                    [self didOpen];
                }
                else if (_pyqX > SCREEN_WIDTH / 3
                         && velocity.x > 0.0f)
                {
                    [self animateOpening];
                }
                else
                {
                    [self didOpen];
                    [self willClose];
                    [self animateClosing];
                }
                
            } else if (self.vcState == ISControllerStateClosing)
            {
                CGFloat _pyqX = _pyqView.x;
                if (_pyqX == 0.0f)
                {
                    [self didClose];
                }
                else if (_pyqX < (2 * SCREEN_WIDTH) / 3
                         && velocity.x < 0.0f)
                {
                    [self animateClosing];
                }
                else
                {
                    [self didClose];
            
                    [self willOpen];
                    
                    [self animateOpening];
                }

            }
            
        }
        break;
        default:
            break;
    }
    
}



- (void)willOpen
{
    LogFunctionName();
    
    self.vcState = ISControllerStateOpening;
    
}

- (void)didOpen
{
    LogFunctionName();

    [_searchBar ps_SearchBarStrle:PSSearchBarStyleCanBack AmiantionWithVelocity:SCREEN_WIDTH];
    self.vcState = ISControllerStateOpen;
}

- (void)willClose
{
    LogFunctionName();

    self.vcState = ISControllerStateClosing;
    
}
- (void)didClose
{
    LogFunctionName();

    [_searchBar ps_SearchBarStrle:PSSearchBarStyleCanBack AmiantionWithVelocity:0];

    self.vcState = ISControllerStateClosed;
    
}

- (void)animateOpening
{
    
    [self showPyqView:NO];
    
    [self didOpen];
    
//       [UIView animateWithDuration:kICSDrawerControllerAnimationDuration
//                          delay:0
//         usingSpringWithDamping:kISControllerOpeningAnimationSpringDamping
//          initialSpringVelocity:kISControllerOpeningAnimationSpringInitialVelocity
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
//                         _pyqView.x = SCREEN_WIDTH;
//                         
//                     }
//                     completion:^(BOOL finished) {
//                         [self didOpen];
//                     }];
}

- (void)animateClosing
{
    
    [UIView animateWithDuration:kISControllerAnimationDuration
                          delay:0
         usingSpringWithDamping:kISControllerClosingAnimationSpringDamping
          initialSpringVelocity:kISControllerClosingAnimationSpringInitialVelocity
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _pyqView.x =  0;
                         
                         [_searchBar ps_SearchBarStrle:PSSearchBarStyleCanBack AmiantionWithVelocity:_pyqView.x];
                     }
                     completion:^(BOOL finished) {
                         [self didClose];
                         
                     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
