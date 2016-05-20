//
//  TabBarButton.m
//  CustomTabBar
//
//  Created by 123 on 16/4/21.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "TabBarButton.h"

#define kSaveImageName @"saveImage.plist"
#define kSaveSize 5

@interface TabBarButton ()

{
    UIImage *_image;//为选中图片
    UIImage *_selectedImage;//选中图片
    UIImage *_placeholderImage;//占位图片
    NSString *_title;//标题
    BOOL _resultImage;//是否是地址的标示
    BOOL _resultImageto;
    NSString *_saveFile;//缓存路径
    UILabel *_bageValueLabel;//角标
}

@property (nonatomic, assign) float saveSize;//缓存大小


@end

@implementation TabBarButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

#pragma  mark -tabbar
//实例
- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image selectedImage:(NSString *)selectedImage placeholderImage:(NSString *)placeholderImage title:(NSString *)title{
    self = [[TabBarButton alloc]initWithFrame:frame];
    _title = title;
    _saveFile = [self getDoucmentPathFile];
    [self getSize];
    [self confgureImage:image selectedImage:selectedImage placeholderImage:placeholderImage];
    [self confgureBageValue];
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

    self.imageView.frame = CGRectMake(0, 0, self.frame.size.height - 10, self.frame.size.height - 10);
    self.imageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);

    if (_title == nil) return;
    
    //如果有标题,重新布局图片
    self.imageView.frame = CGRectMake(0, 3, self.frame.size.height * 3 / 4 - 8, self.frame.size.height * 3 / 4 - 8);
    //调用 block, 传递信息
    if (self.conrnerRadiusBlock) {
        self.conrnerRadiusBlock(_resultImage,_resultImageto);
    };
    
    CGPoint imageCenter = self.imageView.center;
    imageCenter.x = self.bounds.size.width / 2;
    self.imageView.center = imageCenter;
    
    [self setTitle:_title forState:UIControlStateNormal];

    self.titleLabel.frame = CGRectMake(0, self.frame.size.height * 3 / 4 - 2, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 4);
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)confgureBageValue{
    _bageValueLabel = [[UILabel alloc]init];
    _bageValueLabel.textColor = [UIColor whiteColor];
    _bageValueLabel.font = [UIFont systemFontOfSize:10];
    _bageValueLabel.textAlignment = NSTextAlignmentCenter;
    _bageValueLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) - 10, CGRectGetMinY(self.imageView.frame), 20,15);
    _bageValueLabel.layer.cornerRadius = 8;
    _bageValueLabel.layer.masksToBounds = YES;
    _bageValueLabel.backgroundColor = [UIColor redColor];
    _bageValueLabel.hidden = YES;
    [self addSubview:_bageValueLabel];
    
    [self addObserver:self forKeyPath:@"bageValueLabelText" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - observe @"bageValueLabel.text"
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    NSString *newText = change[NSKeyValueChangeNewKey];
    if ([newText isEqual:[NSNull null]]) {
        _bageValueLabel.hidden = YES;
        return;
    }
    if (newText == nil || [newText isEqualToString:@""]) {
        _bageValueLabel.hidden = YES;
    }else{
        _bageValueLabel.hidden = NO;
        _bageValueLabel.text = self.bageValueLabelText;
    }
}

#pragma mark -network
//配置标签按钮
- (void)confgureImage:(NSString *)image selectedImage:(NSString *)selectedImage placeholderImage:(NSString *)placeholderImage{
    
    _resultImage = [image hasPrefix:@"http://"];
    _resultImageto = [image hasPrefix:@"https://"];
    
    if (placeholderImage != nil) {
        _image = [UIImage imageNamed:placeholderImage];
    }
    [self setImage:[_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    if (!_resultImage && !_resultImageto) {
        if (image != nil) {
            _image = [UIImage imageNamed:image];
            [self setImage:[_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
        if (selectedImage != nil) {
            _selectedImage = [UIImage imageNamed:selectedImage];
            [self setImage:[_selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        }
    }else{
        [self  cacheDownlodImage:image selectedImage:selectedImage];
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
    
    dispatch_async(global, ^{
        //等待信号
        dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //判断请求到的 image 是否正确.如果为 error, 就直接 return
            if (_image != nil) {
                //回到主线程更新 UI
                [self setImage:_image forState:UIControlStateNormal];
            }
            if (_selectedImage != nil) {
                [self setImage:_selectedImage forState:UIControlStateSelected];
                
            }
            //子线程中.完成图片缓存
            [self saveImageWithKeyImage:image image:_image];
            [self saveImageWithKeyImage:selectedImage image:_selectedImage];
    });

        //请求成功 block
        if (self.successBlock) {
            self.successBlock();
        };
    });
}

#pragma mark -cache
//先从缓存中取,没有则网络请求
- (void)cacheDownlodImage:(NSString *)image selectedImage:(NSString *)selectedImage{
    //先获取缓存图片
    BOOL isSaveImage = [self getCacheImage:image isSelected:NO];
    BOOL isSaveSelectedImage = [self getCacheImage:selectedImage isSelected:YES];
    
    if (!isSaveImage) {
        [self downlodImage:image selectedImage:selectedImage];
    }
    if (!isSaveSelectedImage) {
        [self downlodImage:image selectedImage:selectedImage];
    }
}

//先从缓存中取图片
- (BOOL)getCacheImage:(NSString *)image isSelected:(BOOL)isSelected{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:_saveFile];
    NSData *dataImage = [dict objectForKey:image];
    if (dataImage != nil) {
        if (isSelected) {
            _selectedImage = [UIImage imageWithData:dataImage];
        }else{
            _image = [UIImage imageWithData:dataImage];
        }
        //更新 UI
        [self setImage:_image forState:UIControlStateNormal];
        [self setImage:_selectedImage forState:UIControlStateSelected];
        
        return YES;
    }
    return NO;
}

//缓存图片
- (void)saveImageWithKeyImage:(NSString *)imageKey image:(UIImage *)image{
    if (image == nil) {
        return;
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSDictionary *dict = @{imageKey : imageData};
    [dict writeToFile:_saveFile atomically:YES];
}

//获取沙盒路径
- (NSString *)getDoucmentPathFile{
    NSString *pathFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *saveFile = [pathFile stringByAppendingPathComponent:kSaveImageName];
    return saveFile;
}

//获得缓存的大小,大于 kSaveSize 将清除缓存
- (void)getSize{
    NSFileManager *manager = [NSFileManager defaultManager];
    float saveSize = [[manager attributesOfItemAtPath:_saveFile error:nil] fileSize];
    self.saveSize = saveSize / 1024.0 / 1024.0;
    
    if (self.saveSize >= kSaveSize) {
        [[NSFileManager defaultManager]removeItemAtPath:_saveFile error:nil];
    }
}

@end
