//
//  TabBarButton.m
//  CustomTabBar
//
//  Created by 123 on 16/4/21.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "TabBarButton.h"

typedef void(^success)(UIImage *image);
typedef void(^failure)(NSError *error);

@interface TabBarButton ()

{
    UIImage *_image;//为选中图片
    UIImage *_selectedImage;//选中图片
    UIImage *_placeholderImage;//占位图片
    NSString *_title;//标题
    BOOL _resultImage;//是否是地址的标示
    BOOL _resultImageto;
}

@end

@implementation TabBarButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


//实例
- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image selectedImage:(NSString *)selectedImage placeholderImage:(NSString *)placeholderImage title:(NSString *)title{
    self = [[TabBarButton alloc]init];
    self.frame = frame;
    _title = title;
    [self confgureImage:image selectedImage:selectedImage placeholderImage:placeholderImage];
    return self;
}

//更新
- (void)updateImage:(NSString *)image selectedImage:(NSString *)selectedImage placeholderImage:(NSString *)placeholderImage title:(NSString *)title{
    _title = title;
    [self confgureImage:image selectedImage:selectedImage placeholderImage:placeholderImage];
}

//根据标签标题和图片是否是地址重新布局
- (void)layoutSubviews{
    [super layoutSubviews];

    if (_title == nil) return;
    self.imageView.frame = CGRectMake(self.frame.size.width / 4 + 4, 5, self.frame.size.width / 2 - 8, self.frame.size.height * 3 / 4  - 8);
    if (_resultImage || _resultImageto) {
        
    }else{
        self.imageView.frame = CGRectMake(self.frame.size.width / 4, 0, self.frame.size.width / 2 , self.frame.size.height * 3 / 4 );
    }
    
    [self setTitle:_title forState:UIControlStateNormal];

    self.titleLabel.frame = CGRectMake(0, self.frame.size.height * 3 / 4 - 2, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds) / 6);
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

//配置标签按钮
- (void)confgureImage:(NSString *)image selectedImage:(NSString *)selectedImage placeholderImage:(NSString *)placeholderImage{
    _resultImage = [image hasPrefix:@"http://"];
    _resultImageto = [image hasPrefix:@"https://"];
//    _image = [UIImage imageNamed:placeholderImage];
    [self setImage:[_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    if (!_resultImage && !_resultImageto) {
        _image = [UIImage imageNamed:image];
        _selectedImage = [UIImage imageNamed:selectedImage];
        [self setImage:[_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self setImage:[_selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    }else{
        [self downlodImage:image selectedImage:selectedImage];
    }
}

//网络请求下载图片
- (void)downlodImage:(NSString *)image selectedImage:(NSString *)selectedImage{
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建信号量
    dispatch_semaphore_t semphore = dispatch_semaphore_create(0);
    
    dispatch_async(global, ^{
        _image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:image]]];
        //发信号
        dispatch_semaphore_signal(semphore);
    });
    dispatch_async(global, ^{
        _selectedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:selectedImage]]];
        dispatch_semaphore_signal(semphore);
    });
    //等待信号
    dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        //回到主线程更新 UI
        [self setImage:_image forState:UIControlStateNormal];
        [self setImage:_selectedImage forState:UIControlStateSelected];
    });
}

@end
