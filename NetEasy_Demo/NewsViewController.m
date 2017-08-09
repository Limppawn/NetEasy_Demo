//
//  NewsViewController.m
//  NetEasy_Demo
//
//  Created by 梁志成 on 2016/11/8.
//  Copyright © 2016年 梁志成. All rights reserved.
//

#import "NewsViewController.h"
#import "NetEasyControllView.h"
#import "NewsCell.h"
#import "News.h"
#import "Ads.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

// 复用标记
#define KReuseID @"cell"
//xib文件
#define KXibName @"NewsCell"

@interface NewsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NetEasyControllView *itemControlview;
    
    //BOOL IsNotFlag; //default flag is yes;
}


@property(nonatomic,strong)UIView *btnView;
@property(nonatomic,strong)UIScrollView *topScrollView; // 循环滚动
@property(nonatomic,strong)UIPageControl *pageCtl;//翻页控制
@property(nonatomic,assign)NSInteger count; //计数
@property(nonatomic,strong)UIScrollView *scrollview;
@property(nonatomic,strong)UIView *topView; //tableview 头部视图

@property(nonatomic,strong)UITableView *tableview; // 表格视图
@property(nonatomic,strong)NSURLSessionDataTask *dataTask;
@property(nonatomic,strong)NSMutableArray *resourArr;

@property(nonatomic,assign)NSInteger page; //数据页码，表示下次打开第几页的数据

//滚动title
@property(nonatomic,strong)NSArray *labelArr; // title数据源 (scrollview shujuyuan)
@property(nonatomic,strong)UILabel *titleLab;

@property(nonatomic,strong)NSMutableArray *titleArr;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *imgStr;
@property(nonatomic,strong)NSMutableArray *imgArr;

//移动view
@property(nonatomic,strong)UIView *touchView;
@property(nonatomic,assign)CGPoint beginPoint; //touchView起始坐标

@end

@implementation NewsViewController

#if 1
-(NSMutableArray *)titleArr{
    
    if (!_titleArr) {
        _titleArr =[NSMutableArray new];
    }
    return _titleArr;
}
#endif
-(NSMutableArray *)imgArr{
    
    if (!_imgArr) {
        _imgArr =[NSMutableArray new];
    }
    return _imgArr;
}


-(NSMutableArray *)resourArr{
    if (!_resourArr) {
        _resourArr =[NSMutableArray new];
    }
    return _resourArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self updateData];
    [self creatTopUI];
    [self creatUITableview];
    [self creatRefresh];
    
    [self touchViewMove];
    
    

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //开始刷新
    [self.tableview.mj_header beginRefreshing];
}

#pragma mark - MJRefresh 上下拉刷新
-(void)creatRefresh{
    //弱引用
    __weak typeof(self)weakSelf = self;
    //下拉刷新
    self.tableview.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
  
        [weakSelf updateData];
    }];
    //上拉加载更多
    self.tableview.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
     
        weakSelf.page = 1;
    
        [weakSelf updateData];
        
    }];
}

//停止刷新
-(void)endRefresh{
    
    [self.tableview.mj_header endRefreshing];
    [self.tableview.mj_footer endRefreshing];
}

#pragma mark - UITableview
-(void)creatUITableview{
    
    self.tableview =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -100-49) style:UITableViewStylePlain];
    
    //设置代理
    self.tableview.delegate =self;
    self.tableview.dataSource =self;
    self.tableview.backgroundColor =[UIColor yellowColor];
    
    //注册
    [self.tableview registerNib:[UINib nibWithNibName:KXibName bundle:nil] forCellReuseIdentifier:KReuseID];
    
    
    self.tableview.tableHeaderView =self.topView;
    [self.scrollview addSubview:self.tableview];
    
    
}




#pragma mark - 数据请求

//停止下载
-(void)viewDidDisappear:(BOOL)animated{
   
    [super viewDidDisappear:animated];
    [self.dataTask cancel];
    
}

