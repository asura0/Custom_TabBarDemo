//
//  TabBarButton.h
//  CustomTabBar
//
//  Created by 123 on 16/4/21.
//  Copyright © 2016年 asura. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^success)();
typedef void (^layoutConrnerRadius)(BOOL isImage, BOOL isSelectedImage);


@interface TabBarButton : UIButton

//角标
@property (nonatomic, copy) NSString *bageValueLabelText;

/**
 *  asura 2016-4-21
 *
 *  @param frame            标签按钮的大小
 *  @param image            未选中图片(可以是名字,也可以是地址)
 *  @param selectedImage    选中图片(可以是名字,也可以是地址)
 *  @param placeholderImage 占位图片(现只支持名字)
 *  @param title            标签按钮的标题 (可以为 nil)
 *
 *  @return TabBarButton class
 */
- (instancetype)initWithFrame:(CGRect)frame image:(id)image selectedImage:(id)selectedImage placeholderImage:(id)placeholderImage title:(NSString *)title;

/**
 *  asura 2016-4-21
 *
 *  @param image            未选中图片(可以是名字,也可以是地址)
 *  @param selectedImage    选中图片(可以是名字,也可以是地址)
 *  @param placeholderImage 占位图片(现只支持名字)
 *  @param title            标签按钮的标题 (可以为 nil)
 */
- (void)updateImage:(id)image selectedImage:(id)selectedImage placeholderImage:(id)placeholderImage title:(NSString *)title;


@property (nonatomic, copy) success successBlock;
@property (nonatomic, copy) layoutConrnerRadius conrnerRadiusBlock;


@end
