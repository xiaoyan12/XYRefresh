//
//  ViewController.m
//  XYRefresh
//
//  Created by 闫世超 on 16/9/12.
//  Copyright © 2016年 闫世超. All rights reserved.
//

#import "ViewController.h"
#import "XYModel.h"
#import "XYTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)NSMutableArray *dataArr;

@property (nonatomic )      NSInteger pageIndex;

@property (nonatomic ,strong)MBProgressHUD *HUD;

@end

@implementation ViewController

-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setUpTheNetworkRequest:URLStr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self setUpTheNetworkmj_headerRequest:URLStr];
    
    [self LiftTheRefresh:URLStr];
    // Do any additional setup after loading the view, typically from a nib.
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.estimatedRowHeight = 120;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XYTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    XYModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark --设置网络请求
-(void)setUpTheNetworkmj_headerRequest:(NSString *)urlStr{
    
    __weak ViewController *weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *listDict = obj[@"data"];
                
                NSArray *arr = listDict[@"list"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    XYModel *model = [XYModel modelWithDictonary:dict];
                    [mArr addObject:model];
                }
                weakSelf.dataArr = mArr;
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                NSString *str = [NSString stringWithFormat:@"小的已为您更新了%ld条内容",mArr.count];
                [weakSelf setUpTheMBProgressHUD:str];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf.tableView.mj_header endRefreshing];
            NSLog(@"%@",error);
            [weakSelf setUpTheMBProgressHUD:@"网络错误，请您重试"];

        }];
 
    }];
    
}


-(void)setUpTheMBProgressHUD:(NSString *)str{
      self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
     self.HUD.label.text = str;
    
    [self.HUD hideAnimated:YES afterDelay:3];
    
}
#pragma mark --设置网络请求
-(void)setUpTheNetworkRequest:(NSString *)urlStr{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     __weak ViewController *weakSelf = self;
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *listDict = obj[@"data"];
            
            NSArray *arr = listDict[@"list"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dict in arr) {
                XYModel *model = [XYModel modelWithDictonary:dict];
                [mArr addObject:model];
            }
            weakSelf.dataArr = mArr;
            [weakSelf.tableView reloadData];
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [weakSelf setUpTheMBProgressHUD:@"网络错误，请您重试"];
    }];
}

#pragma mark --上提刷新
-(void)LiftTheRefresh:(NSString *)urlStr{
     __weak ViewController *weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _pageIndex += 2;
        NSDictionary *parmeters = @{@"page":@(_pageIndex)};
        [manager GET:urlStr parameters:parmeters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *listDict = obj[@"data"];
                
                NSArray *arr = listDict[@"list"];
            for (NSDictionary *dict in arr) {
                    XYModel *model = [XYModel modelWithDictonary:dict];
                    [weakSelf.dataArr addObject:model];
                }
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_footer endRefreshing];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf setUpTheMBProgressHUD:@"网络错误，请您重试"];
        }];

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