-(void)updateData{
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    //设置最大并发数
    manager.session.configuration.HTTPMaximumConnectionsPerHost =3;
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    NSString *url_str =[NSString stringWithFormat:@"http://c.m.163.com/recommend/getSubDocPic?from=toutiao&prog=&open=&openpath=&fn=1&passport=&devId=rM8m8ZUu2ctzJf4P23U3rxsdOxRfl5D%%2FPpFf4hHRard2A8lRPoEj4wRRKleNk5Ob&offset=0&size=10&version=17.2&spever=false&net=wifi&lat=&lon=&ts=1479222443&sign=ckzr2J0Vit2qq1FhJzlQVuDBlWXmOBb4oil%%2BLNvalzR48ErR02zJ6%%2FKXOnxX046I&encryption=%ld&canal=appstore",self.page];
    
    //NSString *url_str =@"http://c.m.163.com/recommend/getSubDocPic?from=toutiao&prog=&open=&openpath=&fn=1&passport=&devId=rM8m8ZUu2ctzJf4P23U3rxsdOxRfl5D%2FPpFf4hHRard2A8lRPoEj4wRRKleNk5Ob&offset=0&size=10&version=17.2&spever=false&net=wifi&lat=&lon=&ts=1479222443&sign=ckzr2J0Vit2qq1FhJzlQVuDBlWXmOBb4oil%2BLNvalzR48ErR02zJ6%2FKXOnxX046I&encryption=1&canal=appstore";
    self.dataTask =[manager GET:url_str parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
      
        NSLog(@"数据请求成功!!!");
       // NSLog(@"headerfields=%@",[(NSHTTPURLResponse *)task.response allHeaderFields]);
        id jsonObj =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *newsArr =jsonObj[@"tid"];
        
        [self.titleArr removeAllObjects];
        [self.imgArr removeAllObjects];
        //遍历
        for (NSDictionary *dict in newsArr) {
            
            News *newsModel =[[News alloc]initWithDictionary:dict error:nil];
            [self.resourArr addObject:newsModel];
            
            //NSLog(@"ads = %@",dict[@"ads"]);
            NSArray * allArr =dict[@"ads"];
            //NSLog(@"allArr = %@",allArr);
            for (NSDictionary *dict in allArr) {
                self.titleStr = dict[@"title"];
                self.imgStr = dict[@"imgsrc"];
            
                [self.titleArr addObject:self.titleStr];
                [self.imgArr addObject:self.imgStr];
                
               // NSLog(@"imgArr = %@",self.imgArr);
                
            }
            
        }
        
        NSLog(@"title.count =%ld",self.titleArr.count);
        NSLog(@"imgArr.count = %ld",self.imgArr.count);
        //刷新UI
        [self.tableview reloadData];
        //结束刷新
        [self endRefresh];
#pragma mark - creatScrollViewWithUI
      
        [self creatScrollViewWithUIWithData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //结束刷新
        [self endRefresh];
        NSLog(@"error = %@",error);
    }];
   
    //开始执行
    [self.dataTask resume];
    
}



#pragma mark - 头部UI
-(void)creatTopUI{
    
    float width =[UIScreen mainScreen].bounds.size.width;
    float height =[UIScreen mainScreen].bounds.size.height;
    
    //标题集合
    
    NSArray *titleArr =@[@"头条",@"精选",@"娱乐",@"体育",@"网易号",@"本地",@"视频",@"财经",@"科技"];
    
    //展示详情的UIScrollview
    self.scrollview =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, width, height-100)];
    
    //set the delegate
    self.scrollview.delegate =self;
    self.scrollview.pagingEnabled =YES;
    
    self.scrollview.showsVerticalScrollIndicator =NO;
    self.scrollview.showsHorizontalScrollIndicator =NO;
    self.scrollview.contentSize =CGSizeMake(width *titleArr.count, 100);
    self.scrollview.tag =11;
    
    for (int i =0; i<titleArr.count; i++) {
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(width * i, 0, width, height -100)];
        label.text =titleArr[i];
        label.backgroundColor =[UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
        label.textAlignment =NSTextAlignmentCenter;
        
    }
    
    [self.view addSubview:self.scrollview];
    
#if 1
#pragma mark - UIScrollView
    //自定义tableview头部视图
    self.topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    
    //滚动视图
    self.topScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    self.topScrollView.backgroundColor =[UIColor orangeColor];
    //设置内容大小
    self.topScrollView.contentSize =CGSizeMake(self.view.frame.size.width *7, 180);
    //翻页，滚动,反弹
    self.topScrollView.pagingEnabled =YES;
  //  self.topScrollView.scrollEnabled =YES;
 //   self.topScrollView.bounces = NO;
    self.topScrollView.showsHorizontalScrollIndicator =YES;
    self.topScrollView.tag = 10;
    //设置代理
    self.topScrollView.delegate =self;
    //添加到topView
    [self.topView addSubview:self.topScrollView];

   
    
#pragma mark - UIPageController
   // self.pageCtl =[[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 170, 100, 10)];
    self.pageCtl =[[UIPageControl alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 30)];
    self.pageCtl.backgroundColor =[UIColor lightGrayColor];
    //设置页数
    self.pageCtl.numberOfPages =4;
    
