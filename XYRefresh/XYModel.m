//
//  XYModel.m
//  XYRefresh
//
//  Created by 闫世超 on 16/9/12.
//  Copyright © 2016年 闫世超. All rights reserved.
//

#import "XYModel.h"

@implementation XYModel

-(instancetype)initModelWithDictrion:(NSDictionary *)dict{
    if (self = [super init]) {
        _title = dict[@"title"];
        NSString *str = dict[@"pic"];
        if ([str containsString:@"!"]) {
            NSRange range = [str rangeOfString:@"!"];
            NSString *str1 = [str substringToIndex:range.location];
            _pic = str1;
        }
    }
    return self;
}

+(instancetype)modelWithDictonary:(NSDictionary *)dict{
    return [[self alloc]initModelWithDictrion:dict];
}

@end
