//
//  ViewController.m
//  XKMobileAddressBook
//
//  Created by Allen、 LAS on 2018/5/8.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import "ViewController.h"
#import "XKMobileAddressBook/XKMobileAddressBook.h"
#import "masonry.h"
#import "XKMobileContactTableViewCell.h"
#import "XKMobileContactModel.h"
#import "NSString+XK.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray * allDataSource;
@property (nonatomic,strong)NSMutableArray * letterDataSource;
@property (nonatomic,strong)UITableView * displayTableView;
@property (nonatomic,strong)XKMobileLetterSectionIndexView * letterIndexView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"通讯录";
    
    [self.view addSubview:self.displayTableView];
    [self.view addSubview:self.letterIndexView];

    __weak typeof(self) ws = self;
    
     [self.displayTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    
    [self.letterIndexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.center.equalTo(ws.view);
    }];
    
    [self loadAllDataSource];
}

//数据源处理
- (void)loadAllDataSource{
    
    __weak typeof(self) ws = self;
    
    if (NSThread.isMainThread == YES) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
           
            [ws loadAllDataSource];
        });
        return;
    }
    
    //获取本地通讯录列表
    NSArray * mobileBookArrs = [XKMobileAddressBook xk_MobileAddressBook];
    
    NSMutableArray * tempMobileArr = [NSMutableArray array];
    
    //同名多号码
    [mobileBookArrs enumerateObjectsUsingBlock:^(XKMobileContactModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        XKMobileContactModel * tempModel = obj;
        tempModel.mobile = tempModel.mobileNumberArrs[0];
        tempModel.mobile = [tempModel.mobile onlyNumbers];
        
        if (tempModel.mobile.length) [tempMobileArr addObject:tempModel];
        
        if (tempModel.mobileNumberArrs.count >1) {
            
            for (NSUInteger index = 1; index < tempModel.mobileNumberArrs.count; index ++)
            {
                XKMobileContactModel * m = [XKMobileContactModel modelWithDictionary:[tempModel dictionary]];
                m.mobile = tempModel.mobileNumberArrs[index];
                m.mobile = [m.mobile onlyNumbers];
                
                if (m.mobile.length) [tempMobileArr addObject:m];
            }
        }
    }];
    
    //分组排序
    NSMutableDictionary * sectionDataSource = [NSMutableDictionary dictionary];

    //按首字母-分组
    [tempMobileArr enumerateObjectsUsingBlock:^(XKMobileContactModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString * key = obj.nameFirstLetter;
        
        if (key.length == 0) key = @"";
        
        NSMutableArray * buffer = sectionDataSource[key];

        if (!buffer) {
            buffer = [NSMutableArray array];
            sectionDataSource[key] = buffer;
        }
        
        [buffer addObject:obj];
    }];
    
    //排序
    [sectionDataSource.allKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray * buffer = sectionDataSource[key];

        buffer = [buffer sortedArrayUsingComparator:^NSComparisonResult(XKMobileContactModel *obj1, XKMobileContactModel * obj2) {
            
            return [obj1.name compare:obj2.name];
        }];
        
        sectionDataSource[key] = buffer;
    }];
    
    NSArray * keyNames = [sectionDataSource.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
    NSString * key = keyNames.firstObject;
    
    if ([key isEqualToString:@"#"])
    {
        NSMutableArray * temp = [keyNames mutableCopy];
        [temp removeObject:key];
        [temp addObject:key];
        keyNames = temp;
    }
    
    //数据
    _allDataSource = [NSMutableArray array];
    
    [keyNames enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray * buffer = sectionDataSource[key];
        
        buffer = [buffer sortedArrayUsingComparator:^NSComparisonResult(XKMobileContactModel *obj1, XKMobileContactModel * obj2) {
            
            return [obj1.name compare:obj2.name];
        }];
        
        [ws.allDataSource addObject:buffer];
    }];
    
    ws.letterDataSource = [keyNames mutableCopy];
    
    if (ws.letterDataSource.count)[ws.letterDataSource insertObject:UITableViewIndexSearch atIndex:0];

    //数据刷新
    dispatch_async(dispatch_get_main_queue(), ^{ [ws.displayTableView reloadData];});
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _allDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * temp = _allDataSource[section];
    return temp.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray * arr = _allDataSource [section];

    XKMobileContactModel  * statusModel = arr[0];

    return [XKMobileHeaderInSectionView xk_MobileHeaderInSectionView:statusModel.nameFirstLetter];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([title isEqualToString:UITableViewIndexSearch]) return index;
    
    [self.letterIndexView animationsLetterDisplay:title];
    
    return index;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _letterDataSource;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * arr = _allDataSource [indexPath.section];
    
    XKMobileContactTableViewCell * xkCell = [XKMobileContactTableViewCell xk_CellWithTableView:tableView];
    
    xkCell.statusModel = arr[indexPath.row];
    
    return xkCell;
}

- (XKMobileLetterSectionIndexView*)letterIndexView{
    if (!_letterIndexView) {
        _letterIndexView = [XKMobileLetterSectionIndexView new];
    }
    return _letterIndexView;
}

- (UITableView*)displayTableView{
    
    if (!_displayTableView) {
        _displayTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _displayTableView.delegate = self;
        _displayTableView.dataSource = self;
        _displayTableView.showsVerticalScrollIndicator = NO;
        _displayTableView.sectionIndexBackgroundColor = [UIColor clearColor];
//        _displayTableView.sectionIndexColor = RGB(102, 102, 102);
    }
    return _displayTableView;
}

- (void)dealloc{
    _displayTableView = nil;
}
@end