#if 1
    //小圆点居右
    NSInteger count =4; //小圆点个数
    CGSize pointSize =[self.pageCtl sizeForNumberOfPages:count];
    CGFloat page_x =-(self.pageCtl.bounds.size.width - pointSize.width)/2;
    [self.pageCtl setBounds:CGRectMake(page_x, 0, self.view.frame.size.width, 30)];
#endif
    //color
    self.pageCtl.currentPageIndicatorTintColor =[UIColor redColor];
    self.pageCtl.pageIndicatorTintColor =[UIColor greenColor];
    self.pageCtl.alpha = 0.4;
    //add target
    [self.pageCtl addTarget:self action:@selector(pagechange:) forControlEvents:UIControlEventValueChanged];
    [self.topView addSubview:self.pageCtl];
    

    //titleview
    UIView *titleview =[[UIView alloc]initWithFrame:CGRectMake(page_x, 0, self.view.frame.size.width-80, 30)];
    //titleview.alpha =0.4;
    titleview.backgroundColor =[UIColor redColor];
    [self.pageCtl addSubview:titleview];
#if 1
    //titlelabel
       // self.labelArr =@[@"",@"我们都有一个家，名字叫叫中国",@"我们都有一个家",@"一个家，名字叫叫中国",@"我们名字叫叫中国"];
    
    
        self.titleLab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width -80, 30)];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.font =[UIFont systemFontOfSize:18.0f];
        [titleview addSubview:self.titleLab];
    
    
#endif
    
 
       _count =1;
    //时间  -  自动循环
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
   
#endif
    
    
#pragma mark - config for section
    
    NetItemConfig *config =[[NetItemConfig alloc]init];
    config.itemWidth =width /4.0;
    
    itemControlview =[[NetEasyControllView alloc]initWithFrame:CGRectMake(0, 100-44, width, 44)];
    itemControlview.tapAnimation =YES;
    itemControlview.config =config;
    itemControlview.titleArray =titleArr;
    
    //weak
    __weak typeof(self.scrollview)weakScrollview =self.scrollview;
    
    [itemControlview setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        [weakScrollview scrollRectToVisible:CGRectMake(index *weakScrollview.frame.size.width, 0.0, weakScrollview.frame.size.width,weakScrollview.frame.size.height) animated:YES];
        
    }];
    
    [self.view addSubview:itemControlview];
    
#pragma mark - add + icon
    UIButton *addBtn =[[UIButton alloc]initWithFrame:CGRectMake(width-config.itemWidth/2.0, 100-44, config.itemWidth/2.0, 60)];
    [addBtn setImage:[UIImage imageNamed:@"addIcon.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];

}

#if 1
-(void)creatScrollViewWithUIWithData{
    //添加图片
    for (int i =0; i<7; i++) {
        
        UIImageView *scImageView =[[UIImageView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.height, 180)];
        //网络加载图片
        // NSURL *picURL = [NSURL URLWithString:self.imgArr[i]];
        if (i==0) {
            
            NSURL *picURL =[NSURL URLWithString:self.imgArr[4]];
            [scImageView sd_setImageWithURL:picURL];
            
        }else if (i==6){
            
            NSURL * picURL = [NSURL URLWithString:self.imgArr[0]];
            [scImageView sd_setImageWithURL:picURL];
            
        }else{
            NSURL * picURL = [NSURL URLWithString:self.imgArr[i-1]];
            [scImageView sd_setImageWithURL:picURL];
        }
        
        // [scImageView sd_setImageWithURL:picURL];
        [self.topScrollView addSubview:scImageView];
    }


}

#endif

#pragma mark - 首页可选项目弹框
-(void)creatUIView{
    
    self.btnView =[[UIView alloc]init];
    self.btnView.backgroundColor =[UIColor whiteColor];
    self.btnView.hidden = YES;
    [self.view addSubview:self.btnView];
    
//deleBtn
    UIButton *deleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    deleBtn.frame =CGRectMake(self.view.frame.size.width - 40, 0, 40, 40);
    [deleBtn setImage:[UIImage imageNamed:@"deleIcon.png"] forState:UIControlStateNormal];
    [deleBtn addTarget:self action:@selector(deleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:deleBtn];
}

#pragma mark - UIView 跟随移动
-(void)touchViewMove{
    
    self.touchView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, self.view.frame.size.height-150, 150, 150)];
    self.touchView.backgroundColor = [UIColor whiteColor];
    self.touchView.alpha = 0.8;
    
    UIImageView *touchImageview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 150)];
    touchImageview.image = [UIImage imageNamed:@"1.jpg"];
    //交互
    touchImageview.userInteractionEnabled = YES;
    [self.touchView addSubview:touchImageview];
    
    UIButton *touchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    touchBtn.frame = CGRectMake(100, 0, 50, 50);
    touchBtn.backgroundColor =[UIColor redColor];
    [touchBtn setImage:[UIImage imageNamed:@"deleIcon.png"] forState:UIControlStateNormal];
    [touchBtn addTarget:self action:@selector(touchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.touchView addSubview:touchBtn];
    
    
    [self.view addSubview:self.touchView];
    
}

