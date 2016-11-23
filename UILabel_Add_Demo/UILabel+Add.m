//
//  UILabel+Add.m
//  TaQu
//
//  Created by Soldier on 2016/10/12.
//  Copyright © 2016年 Shaojie Hong. All rights reserved.
//

#import "UILabel+Add.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

@implementation UILabel (Add)

- (CGFloat)wordSpace{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setWordSpace:(CGFloat)wordSpace{
    objc_setAssociatedObject(self, @selector(wordSpace), @(wordSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)lineSpace{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setLineSpace:(CGFloat)lineSpace{
    objc_setAssociatedObject(self, @selector(lineSpace), @(lineSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)keywords {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeywords:(NSString *)keywords {
    objc_setAssociatedObject(self, @selector(keywords), keywords, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIFont *)keywordsFont {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeywordsFont:(UIFont *)keywordsFont {
    objc_setAssociatedObject(self, @selector(keywordsFont), keywordsFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)keywordsColor {
     return objc_getAssociatedObject(self, _cmd);
}

- (void)setKeywordsColor:(UIColor *)keywordsColor {
    objc_setAssociatedObject(self, @selector(keywordsColor), keywordsColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)underlineStr {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnderlineStr:(NSString *)underlineStr {
    objc_setAssociatedObject(self, @selector(underlineStr), underlineStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)underlineColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
     objc_setAssociatedObject(self, @selector(underlineColor), underlineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSString *)styleText {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setStyleText:(NSString *)styleText {
    objc_setAssociatedObject(self, @selector(styleText), styleText, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (styleText.length <= 0) {
        return;
    }
    if (self.wordSpace <= 0 && self.lineSpace <= 0 && self.keywords.length <= 0 && self.underlineStr.length <= 0) {
        self.text = styleText;
        
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:styleText];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, styleText.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    
    // 行间距
    if(self.lineSpace > 0){
        [paragraphStyle setLineSpacing:self.lineSpace];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, styleText.length)];
    }
    
    // 字间距
    if(self.wordSpace > 0){
        long number = self.wordSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        CFRelease(num);
    }
    
    //关键字
    if (self.keywords.length > 0) {
        NSRange kRange = [self.text rangeOfString:self.keywords];
        if (kRange.length > 0) {
            if (self.keywordsFont) {
                [attributedString addAttribute:NSFontAttributeName value:self.keywordsFont range:kRange];
            }
            if (self.keywordsColor) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:self.keywordsColor range:kRange];
            }
        }
    }
    
    //下划线
    if (self.underlineStr.length > 0) {
        NSRange uRange = [self.text rangeOfString:self.underlineStr];
        if (uRange.length > 0) {
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:uRange];
            if (self.underlineColor) {
                [attributedString addAttribute:NSUnderlineColorAttributeName value:self.underlineColor range:uRange];
            }
        }
    }

    self.attributedText = attributedString;
}

- (CGSize)getLabelSizeWithMaxWidth:(CGFloat)maxWidth {
    /*
    CGRect rect = [self.attributedText  boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    //设置paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;后高度计算不准确
    */
    
    CGSize maximumLabelSize = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize size = [self sizeThatFits:maximumLabelSize];
    
    return size;
}


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
                numberOfLines:(NSInteger)numberOfLines {
    return [self getTextSizeWithText:text
                            maxWidth:maxWidth
                                font:font
                       numberOfLines:numberOfLines
                           lineSpace:0 wordSpace:0];
}


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
                                 wordSpace:(CGFloat)wordSpace {
    if (text.length <= 0) {
        return CGSizeZero;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.numberOfLines = numberOfLines;
    label.textAlignment = NSTextAlignmentLeft;
    
    if (lineSpace <= 0 && wordSpace <= 0) {
        label.text = text;
        CGSize size = [label getLabelSizeWithMaxWidth:maxWidth];
        
        return size;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    
    if (lineSpace > 0) {
        label.lineSpace = lineSpace;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = label.textAlignment;
        paragraphStyle.lineBreakMode = label.lineBreakMode;
        
        [paragraphStyle setLineSpacing:label.lineSpace];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    }
    if (wordSpace > 0) {
        label.wordSpace = wordSpace;
        
        long number = label.wordSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        CFRelease(num);
    }
    
    label.attributedText = attributedString;
  
    CGSize size = [label getLabelSizeWithMaxWidth:maxWidth];
    return size;
}

+ (CGSize)getTextSizeWithText:(NSString *)text
                     maxWidth:(CGFloat)maxWidth
                         font:(UIFont *)font
                numberOfLines:(NSInteger)numberOfLines
                    lineSpace:(CGFloat)lineSpace {
    return [self getTextSizeWithText:text maxWidth:maxWidth font:font numberOfLines:numberOfLines lineSpace:lineSpace wordSpace:0];
}

@end
