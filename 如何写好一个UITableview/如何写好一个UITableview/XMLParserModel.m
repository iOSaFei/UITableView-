//
//  XMLParserModel.m
//  如何写好一个UITableview
//
//  Created by iOS-aFei on 16/8/23.
//  Copyright © 2016年 iOS-aFei. All rights reserved.
//

#import "XMLParserModel.h"
#import "CellModel.h"

static NSString *kIDStr     = @"id";
static NSString *kNameStr   = @"im:name";
static NSString *kImageStr  = @"im:image";
static NSString *kArtistStr = @"im:artist";
static NSString *kEntryStr  = @"entry";

@interface XMLParserModel () <NSXMLParserDelegate>

@property (nonatomic, strong)    CellModel *cellmodel;
@property (nonatomic, strong)    NSArray *elementsToParse;
@property (nonatomic, strong)    NSMutableArray <CellModel *> *modelArray;
@property (nonatomic, strong)    NSMutableString *tempSting;
@property (nonatomic, readwrite) BOOL storingCharacterData;


@end

@implementation XMLParserModel 
- (instancetype)init {
    self = [super init];
    if (self) {
        _elementsToParse = @[kIDStr, kNameStr, kImageStr, kArtistStr];
    }
    return self;
}
- (void)parserXMLWithData:(NSData *)data {
//    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
}
//开始解析文件，在开始解析xml节点前做一些初始化工作
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    _modelArray = [NSMutableArray array];
    _tempSting  = [NSMutableString string];
}
//如果遇到xml的开始标记，表明已经遇到了一个xml节点，此时开始解析该节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:kEntryStr])
    {
        self.cellmodel = [[CellModel alloc] init];
    }
    self.storingCharacterData = [self.elementsToParse containsObject:elementName];

}
//当遇到结束标记时，完成解析该节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if (self.cellmodel)
    {
        if (self.storingCharacterData) {
            NSString *trimmedString =
            [self.tempSting stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self.tempSting setString:@""];  // clear the string for next time
            if ([elementName isEqualToString:kIDStr])
            {
                self.cellmodel.appURLString = trimmedString;
            }
            else if ([elementName isEqualToString:kNameStr])
            {
                self.cellmodel.appName = trimmedString;
            }
            else if ([elementName isEqualToString:kImageStr])
            {
                self.cellmodel.imageURLString = trimmedString;
            }
            else if ([elementName isEqualToString:kArtistStr])
            {
                self.cellmodel.artist = trimmedString;
            }
        } else if ([elementName isEqualToString:kEntryStr])
        {
            [self.modelArray addObject:self.cellmodel];
            self.cellmodel = nil;
        }

    }

}
//当xml的节点有值时，解析当前节点的所有字符
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.storingCharacterData)
    {
        [self.tempSting appendString:string];
    }
}
//解析出错 
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
}
//成功解析玩xml文件后
-(void)parserDidEndDocument:(NSXMLParser *)parser {
    self.loadFinished(_modelArray);
}
@end
