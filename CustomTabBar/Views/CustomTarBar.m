//
//  CustomTarBar.m
//  CustomTabBar
//
//  Created by 123 on 16/4/21.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "CustomTarBar.h"
#import "TabBarButton.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define kTabBarHeight 49
#define kSpacing 5

@interface CustomTarBar ()
{
    //图片数组,二维数组.第一个元素为未选中图片,第二个元素为你选中图片
    NSMutableArray *_markImageArray;
    //标题的数组
    NSMutableArray *_markTitleArray;
    //占位图数组
    NSMutableArray *_placeholderImageArray;
    //标签的数量
    NSInteger _markCount;
    //高斯模糊
    UIVisualEffectView *_effectView;
    UIView *_effectBadgroundView;
}
//存放 button的数组
@property (nonatomic, strong) NSMutableArray *buttonsArray;

@end

@implementation CustomTarBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableArray *)buttonsArray{
    if (!_buttonsArray) {
        self.buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}

//实例 tabBar
- (instancetype)initWithMarkCount:(NSInteger)markCount markImageArray:(NSArray *)markImageArray placeholderImageArray:(NSArray *)placeholderImageArray markTitleArray:(NSArray *)markTitleArray{
    self = [[CustomTarBar alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - kTabBarHeight, SCREENWIDTH, kTabBarHeight)];
    _markImageArray = [markImageArray mutableCopy];
    _markTitleArray = [markTitleArray mutableCopy];
    _placeholderImageArray = [placeholderImageArray mutableCopy];
    _markCount = markCount;
    self.frame = CGRectMake(0, SCREENHEIGHT - kTabBarHeight, SCREENWIDTH, kTabBarHeight);
    [self confgureTabBarButtons];
    self.barTintColor = [UIColor orangeColor];
    return self;
}

//更新 tabBar
- (void)updateMarkImageArray:(NSArray *)markImageArray placeholderImageArray:(NSArray *)placeholderImageArray markTitleArray:(NSArray *)markTitleArray{
    _markImageArray = [markImageArray mutableCopy];
    _markTitleArray = [markTitleArray mutableCopy];
    _placeholderImageArray = [placeholderImageArray mutableCopy];
    [self updateTabBarButtons];
    self.barTintColor = [UIColor orangeColor];
}

- (void)updateTabBarButtons{
    for (int i = 0; i < self.buttonsArray.count; i ++) {
        TabBarButton *tabBarButton = self.buttonsArray[i];
        [tabBarButton updateImage:_markImageArray.firstObject[i] selectedImage:_markImageArray.lastObject[i] placeholderImage:_placeholderImageArray[i] title:_markTitleArray[i]];
    }
}

//切圆角
- (void)cornerRadiusMarkIndexArray:(NSArray *)indexArray{
    if (indexArray == nil) return;
    for (int i = 0; i < indexArray.count; i ++) {
        NSInteger count = [indexArray[i] integerValue];
        if (count > self.buttonsArray.count - 1) return;
        TabBarButton *tabBarButton = self.buttonsArray[count];
        tabBarButton.imageView.layer.cornerRadius = tabBarButton.imageView.frame.size.width / 2;
        tabBarButton.imageView.layer.masksToBounds = YES;
    }
}
- (void)confgureTabBarButtons{
    for (int i = 0; i < _markCount; i ++) {
        
        CGFloat width = (SCREENWIDTH - (_markCount + 1) * kSpacing) / _markCount;
        
        //此处可扩展.扩展中间的 button大点等
        /*
        if (i == 2) {
            TabBarButton *tabBarButton = [[TabBarButton alloc]initWithFrame:CGRectMake(kSpacing * (i + 1) + width * i, 0, width, kTabBarHeight) image:_markImageArray.firstObject[i] selectedImage:_markImageArray.lastObject[i] placeholderImage:_placeholderImageArray[i] title:_markTitleArray[i]];
            [self addSubview:tabBarButton];
            continue;
        }
         */
        TabBarButton *tabBarButton = [[TabBarButton alloc]initWithFrame:CGRectMake(kSpacing * (i + 1) + width * i, 0, width, kTabBarHeight) image:_markImageArray.firstObject[i] selectedImage:_markImageArray.lastObject[i] placeholderImage:_placeholderImageArray[i] title:_markTitleArray[i]];
        [self addSubview:tabBarButton];
        [self.buttonsArray addObject:tabBarButton];
        tabBarButton.tag = 100 + i;
        [tabBarButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        
        tabBarButton.adjustsImageWhenHighlighted = NO;
        if (i == 0) {
            tabBarButton.selected = YES;
        }
        //配置高斯模糊
        if (i == (_markCount - 1)) {
            
            _effectBadgroundView = [[UIView alloc]init];
            _effectBadgroundView.frame = tabBarButton.imageView.bounds;
            _effectBadgroundView.alpha = 0.5;
            
            UIBlurEffect *blureEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _effectView = [[UIVisualEffectView alloc]initWithEffect:blureEffect];
            _effectView.frame = tabBarButton.imageView.bounds;
            _effectView.layer.cornerRadius = _effectView.frame.size.width / 2.0f;
            _effectView.layer.masksToBounds = YES;
            
            //可微调模糊的范围
//            CGRect effectViewFrame = _effectView.frame;
//            CGFloat effectOrigin_x  = effectViewFrame.origin.x - 1;
//            CGFloat effectOrigin_y = effectViewFrame.origin.y - 1;
//            effectViewFrame.origin.x = effectOrigin_x;
//            effectViewFrame.origin.y = effectOrigin_y;
//            _effectView.frame = effectViewFrame;
            
            _effectView.hidden = NO;
            [tabBarButton.imageView addSubview:_effectBadgroundView];
            [_effectBadgroundView addSubview:_effectView];
            
            //初始化高斯模糊状态
            __weak typeof(tabBarButton)weakTabBarButton = tabBarButton;
            tabBarButton.successBlock = ^{
            
                __strong typeof (weakTabBarButton)strongTabBarButton = weakTabBarButton;
                if (strongTabBarButton.selected) {
                    _effectView.hidden = YES;
                }else{
                    _effectView.hidden = NO;
                }
            };
            //获得重新布局 imageview 的大小,设置高斯模糊圆角
            tabBarButton.conrnerRadiusBlock = ^ (BOOL isImage, BOOL isSelectedImage){
                if (isImage || isSelectedImage) {
                    _effectView.layer.cornerRadius = _effectView.frame.size.width / 2.0f;
                    _effectView.layer.masksToBounds = YES;

                }
            };
        }
    }
}

//事件的回调
- (void)handleAction:(UIButton *)sender{
    if (!sender.selected) {
        for (TabBarButton *button in self.buttonsArray) {
            //设置图片
            if (button != sender) {
                button.selected = NO;
            }
            //设置高斯模糊
            if (sender != self.buttonsArray.lastObject) {
                _effectView.hidden = NO;
            }else{
                _effectView.hidden = YES;
            }
        }
        sender.selected = !sender.selected;
    }
       if (self.handleBlock) {
        self.handleBlock(sender);
    }
}

//移除系统的 tabBarButoon
- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:[class class]]) {
            [view removeFromSuperview];
        }
    }
}

@end
