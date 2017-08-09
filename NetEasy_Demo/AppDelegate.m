//
//  AppDelegate.m
//  NetEasy_Demo
//
//  Created by 梁志成 on 2016/11/7.
//  Copyright © 2016年 梁志成. All rights reserved.
//

#import "AppDelegate.h"

#import "PersonViewController.h"
#import "TopicViewController.h"
#import "LiveViewController.h"
#import "NewsViewController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#if 1
    //设置背景
    self.window.backgroundColor =[UIColor lightGrayColor];
    //tabbar
    UITabBarController *tabCtl =[[UITabBarController alloc]init];
    self.window.rootViewController =tabCtl;
    
    //创建子控制器
    NewsViewController *ctr1 =[[NewsViewController alloc]init];
    //ctr1.view.backgroundColor =[UIColor redColor];
    ctr1.tabBarItem.title =@"新闻";
    ctr1.tabBarItem.image =[UIImage imageNamed:@"night_tabbar_icon_news_normal"];
    UIImage *select =[UIImage imageNamed:@"night_tabbar_icon_news_highlight"];
    ctr1.tabBarItem.selectedImage =[select imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [ctr1.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    
    LiveViewController *ctr2 =[[LiveViewController alloc]init];
    //ctr2.view.backgroundColor =[UIColor whiteColor];
    ctr2.tabBarItem.title =@"直播";
    ctr2.tabBarItem.image =[UIImage imageNamed:@"night_tabbar_icon_media_normal"];
    UIImage*select2 =[UIImage imageNamed:@"night_tabbar_icon_media_highlight"];
    ctr2.tabBarItem.selectedImage =[select2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //选中文字颜色
    [ctr2.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    
    TopicViewController *ctr3 =[[TopicViewController alloc]init];
    ctr3.view.backgroundColor =[UIColor greenColor];
    ctr3.tabBarItem.title =@"话题";
    ctr3.tabBarItem.image =[UIImage imageNamed:@"night_tabbar_icon_bar_normal"];
    UIImage *select3 =[UIImage imageNamed:@"night_tabbar_icon_bar_highlight"];
    ctr3.tabBarItem.selectedImage =[select3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [ctr3.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    PersonViewController *ctr4 =[[PersonViewController alloc]init];
    ctr4.view.backgroundColor =[UIColor blueColor];
    ctr4.tabBarItem.title =@"个人";
    ctr4.tabBarItem.image =[UIImage imageNamed:@"night_tabbar_icon_me_normal"];
    UIImage *select4 =[UIImage imageNamed:@"night_tabbar_icon_me_highlight"];
    ctr4.tabBarItem.selectedImage =[select4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [ctr4.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    //添加自控制器到tabbarcontroller 中
   // tabCtl.viewControllers =@[@"ctr1",@"ctr2",@"ctr3",@"ctr4"];
    tabCtl.viewControllers =@[ctr1,ctr2,ctr3,ctr4];
    //[tabCtl.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
#endif
#pragma mark -UINavigationController
    //self.window.rootViewController =[[UINavigationController alloc]initWithRootViewController:[ViewController alloc] ];
#if 0
    ViewController *root =[[ViewController alloc]init];
    UINavigationController *navctrl =[[UINavigationController alloc]initWithRootViewController:root];
    self.window.rootViewController =navctrl;
    
#endif
   // UINavigationController *nav =[[UINavigationController alloc]init];
   
    

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
