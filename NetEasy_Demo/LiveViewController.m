//
//  LiveViewController.m
//  NetEasy_Demo
//
//  Created by 梁志成 on 2016/11/8.
//  Copyright © 2016年 梁志成. All rights reserved.
//

#import "LiveViewController.h"
#import "UIImageView+WebCache.h"

@interface LiveViewController ()

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    //imageview.image = [UIImage imageNamed:@"http://cms-bucket.nosdn.127.net/a7b866b13fed449281e24e5c92a03e3620161122093254.jpeg"];
   // imageview.image = [UIImage imageNamed:@"1.jpg"];
    
    NSURL *picURL = [NSURL URLWithString:@"http://cms-bucket.nosdn.127.net/a7b866b13fed449281e24e5c92a03e3620161122093254.jpeg"];
    [imageview sd_setImageWithURL:picURL];
    
    
    [self.view addSubview:imageview];
    
}

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