//移动view 中的dele按钮事件
-(void)touchBtnAction:(UIButton *)btn{
    
    //移除视图
    [self.touchView removeFromSuperview];
}

//touchview 事件

//开始移动
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch =[touches anyObject];
    self.beginPoint =[touch locationInView:self.view];
    [super touchesBegan:touches withEvent:event];
    
}

//view 移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    
    UITouch *touch =[touches anyObject];
    CGPoint currentLocation =[touch locationInView:self.view];
    CGRect frame = self.view.frame;
    frame.origin.x += currentLocation.x - self.beginPoint.x;
    
    
}


//触摸停止时
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
}

//取消事件
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
}



#pragma mark - UIPageController 事件
-(void)pagechange:(UIPageControl *)page{
    
    //同步topscrollerview
    [self.topScrollView setContentOffset:CGPointMake(self.view.frame.size.width * page.currentPage, 0) animated:YES];
    
    //同步titleView
    self.titleLab.text =self.titleArr[page.currentPage];
    
}

#pragma mark - NSTimer 事件
-(void)timeAction:(NSTimer *)time{
    
    _count ++;
    if (_count == 5) {
        _count =1;
    }
    
    //同步topscrolview
    [self.topScrollView setContentOffset:CGPointMake(self.view.frame.size.width *_count, 0) animated:YES];
    //同步pagectl
    self.pageCtl.currentPage = _count - 1; //default 0
    self.titleLab.text = self.titleArr[_count-1];

}


#pragma mark - Button 点击事件
-(void)deleButton:(UIButton *)button{

    self.btnView.hidden =YES;
    //IsNotFlag = NO; //关键标志
}

-(void)addButton:(UIButton *)button{

    //creatUIView.frame
    [self creatUIView];
    self.btnView.frame =CGRectMake(0, 64, self.view.frame.size.width, 1);
  
    [UIView animateWithDuration:0.5 animations:^{
    
        self.btnView.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 113);
        self.btnView.hidden = NO;
    }];
    
    
    //单个按钮控制UIView是否显示
#if 0
    if (IsNotFlag) {
        self.btnView.hidden =YES;
    }else{
        
        self.btnView.hidden =NO;
    }
    
    IsNotFlag =!IsNotFlag;
#endif
}


#pragma mark - UITabelViewDelegate & UITabelViewDataSource

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.0f;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.resourArr.count - 1;
    //return self.resourArr.count - 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
#if 1
    NewsCell *cell =[tableView dequeueReusableCellWithIdentifier:KReuseID];
    if (cell==nil) {
        
        cell =[[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KReuseID];
    }
    News *newsModel = self.resourArr[indexPath.row];
    [cell refreshUI:newsModel];
#endif
    //改变cell 系统默认颜色
    //cell.selectionStyle =UITableViewCellSelectionStyleNone;
    return cell;
}

//选中某一行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}



#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 11) {
        
    
    float offset =scrollView.contentOffset.x;
    offset =offset/CGRectGetWidth(scrollView.frame);
    [itemControlview moveToIndex:offset];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //topscrolview 代理方法
    //同步uipagecontrller
    if (scrollView.tag == 10) {
        
        if (scrollView.contentOffset.x == self.view.frame.size.width *5) {
            
            scrollView.contentOffset =CGPointMake(self.view.frame.size.width, 0);
        }else if (scrollView.contentOffset.x == 0){
            
            scrollView.contentOffset = CGPointMake(self.view.frame.size.width *4, 0);
        }
        
        //同步
        self.pageCtl.currentPage =scrollView.contentOffset.x / self.view.frame.size.width -1;
    }else if (scrollView.tag ==11){
        
     
        float offset =scrollView.contentOffset.x;
        offset =offset/CGRectGetWidth(scrollView.frame);
        [itemControlview endMoveToIndex:offset];
        
    }
   
    
}

#pragma mark - Helps
#if 0
-(void)refreUIforScrollView:(Ads *)adsModel{
    
    self.titleLab.text = adsModel.title;
    
    
    
}
#endif



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
