//
//  CustomTarBar.h
//  CustomTabBar
//
//  Created by 123 on 16/4/21.
//  Copyright © 2016年 asura. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^handleActionBlock)(UIButton *button);

@interface CustomTarBar : UITabBar

@property (nonatomic, copy) handleActionBlock handleBlock;

/**
 *  asura 2016-4-21
 *
 *  @param markCount             标签个数
 *  @param markImageArray        标签数组.二维数组.第一个元素为未选中图片,第二个元素为选中图片
 *  @param placeholderImageArray 占位图片数组
 *  @param markTitleArray        标题数组(可以为nil, nil时图片自动铺满)
 *
 *  @return CustomTarBar class
 */
- (instancetype)initWithMarkCount:(NSInteger)markCount markImageArray:(NSArray *)markImageArray placeholderImageArray:(NSArray *)placeholderImageArray markTitleArray:(NSArray *)markTitleArray;

/**
 *  asura 2016-4-21
 *
 *  @param markImageArray        更新标签数组.二维数组.第一个元素为未选中图片,第二个元素为选中图片
 *  @param placeholderImageArray 更新占位图片数组
 *  @param markTitleArray        更新标题数组(可以为nil, nil时图片自动铺满)
 */
- (void)updateMarkImageArray:(NSArray *)markImageArray placeholderImageArray:(NSArray *)placeholderImageArray markTitleArray:(NSArray *)markTitleArray;

@end
