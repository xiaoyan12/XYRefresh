//
//  XYModel.h
//  XYRefresh
//
//  Created by 闫世超 on 16/9/12.
//  Copyright © 2016年 闫世超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYModel : NSObject

@property (nonatomic ,strong)NSString *title;

@property (nonatomic ,strong)NSString *pic;

-(instancetype)initModelWithDictrion:(NSDictionary *)dict;
+(instancetype)modelWithDictonary:(NSDictionary *)dict;
@end
