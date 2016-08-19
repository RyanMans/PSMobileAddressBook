//
//  PSMobileBookViewController.m
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSMobileBookViewController.h"
#import "PSMobileBookUtil.h"
#import "PSMobileContactModel.h"

#import "PSLetterDisplayView.h"
#import "PSHeaderInSectionView.h"
#import "PSContactNullView.h"

#import "PSMobileContactCell.h"

@interface PSMobileBookViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    
    BOOL _isfirstRun;
    
    NSInteger _runNumber;
    
    NSMutableArray	* _allMobileContacts;
    NSMutableArray  * _capSectionLists;
    
    // 索引
    PSLetterDisplayView * _letterView;
    
    PSContactNullView * _nullView;
    
    
    //正常的
    UITableView * _normalTabelView;
    __block NSMutableArray * _allDataSource;
    
    // 搜索
    UISearchDisplayController * _searchDisplayVC; //3.0 -8.0 ,之后被UISearchController 替代， 仍可用。 但是UISearchController暂时找不到如何设置nullview,但优化了很多，动画也很自然
    UITableView  * _searchResultsTableView;
    __block NSMutableArray * _searchDataSource;
    
    //显示的
    UITableView * _displayTableView;
    __block NSArray * _displayDataSource;
    
    
    //验证cell 多按钮的，置顶、删除等
    UITableViewRowAction *deleteRowAction;
    UITableViewRowAction *moreRowAction;
    UITableViewRowAction *sanRowAction;
    UITableViewRowAction *OK;
    
    BOOL _isSearchStatus; //是搜索状态
    
}
@property (nonatomic,weak)UISearchBar * searchBar;
@end

@implementation PSMobileBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"手机通讯录";
    
    [self  setupTableView];
    [self  setupSearchBar];
    [self  addSearchDisplayVC];
    [self  addLetterDisplayView];
    
    [self  addNullView];
    
    _searchDataSource = NewMutableArray();
    _isSearchStatus = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isfirstRun == NO)
    {
        _isfirstRun = YES;
        [self loadAllMobileContacts];
    }
}

- (void)setupTableView
{
    _normalTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,VALID_VIEW_HEIGHT - TabBarHeight)];
    _normalTabelView.delegate = self;
    _normalTabelView.dataSource = self;
    _normalTabelView.showsVerticalScrollIndicator = NO;
    _normalTabelView.sectionIndexBackgroundColor = [UIColor clearColor];
    _normalTabelView.sectionIndexColor = RGB(102, 102, 102);
    [self.view addSubview:_normalTabelView];
    
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineV.backgroundColor = RGB(248, 248, 248);
    _normalTabelView.tableFooterView = lineV;

}

//设置搜索
- (void)setupSearchBar
{
    // 搜索栏
    UISearchBar * searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    searchBar.backgroundColor =RGB(249, 249, 249);
    searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor] size:searchBar.size];
    self.searchBar = searchBar;
    _normalTabelView.tableHeaderView = searchBar;
}

- (void)addSearchDisplayVC
{
    _searchDisplayVC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    _searchDisplayVC.delegate = self;
    _searchDisplayVC.searchResultsDataSource = self;
    _searchDisplayVC.searchResultsDelegate = self;
    _searchDisplayVC.searchResultsTableView.showsVerticalScrollIndicator = NO;
    _searchDisplayVC.searchResultsTableView.showsHorizontalScrollIndicator = NO;
    _searchDisplayVC.searchResultsTableView.tableFooterView = _normalTabelView.tableFooterView;
    
}

//添加字母索引器
- (void)addLetterDisplayView
{
    _letterView = [PSLetterDisplayView letterDisplayWithCenter:CGPointMake(HalfF(SCREEN_WIDTH), HalfF(VALID_VIEW_HEIGHT))];
    [_letterView setLayerWithCr:10];
    [self.view addSubview:_letterView];
}

