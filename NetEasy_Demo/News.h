//
//  News.h
//  NetEasy_Demo
//
//  Created by 梁志成 on 2016/11/16.
//  Copyright © 2016年 梁志成. All rights reserved.
//

#import "JSONModel.h"
#import "Ads.h"

//@protocol Ads;

@interface News : JSONModel
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *recSource;
@property(nonatomic,copy)NSString *replyCount;

//@property(nonatomic,strong)NSArray <Ads> * ads;
@property(nonatomic,strong)Ads *ads;

@end
