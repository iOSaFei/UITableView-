//
//  ViewController.m
//  如何写好一个UITableview
//
//  Created by iOS-aFei on 16/6/6.
//  Copyright © 2016年 iOS-aFei. All rights reserved.
//

#import "ViewController.h"
#import "XMLParserModel.h"
#import "IconDownloader.h"
#import "CellModel.h"

static NSString *const TopPaidAppsFeed =
@"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/xml";

static NSString *CellIdentifier = @"LazyTableCell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) XMLParserModel   *myXMLparserModel;
@property (nonatomic, strong) NSMutableArray   *cellModelArray;
@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self requestData];
}
- (void)dealloc {
    [self terminateAllDownloads];
}
- (void)terminateAllDownloads
{
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
}

- (void)requestData {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:TopPaidAppsFeed]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request
                                                       completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSLog(@"1");
            [self.XMLparserModel parserXMLWithData:data];
        } else {
            NSLog(@"0");
            
        }
        
    }];
    [sessionDataTask resume];
}
- (XMLParserModel *)XMLparserModel {
    if (!_myXMLparserModel) {
        _myXMLparserModel = [[XMLParserModel alloc] init];
        __weak ViewController *weakSelf = self;
        _myXMLparserModel.loadFinished = ^(NSMutableArray *modelArray){
            _cellModelArray = modelArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf tableView];
            });
        };
    }
    return _myXMLparserModel;
}
//- (void)handelTableView {
//}
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
        _tableView = [[UITableView alloc] initWithFrame:tableViewFrame
                                                  style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellModelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =\
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=\
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                               reuseIdentifier:CellIdentifier];
    }
    
    CellModel *cellModel      = self.cellModelArray[indexPath.row];
    cell.textLabel.text       = cellModel.appName;
    cell.detailTextLabel.text = cellModel.artist;
    if (!cellModel.appIcon) {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            [self startIconDownload:cellModel forIndexPath:indexPath];
        }
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
    } else {
        cell.imageView.image = cellModel.appIcon;
    }
    return cell;
}
- (void)startIconDownload:(CellModel *)cellModel forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.cellModel = cellModel;
        [iconDownloader setLoadIconFinished:^{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = cellModel.appIcon;
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}


- (void)loadImagesForOnscreenRows
{
    if (self.cellModelArray.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            CellModel *cellModel = (self.cellModelArray)[indexPath.row];
            
            if (!cellModel.appIcon)
            {
                [self startIconDownload:cellModel forIndexPath:indexPath];
            }
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self terminateAllDownloads];
}

@end
