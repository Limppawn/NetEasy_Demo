//
//  NewsCell.h
//  NetEasy_Demo
//
//  Created by qian88 on 16/11/15.
//  Copyright © 2016年 梁志成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsCell : UITableViewCell

//刷新
-(void)refreshUI:(News *)newsModel;
@end
