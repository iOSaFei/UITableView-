//
//  CellModel.h
//  如何写好一个UITableview
//
//  Created by iOS-aFei on 16/8/23.
//  Copyright © 2016年 iOS-aFei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CellModel : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) UIImage  *appIcon;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) NSString *appURLString;

@end
