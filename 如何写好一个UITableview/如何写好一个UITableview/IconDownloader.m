//
//  IconDownloader.m
//  如何写好一个UITableview
//
//  Created by iOS-aFei on 16/8/31.
//  Copyright © 2016年 iOS-aFei. All rights reserved.
//

#import "IconDownloader.h"
#import "CellModel.h"

#define kAppIconSize 48

@interface IconDownloader ()

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@end

@implementation IconDownloader

- (void)startDownload
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.cellModel.imageURLString]];
    NSURLSession *session = [NSURLSession sharedSession];
    _sessionTask = [session dataTaskWithRequest:request
                              completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSLog(@"1");
            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                UIImage *image = [[UIImage alloc] initWithData:data];
                if (image.size.width != kAppIconSize || image.size.height != kAppIconSize) {
                    CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
                    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                    [image drawInRect:imageRect];
                    self.cellModel.appIcon = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                } else {
                    self.cellModel.appIcon = image;
                }
                if (self.loadIconFinished != nil)
                {
                    self.loadIconFinished();
                }
            }];
            
        } else {
            NSLog(@"0");
        }
    }];
    [self.sessionTask resume];
}
- (void)cancelDownload
{
    [self.sessionTask cancel];
    _sessionTask = nil;
}


@end