//添加空图
- (void)addNullView
{
    _nullView = [[PSContactNullView alloc] initWithSize:CGSizeMake(self.view.width, self.view.height) OriginY:INVALID_VIEW_HEIGHT];
    
    [self.view addSubview:_nullView];
}

//显示
- (void)displayNormal
{
    _displayTableView.delegate = nil;
    _displayTableView.dataSource = nil;
    _displayTableView = _normalTabelView;
    
    _displayTableView.delegate = self;
    _displayTableView.dataSource = self;
    _displayDataSource = [_allDataSource mutableCopy];
    [_displayTableView reloadData];
}

//显示
- (void)displaySearch
{
    _displayTableView.delegate = nil;
    _displayTableView.dataSource = nil;
    _displayTableView = _searchResultsTableView;
    _displayTableView.delegate = self;
    _displayTableView.dataSource = self;
    _displayDataSource = [_searchDataSource mutableCopy];
    [_displayTableView reloadData];
}

#pragma mark - 数据源 -

// 默认是先加载本地数据
- (void)loadAllMobileContacts
{
    if ([NSThread isMainThread] == YES)
    {
        runBlockWithAsync(^{
            
            [self loadAllMobileContacts];
        });
        return;
    }
    
    //大数据在加载时，先控制不可操作
    runBlockWithMain(^{_searchBar.userInteractionEnabled = NO;});
    
    NSMutableArray * _tempMobileContacts = [PSMobileBookUtil getAllMobileContacts];
    
    if (_tempMobileContacts.count == 0 || !_tempMobileContacts) return;
    
    //同名 多个手机号码
    
    NSMutableArray * _newTemp = NewMutableArray();
    
    NSInteger count = _tempMobileContacts.count;
    
    for (NSUInteger i = 0; i < count; i++)
    {
        PSMobileContactModel * mobileMobel = _tempMobileContacts[i];
        mobileMobel.mobile = mobileMobel.mobileArr[0];
        mobileMobel.mobile = [mobileMobel.mobile onlyNumbers];
        
        [_newTemp addObject:mobileMobel];
        
        if (mobileMobel.mobileArr.count <=1)continue;
        
        for (NSUInteger j = 1; j < mobileMobel.mobileArr.count; j ++)
        {
            PSMobileContactModel * m = [PSMobileContactModel modelWithDictionary:[mobileMobel dictionary]];
            m.mobile = mobileMobel.mobileArr[j];
            m.mobile = [m.mobile onlyNumbers];
            
            [_newTemp addObject:m];
        }
    }
    
    _allMobileContacts = NewMutableArray();
    
    for (PSMobileContactModel * model in _newTemp)
    {
        if (model.mobile.length) {
            [_allMobileContacts addObject:model];
        }
    }
    
    [self sortWithDataSource:_allMobileContacts];
    
    //数据处理完 操作打开
    runBlockWithMain(^{_searchBar.userInteractionEnabled = YES;});
}

//给数据分组排序

- (void)sortWithDataSource:(NSArray*)temp
{
    if (temp.count == 0)
    {
        _isSearchStatus == NO ? [self refreshDataSourceToUi:nil iNames:nil]:[self refreshSearchDsToUi:nil iNames:nil];
        return;
    }
    
    if ([NSThread isMainThread])
    {
        runBlockWithAsync(^{
            [self sortWithDataSource:temp];
        });
        return;
    }
    NSMutableDictionary *dSource = NewMutableDictionary();
    for (PSMobileContactModel *model in temp)
    {
        NSString *key = model.firstPY;
        if (0 == key.length) key = @"";
        NSMutableArray *buffer = dSource[key];
        if (nil == buffer)
        {
            buffer = NewMutableArray();
            dSource[key] = buffer;
        }
        [buffer addObject:model];
    }
    
    for (NSString *key in dSource.allKeys)
    {
        NSArray *temp = dSource[key];
        temp = [temp sortedArrayUsingComparator:^NSComparisonResult(PSMobileContactModel *obj1, PSMobileContactModel * obj2) {
            return [obj1.name compare:obj2.name];
        }];
        dSource[key] = temp;
    }
    
    NSArray *iNames = [dSource.allKeys sortedArrayUsingSelector:@selector(compare:)];
    {
        NSString *obj = iNames.firstObject;
        if ([obj isEqualToString:@"#"])
        {
            NSMutableArray *temp = [iNames mutableCopy];
            [temp removeObject:obj];
            [temp addObject:obj];
            iNames = temp;
        }
    }
    
    _isSearchStatus == NO ? [self refreshDataSourceToUi:dSource iNames:iNames]:[self refreshSearchDsToUi:dSource iNames:iNames];
    
}

