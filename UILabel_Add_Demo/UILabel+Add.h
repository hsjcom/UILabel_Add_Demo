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
 AttributedString addAttributes
 */
@property (nonatomic, strong) NSMutableDictionary *attributes;

/**
 * 关键字
 */
@property (nonatomic, strong) NSString *keywords;
@property (nonatomic, strong) UIFont *keywordsFont;
@property (nonatomic, strong) UIColor *keywordsColor;

/**
 * 下划线
 */
@property (nonatomic, strong) NSString *underlineStr;
@property (nonatomic, strong) UIColor *underlineColor;

/**
 * HTML string
 */
@property (nonatomic, strong) NSString *htmlString;

- (void)setStrokeText:(NSString *)text
          strokeWidth:(CGFloat)width
          strokeColor:(UIColor *)color;

/**
 AttributedString addAttributes
 */
- (void)setAttributeName:(NSString *)name
          attributeValue:(id)value
                   range:(NSRange)range;

- (CGSize)getLabelSizeWithMaxWidth:(CGFloat)maxWidth;

/**
 计算文本高度，适用于普通文本
 @param text text
 @param maxWidth maxWidth
 @param font font
 @param numberOfLines numberOfLines
 
 @return CGSize
 */
+ (CGSize)getTextSizeWithText:(NSString *)text
                     maxWidth:(CGFloat)maxWidth
                         font:(UIFont *)font
                numberOfLines:(NSInteger)numberOfLines;
/**
 计算文本高度，适用于需要修改行间距字间距的文本
 
 @param text text
 @param maxWidth maxWidth
 @param font font
 @param numberOfLines numberOfLines
 @param lineSpace lineSpace
 @param wordSpace wordSpace
 
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

/**
 计算HTML文本高度
 @return CGSize
 */
+ (CGSize)getTextSizeForHtmlString:(NSString *)htmlString
                          maxWidth:(CGFloat)maxWidth
                     numberOfLines:(NSInteger)numberOfLines;

@end
