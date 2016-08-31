//
//  XMLParserModel.h
//  如何写好一个UITableview
//
//  Created by iOS-aFei on 16/8/23.
//  Copyright © 2016年 iOS-aFei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParserModel : NSObject <NSXMLParserDelegate>

@property (nonatomic, copy) void (^ loadFinished)(NSMutableArray *array);

- (void)parserXMLWithData:(NSData *)data;
@end
