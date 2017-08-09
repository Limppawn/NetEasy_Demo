//
//  NetEasyControllView.h
//  NetE_Menu
//
//  Created by qian88 on 16/11/9.
//  Copyright © 2016年 qian88. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetItemConfig : NSObject

@property(nonatomic,assign)float itemWidth;
@property(nonatomic,strong)UIFont *itemFont;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,strong)UIColor *selectedColor;

@property(nonatomic,assign)float linePerecnt;
@property(nonatomic,assign)float lineHeight;


@end


//block回调
typedef void(^NetEasyControllerTapBlock)(NSInteger index,BOOL animation);

@interface NetEasyControllView : UIScrollView

@property(nonatomic,strong)NetItemConfig *config;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,assign)BOOL tapAnimation;
@property(nonatomic,readonly)NSInteger currentIndex;
@property(nonatomic,copy)NetEasyControllerTapBlock tapItemWithIndex;

-(void)moveToIndex:(float)index;

-(void)endMoveToIndex:(float)index;


@end
