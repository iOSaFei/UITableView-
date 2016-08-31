//
//  IconDownloader.h
//  如何写好一个UITableview
//
//  Created by iOS-aFei on 16/8/31.
//  Copyright © 2016年 iOS-aFei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CellModel;

@interface IconDownloader : NSObject

@property (nonatomic, strong) CellModel *cellModel;
@property (nonatomic, copy)   void (^loadIconFinished)();

- (void)startDownload;
- (void)cancelDownload;
@end
