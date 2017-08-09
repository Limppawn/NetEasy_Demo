//
//  NetEasyControllView.m
//  NetE_Menu
//
//  Created by qian88 on 16/11/9.
//  Copyright © 2016年 qian88. All rights reserved.
//

#import "NetEasyControllView.h"


@implementation NetItemConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _itemWidth =0;
        _itemFont =[UIFont boldSystemFontOfSize:16];
        _textColor =[UIColor grayColor];
        _selectedColor =[UIColor redColor];
        
        _linePerecnt =0.8;    //比例
        _lineHeight =2.50f;   //高度
        
    }
    return self;
}

@end


@interface NetEasyControllView ()

@property(nonatomic,strong)UIView *line;

@end


@implementation NetEasyControllView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.showsVerticalScrollIndicator =NO;
        self.showsHorizontalScrollIndicator =NO;
        self.scrollsToTop =NO;
        self.tapAnimation =YES;
    }
    return self;
}

-(void)setTitleArray:(NSArray *)titleArray{
    
    _titleArray =titleArray;
    
    if (!_config) {
        NSLog(@"配置config");
        return;
    }
    
    float x =0;
    float y =0;
    float width =self.config.itemWidth;
    float height =self.frame.size.height;
    
    //创建滚动按钮
    for (int i =0; i<titleArray.count; i++) {
        
        x =self.config.itemWidth * i;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, width, height)];
        btn.tag =100+i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.config.textColor forState:UIControlStateNormal];
        btn.titleLabel.font =self.config.itemFont;
        
        //点击事件
        [btn addTarget:self action:@selector(itemButttoClicked:) forControlEvents:UIControlEventTouchUpInside];
        //添加
        [self addSubview:btn];
        
        if (i==0) {
            
            [btn setTitleColor:self.config.selectedColor forState:UIControlStateNormal];
            _currentIndex = 0;;
            self.line =[[UIView alloc]initWithFrame:CGRectMake(width *(1-_config.linePerecnt)/2.0, CGRectGetHeight(self.frame)-_config.lineHeight, width * _config.linePerecnt, _config.lineHeight)];
            _line.backgroundColor =_config.selectedColor;
            [self addSubview:_line];
        }
    
    }
    
    
    self.contentSize =CGSizeMake(width*titleArray.count, height);
    
}


#pragma mark - 点击事件
-(void)itemButttoClicked:(UIButton *)btn{
    
    //接入外部效果
    _currentIndex =btn.tag -100;
    
    if (_tapAnimation) {
        
    }else{
        
        //没有动画手动移动
        [self changeLine:_currentIndex];
        [self changeItemColor:_currentIndex];
        
    }
    
    [self changeScrollOffset:_currentIndex];
    
    if (self.tapItemWithIndex) {
        
        _tapItemWithIndex(_currentIndex,_tapAnimation);
    }
    
 
 
}


#pragma mark -Methods
-(void)changeItemColor:(NSInteger)index{
    for (int i=0; i <_titleArray.count; i ++) {
        UIButton *btn =(UIButton *)[self viewWithTag:100+i];
        [btn setTitleColor:_config.textColor forState:UIControlStateNormal];
        if (btn.tag == index+100) {
            
            [btn setTitleColor:_config.selectedColor forState:UIControlStateNormal];
        }
        
    }
    
    
}

//change the line position
-(void)changeLine:(float)index{
    
    CGRect rect =_line.frame;
    rect.origin.x =index * _config.itemWidth +_config.itemWidth *(1-_config.linePerecnt)/2.0;
    _line.frame =rect;
}


//this point is difficult

-(NSInteger)changeProgressToInteger:(float)x{
    
    float max = _titleArray.count;
    float min =0;
    
    NSInteger index =0;
    if (x<0.5 +min) {
        
        index = max;
    }else if (x > max -0.5){
        
        index =max;
    }else{
        
        index =(x+0.5)/1;
    }
    
    return index;

}

//move the scrollerview
-(void)changeScrollOffset:(NSInteger)index{
    
    float halfWidth =CGRectGetWidth(self.frame)/2.0;
    float scrollWidth =self.contentSize.width;
    
    float leftSpace =_config.itemWidth *index -halfWidth +_config.itemWidth/2.0;
    
    if (leftSpace <0) {
        leftSpace =0;
    }
    if (leftSpace>scrollWidth -2*halfWidth) {
        leftSpace =scrollWidth - 2 * halfWidth;
    }
    
    [self setContentOffset:CGPointMake(leftSpace, 0) animated:YES];
    
}


#pragma mark - block on the scrollerViewDelegate

-(void)moveToIndex:(float)index{
    
    [self changeLine:index];
    NSInteger tempIndex =[self changeProgressToInteger:index];
    
    if (tempIndex != _currentIndex) {
        
        [self changeItemColor:tempIndex];
    }
    
    _currentIndex =tempIndex;
    
}


-(void)endMoveToIndex:(float)index{
    
    [self changeLine:index];
    [self changeItemColor:index];
    _currentIndex =index;
    
    [self changeScrollOffset:index];
    
}



























@end
