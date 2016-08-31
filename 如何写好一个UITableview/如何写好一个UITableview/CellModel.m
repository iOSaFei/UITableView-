//
//  CellModel.m
//  如何写好一个UITableview
//
//  Created by iOS-aFei on 16/8/23.
//  Copyright © 2016年 iOS-aFei. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", _appName];
}
@end
