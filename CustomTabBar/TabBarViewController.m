//
//  TabBarViewController.m
//  CustomTabBar
//
//  Created by 123 on 16/4/21.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "TabBarViewController.h"
#import "ViewController.h"
#import "FistViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "MiddleViewController.h"
#import "CustomTarBar.h"

#import <AdSupport/AdSupport.h>

@interface TabBarViewController ()

//控制器的容器的数组
@property (nonatomic, strong) NSMutableArray *tabBarViewControllers;
//icon 的数值
@property (nonatomic, strong) NSMutableArray *tabBarImageArray;
//标题的数组
@property (nonatomic, strong) NSMutableArray *titleArray;
//tabBar
@property (nonatomic, strong) CustomTarBar *custTarBar;

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    
    self.tabBarViewControllers = [NSMutableArray array];

    
    NSArray *VCArray = @[@"ViewController",@"FistViewController",@"SecondViewController",@"ThirdViewController"];
    
    for (NSString *VCString in VCArray) {
        [self addNewController:VCString];
    }
    
    //标题的数组
    self.titleArray = [@[@"首页",@"网购",@"相机",@"我的"]mutableCopy];
    
    NSMutableArray *imageArray = [@[@"fistpage-1",@"shoping-1",@"photo-1",@"myself-2"]mutableCopy];
    
    NSMutableArray *selectedImageArray = [@[@"fistpage-2",@"shoping-2",@"photo-2",@"myself-2"]mutableCopy];
    //icon 数组
    NSMutableArray *iamgeArray = [@[imageArray,selectedImageArray]mutableCopy];
    
    //占位图片
    NSMutableArray *placholeImages = [@[@"fistpage-1",@"shoping-1",@"photo-1",@"myself-2"]mutableCopy];

    
    //自定义赋值
    self.custTarBar = [[CustomTarBar alloc]initWithMarkCount:4 markImageArray:iamgeArray placeholderImageArray:placholeImages markTitleArray: nil];
    
    [self setValue:_custTarBar forKey:@"tabBar"];
    
    __weak typeof(self)weakSelf = self;
    
    self.custTarBar.handleBlock = ^(UIButton *button){
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectedIndex = button.tag - 100;
    };
    
    //模拟更新图片
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageArray removeLastObject];
        [imageArray addObject:@"http://c.hiphotos.baidu.com/zhidao/pic/item/d50735fae6cd7b893ca44ea60e2442a7d8330ece.jpg"];
        [selectedImageArray removeLastObject];
        [selectedImageArray addObject:@"http://c.hiphotos.baidu.com/zhidao/pic/item/d50735fae6cd7b893ca44ea60e2442a7d8330ece.jpg"];
        NSMutableArray *array = [@[imageArray,selectedImageArray]mutableCopy];
        [self.custTarBar updateMarkImageArray:array placeholderImageArray:nil markTitleArray:nil];
        [self.custTarBar cornerRadiusMarkIndexArray:@[@"3"]];

    });
    
    ((TabBarButton *)self.custTarBar.buttonsArray.firstObject).bageValueLabelText = @"22";
}

#pragma mark -添加控制器
- (void)addNewController:(NSString *)VCString{
    Class class = NSClassFromString(VCString);
    id object = [[class alloc]init];
    
    UINavigationController *navigationVC = [[UINavigationController alloc]initWithRootViewController:object];
    [self.tabBarViewControllers addObject:navigationVC];
    self.viewControllers = self.tabBarViewControllers;
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
