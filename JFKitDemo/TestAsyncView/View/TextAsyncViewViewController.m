//
//  TextAsyncViewViewController.m
//  JFKitDemo
//
//  Created by 严美 on 2019/10/14.
//  Copyright © 2019 JohnnyFeng. All rights reserved.
//

#import "TextAsyncViewViewController.h"
#import "APTransHashCellHeader.h"

@interface TextAsyncViewViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray<APTransHashHeaderLayouts*>* dataSource;
@end

@implementation TextAsyncViewViewController

- (void) refreshDatas {
    NSMutableArray* list = @[].mutableCopy;
    [list addObject:[[APTransHashHeaderLayouts alloc] initWithModel:@{
                                                                      @"actions" : @[
                                                                              @{
                                                                                  @"account" : @"token.fee",
                                                                                  @"authorization" :             @[
                                                                                          @{
                                                                                              @"actor" : @"fengdadada",
                                                                                              @"permission" : @"active"
                                                                                              }
                                                                                          ],
                                                                                  @"data" :             @{
                                                                                          @"accountfee":@"accountfee",
                                                                                          @"from":@"fengdadada",
                                                                                          @"memo@":@"",
                                                                                          @"quantity":@"2.0000 ANTT",
                                                                                          @"quantityfee@":@"0.0200 ANTT",
                                                                                          @"to":@"sss",
                                                                                          },
                                                                                  @"hex_data":@"0080492699c4a65a00000000000030c60080522b4f4d1132204e00000000000004414e5454000000c80000000000000004414e545400000000",
                                                                                  @"name":@"transferfee"
                                                                                  }
                                                                              ],
                                                                      @"block_id":@"01433727f6c6a881ce9459a6c717ac0f821f6c1fcdddceb3a6afad87dffdf98c",
                                                                      @"block_num":@"21182247",
                                                                      @"createdAt":@"1570672109549",
                                                                      @"delay_sec" :@"0",
                                                                      @"expiration": @"2019-10-10 09:48:59",
                                                                      @"implicit": @"0",
                                                                      @"irreversible":@"1",
                                                                      @"max_cpu_usage_ms":@"0",
                                                                      @"max_net_usage_words":@"0",
                                                                      @"quantityfee":@"0.02",
                                                                      @"ref_block_num":@"14118",
                                                                      @"ref_block_prefix":@"2542529338",
                                                                      @"signatures":    @[
                                                                              @"SIG_K1_K8aJLFFYSu6kFPGc4AThqZSBu6xvqtpWiTCwmSvf4avS7tNKLb137zcMRBnUmAdiYgZpSa8M5kKgHSvSToMsdwxhGiTjk4"
                                                                              ],
                                                                      @"signing_keys" :     @{
                                                                              @"0": @"EOS6CxFS48BkuwuS5X9YNwvGMd66yZCbzsSUUFtNvChLGBgbqVUY3"
                                                                              },
                                                                      @"tradeCode":@"10014",
                                                                      @"trx_id" : @"6440bbebbca509b83da83532d95d416d8cb61e3e87074df3431bbac31d327269",
                                                                      @"updatedAt" : @"1570672202000"
                                                                      }]
    ];
    self.dataSource = list;
    [self.tableView reloadData];
}

# pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    APTransHashHeaderLayouts* layout = self.dataSource[indexPath.row];
    return layout.viewFrame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    APTransHashCellHeader* cell = [tableView dequeueReusableCellWithIdentifier:@"APTransHashCellHeader"];
    cell.layouts = self.dataSource[indexPath.row];
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self refreshDatas];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[APTransHashCellHeader class] forCellReuseIdentifier:@"APTransHashCellHeader"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundView.backgroundColor = JFRGBAColor(0xf5f5f5, 1);
        _tableView.backgroundColor = JFRGBAColor(0xf5f5f5, 1);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