//正常模式下
- (void)refreshDataSourceToUi:(NSDictionary*)dict iNames:(NSArray*)iNames
{
    if (NO == [NSThread isMainThread])
    {
        runBlockWithMain(^{[self refreshDataSourceToUi:dict iNames:iNames];});
        return;
    }
    
    _allDataSource = [@[] mutableCopy];
    if (dict == nil && iNames == nil)
    {
        runBlockWithMain(^{
            [self displayNormal];
        });
        return;
    }
    for (NSString  * key in iNames)
    {
        NSArray *temp = dict[key];
        temp= [temp sortedArrayUsingComparator:^NSComparisonResult(PSMobileContactModel *obj1, PSMobileContactModel * obj2) {
            return [obj1.name compare:obj2.name];
        }];
        [_allDataSource addObject:temp];
    }
    _capSectionLists = [iNames mutableCopy];
    if (_capSectionLists.count)[_capSectionLists insertObject:UITableViewIndexSearch atIndex:0];

    [self displayNormal];
}

//搜索模式下
- (void)refreshSearchDsToUi:(NSDictionary*)dict iNames:(NSArray*)iNames
{
    LogFunctionName();
    
    if (NO == [NSThread isMainThread])
    {
        runBlockWithMain(^{[self refreshSearchDsToUi:dict iNames:iNames];});
        return;
    }
    
    _searchDataSource = [@[] mutableCopy];
    
    if (dict == nil && iNames == nil)
    {
        [self displaySearch];
        return;
    }
    
    for (NSString  * key in iNames)
    {
        NSArray *temp = dict[key];
        temp= [temp sortedArrayUsingComparator:^NSComparisonResult(PSMobileContactModel *obj1, PSMobileContactModel * obj2) {
            return [obj1.name compare:obj2.name];
        }];
        [_searchDataSource addObject:temp];
    }
    if (_searchDataSource.count)[_nullView disAppear];
    else [_nullView show];
    
    [self displaySearch];
}


#pragma mark -代理-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _displayDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * arr = _displayDataSource[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PSMobileContactCell cellHeight];
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PSHeaderInSectionView * sectionView = [PSHeaderInSectionView viewForHeaderInSectionH:HalfF(40)];
    NSArray * arr = _displayDataSource[section];
    sectionView.flag = 2 + 8;
    if (arr && arr.count != 0)
    {
        PSMobileContactModel * model = [arr firstObject];
        sectionView.text = model.firstPY;
    }
    return sectionView;
}
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _searchResultsTableView)return @[];
    return _capSectionLists;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (IsSameString(title, UITableViewIndexSearch))return index;
    [_letterView animationsLetterDisplay:title];
    return index;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * arr = _displayDataSource[indexPath.section];
    
    PSMobileContactModel * model = arr [indexPath.row];
    PSMobileContactCell * mCell = [PSMobileContactCell cellWithTableView:tableView];
    mCell.name = model.name;
    mCell.mobile = model.mobile;
    mCell.lineView.hidden = indexPath.row == arr.count - 1;
    return mCell;
}

