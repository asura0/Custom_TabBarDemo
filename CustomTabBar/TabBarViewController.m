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
    
    self.tabBarViewControllers = [NSMutableArray array];

    //标题的数组
    self.titleArray = [@[@"首页",@"网购",@"相机",@"邮件",@"我的"]mutableCopy];
    
    NSArray *VCArray = @[@"ViewController",@"FistViewController",@"SecondViewController",@"ThirdViewController"];
    
    for (NSString *VCString in VCArray) {
        [self addNewController:VCString];
    }
    
    NSMutableArray *imageArray = [@[@"fistpage-1",@"shoping-1",@"photo-1",@"email-1",@"myself-2"]mutableCopy];
    
    NSMutableArray *selectedImageArray = [@[@"fistpage-2",@"shoping-2",@"photo-2",@"email-2",@"myself-2"]mutableCopy];
    
    NSMutableArray *array = [@[imageArray,selectedImageArray]mutableCopy];
    

    //自定义赋值
    self.custTarBar = [[CustomTarBar alloc]initWithMarkCount:5 markImageArray:array placeholderImageArray:nil markTitleArray: self.titleArray];
    
    [self setValue:_custTarBar forKey:@"tabBar"];
    
    __weak typeof(self)weakSelf = self;
    
    self.custTarBar.handleBlock = ^(UIButton *button){
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.selectedIndex = button.tag - 100;
    };
    
    //模拟更新图片
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageArray removeLastObject];
        [imageArray addObject:@"http://banbao.chazidian.com/uploadfile/2016-01-25/s145368924044608.jpg"];
        [selectedImageArray removeLastObject];
        [selectedImageArray addObject:@"http://banbao.chazidian.com/uploadfile/2016-01-25/s145368924044608.jpg"];
        NSMutableArray *array = [@[imageArray,selectedImageArray]mutableCopy];
        [self.custTarBar updateMarkImageArray:array placeholderImageArray:nil markTitleArray:self.titleArray];
    });
    
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
