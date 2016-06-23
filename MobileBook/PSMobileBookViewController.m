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
#import "PSMobileContactCell.h"
@interface PSMobileBookViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSInteger _runNumber;
    
    NSMutableArray	* _allMobileContacts;
    NSMutableArray  * _capSectionLists;
    // 索引
    PSLetterDisplayView * _letterView;
    
    
    //显示的
    UITableView * _displayTableView;
    NSMutableArray * _displayDataSource;
    
    BOOL _isfirstRun;
}
@end

@implementation PSMobileBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"手机通讯录";
    
    [self  setupTableView];
    [self  addLetterDisplayView];
    
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
    _displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
    _displayTableView.delegate = self;
    _displayTableView.dataSource = self;
    _displayTableView.showsVerticalScrollIndicator = NO;
    _displayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _displayTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _displayTableView.sectionIndexColor = RGB(102, 102, 102);
    [self.view addSubview:_displayTableView];
    
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineV.backgroundColor = RGB(248, 248, 248);
    _displayTableView.tableFooterView = lineV;
    
}

- (void)addLetterDisplayView
{
    _letterView = [PSLetterDisplayView letterDisplayWithCenter:CGPointMake(HalfF(SCREEN_WIDTH), HalfF(VALID_VIEW_HEIGHT))];
    [_letterView setLayerWithCr:10];
    [self.view addSubview:_letterView];
}

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
        
#if DEBUG
        mobileMobel.mobile  =  mobileMobel.mobile ;
#else
        mobileMobel.mobile  = [mobileMobel.mobile isEffectiveMobileNumber];
#endif
        [_newTemp addObject:mobileMobel];
        
        if (mobileMobel.mobileArr.count <=1)continue;
        
        for (NSUInteger j = 1; j < mobileMobel.mobileArr.count; j ++)
        {
            PSMobileContactModel * m = [PSMobileContactModel modelWithDictionary:[mobileMobel dictionary]];
            m.mobile = mobileMobel.mobileArr[j];
            m.mobile = [m.mobile onlyNumbers];
#if DEBUG
            m.mobile  =  m.mobile ;
#else
            m.mobile  = [m.mobile isEffectiveMobileNumber];
#endif
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
    
}
- (void)sortWithDataSource:(NSArray*)temp
{
    if (temp.count == 0) {
        [self refreshDataSourceToUi:nil iNames:nil];
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
    [self refreshDataSourceToUi:dSource iNames:iNames];
    
}
- (void)refreshDataSourceToUi:(NSDictionary*)dict iNames:(NSArray*)iNames
{
    if (NO == [NSThread isMainThread])
    {
        runBlockWithMain(^{[self refreshDataSourceToUi:dict iNames:iNames];});
        return;
    }
    _displayDataSource = [@[] mutableCopy];
    if (dict == nil && iNames == nil)
    {
        [_displayTableView reloadData];
        return;
    }
    for (NSString  * key in iNames)
    {
        NSArray *temp = dict[key];
        temp= [temp sortedArrayUsingComparator:^NSComparisonResult(PSMobileContactModel *obj1, PSMobileContactModel * obj2) {
            return [obj1.name compare:obj2.name];
        }];
        [_displayDataSource addObject:temp];
    }
    _capSectionLists = [iNames mutableCopy];
    if (_capSectionLists.count)[_capSectionLists insertObject:UITableViewIndexSearch atIndex:0];
    [_displayTableView reloadData];
    
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
@end