#pragma mark - edit -
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0){
        // 添加一个删除按钮
        deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了删除");
            
        }];
        
        
    }
    else if (indexPath.row==1){
        // 添加一个删除按钮
        deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了删除");
            
        }];
        
        // 添加一个修改按钮
        moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了修改");
        }];
        moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        
    }
    else if (indexPath.row==2){
        // 添加一个删除按钮
        deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了删除");
            
        }];
        
        // 添加一个修改按钮
        moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了修改");
        }];
        moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        // 添加一个发送按钮
        
        sanRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"发送" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了发送");
        }];
        sanRowAction.backgroundColor=[UIColor orangeColor];
        
    }
    else{
        // 添加一个删除按钮
        deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了删除");
            
        }];
        
        // 添加一个修改按钮
        moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了修改");
        }];
        moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        // 添加一个发送按钮
        
        sanRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"发送" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了发送");
        }];
        sanRowAction.backgroundColor=[UIColor orangeColor];
        // 添加一个发送按钮
        
        OK = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"OK键" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSLog(@"点击了OK");
        }];
        OK.backgroundColor=[UIColor purpleColor];
        
        
    }
    
    // 将设置好的按钮放到数组中返回
    if (indexPath.row==0) {
        return @[deleteRowAction];
        
    }else if (indexPath.row==1){
        return @[deleteRowAction,moreRowAction];
        
    }else if(indexPath.row==2){
        return @[deleteRowAction,moreRowAction,sanRowAction];
        
    }else if(indexPath.row==3){
        return @[deleteRowAction,moreRowAction,sanRowAction,OK];
        
    }
    return nil;
}

#pragma mark - 键盘事件 -

-(void)keyboardWillShow:(NSNotification*)noti
{
    if (![self.searchBar isFirstResponder]) return;
    [self.view bringSubviewToFront:_nullView];
    if (_searchDataSource.count == 0 || !_searchDataSource)[_nullView show];
}

#pragma mark -UISearchBarDelegate-
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.navigationController.view.backgroundColor = searchBar.backgroundColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    self.navigationController.view.backgroundColor = nil;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    for (UIView * sub in _searchDisplayVC.searchResultsTableView.subviews)
    {
        if (IsKindOfClass(sub, UILabel)) sub.hidden = YES;
    }
    return YES;
}
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    if (_searchResultsTableView == nil)_searchResultsTableView = controller.searchResultsTableView;
    UISearchBar *searchBar = controller.searchBar;
    searchBar.showsCancelButton = YES;
    UIButton *btn = [searchBar findSubviewWithClass:[UIButton class] maxCount:1][0];
    if (btn) [btn setTitle:@"取消" forState:UIControlStateNormal];
    if (btn) [btn setTitleColor:RGB(64, 177, 255) forState:(UIControlStateNormal)];
    [self displaySearch];
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.searchBar.showsCancelButton = NO;
    _isSearchStatus = NO;
    [_searchDataSource  removeAllObjects];
    
    [_nullView disAppear];
    [self displayNormal];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    LogFunctionName();
    searchBar.showsCancelButton = YES;
    [searchBar resignFirstResponder];
    [self searchLocalMobileContactListsWithKey:searchBar.text];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    LogFunctionName();
    _isSearchStatus = NO;
    [searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) [_nullView show];
}

- (void)searchLocalMobileContactListsWithKey:(NSString*)key
{
    if (key.length ==0 || !key) return;
    
    _isSearchStatus = YES;

    if ([NSThread isMainThread] == YES)
    {
        runBlockWithAsync(^{
            
            [self searchLocalMobileContactListsWithKey:key];
        });
        
        return;
    }
    
    NSMutableArray * temp = NewMutableArray();
    
    for (PSMobileContactModel * model in _allMobileContacts )
    {
        NSString * lowerString = key.lowercaseString;
        if (StringHasSubstring(model.name.lowercaseString, lowerString)
            || StringHasSubstring(model.fullPY, lowerString)
            || StringHasSubstring(model.mobile, lowerString))
        {
            
            [temp addObject:model];
        }
    }

    [self sortWithDataSource:temp];
}





@end
