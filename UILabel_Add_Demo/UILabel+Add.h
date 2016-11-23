//
//  UILabel+Add.h
//  TaQu
//
//  Created by Soldier on 2016/10/12.
//  Copyright © 2016年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 适用于多行文本
 */

@interface UILabel (Add)

/**
 * 字间距
 */
@property (nonatomic, assign) CGFloat wordSpace;

/**
 * 行间距
 */
@property (nonatomic, assign) CGFloat lineSpace;

/**
 * 关键字
 */
@property (nonatomic, copy) NSString *keywords;
@property (nonatomic, strong) UIFont *keywordsFont;
@property (nonatomic, strong) UIColor *keywordsColor;

/**
 * 下划线
 */
@property (nonatomic, copy) NSString *underlineStr;
@property (nonatomic, strong) UIColor *underlineColor;

/**
 * 使用styleText赋值
 */
@property (nonatomic, strong) NSString *styleText;


- (CGSize)getLabelSizeWithMaxWidth:(CGFloat)maxWidth;

/**
 计算文本高度，适用于普通文本
 
 @param text
 @param maxWidth
 @param font
 @param numberOfLines
 
 @return CGSize
 */
+ (CGSize)getTextSizeWithText:(NSString *)text
                     maxWidth:(CGFloat)maxWidth
                         font:(UIFont *)font
                numberOfLines:(NSInteger)numberOfLines;
/**
 计算文本高度，适用于需要修改行间距字间距的文本
 
 @param text
 @param maxWidth
 @param font
 @param numberOfLines
 @param lineSpace
 @param wordSpace
 
 @return CGSize
 */
+ (CGSize)getTextSizeWithText:(NSString *)text
                     maxWidth:(CGFloat)maxWidth
                         font:(UIFont *)font
                numberOfLines:(NSInteger)numberOfLines
                    lineSpace:(CGFloat)lineSpace
                    wordSpace:(CGFloat)wordSpace;

+ (CGSize)getTextSizeWithText:(NSString *)text
                     maxWidth:(CGFloat)maxWidth
                         font:(UIFont *)font
                numberOfLines:(NSInteger)numberOfLines
                    lineSpace:(CGFloat)lineSpace;

@end
