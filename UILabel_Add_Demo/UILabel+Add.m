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

void methodSwizzleFunction (Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // 给originalMethod方法添加swizzledMethod方法的实现
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        // 添加成功：说明不存在originalSelector，将swizzledMethod方法中的实现替换成了originalMethod方法的实现，此时的swizzledMethod方法已经指向了originalMethod的实现，即包含了：originalMethod方法和swizzledMethod方法的实现
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        // 添加失败：说明存在originalSelector，直接交换2个方法的实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        {
            // 不能直接重写setHighlighted: 分类优先级较高，会覆盖掉本类的方法
            SEL originalSelector = @selector(setText:);
            SEL swizzledSelector = @selector(hb_setText:);
            
            methodSwizzleFunction(class, originalSelector, swizzledSelector);
        }
    });
}

- (CGFloat)wordSpace{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setWordSpace:(CGFloat)wordSpace{
    objc_setAssociatedObject(self, @selector(wordSpace), @(wordSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)attributes {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAttributes:(NSMutableDictionary *)attributes {
    objc_setAssociatedObject(self, @selector(attributes), attributes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

- (void)hb_setText:(NSString *)text {
    if (self.wordSpace <= 0 && self.lineSpace <= 0 && self.keywords.length <= 0 && self.underlineStr.length <= 0) {
        [self hb_setText:text];
        
        return;
    }
    
    if (text.length <= 0) {
        [self hb_setText:text];
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    
    // 行间距
    if(self.lineSpace > 0){
        [paragraphStyle setLineSpacing:self.lineSpace];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    }
    
    // 字间距
    if(self.wordSpace > 0){
        long number = self.wordSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        CFRelease(num);
    }
    
    // attributes
    for (NSString *name in [self.attributes allKeys]) {
        NSDictionary *attribute = [self.attributes objectForKey:name];
        if (attribute) {
            id value = [attribute objectForKey:@"value"];
            id range = [attribute objectForKey:@"range"];
            if (value && range) {
                [attributedString addAttribute:name value:value range:[range rangeValue]];
            }
        }
    }
    [self.attributes removeAllObjects];
    
    //关键字
    if (self.keywords.length > 0 && (self.keywordsColor || self.keywordsFont)) {
        
        NSRange kRange = [text rangeOfString:self.keywords options:NSBackwardsSearch range:NSMakeRange(0, text.length)];
        
        if (kRange.length > 0) {
            
            if (self.keywordsFont) {
                [attributedString addAttribute:NSFontAttributeName value:self.keywordsFont range:kRange];
            }
            if (self.keywordsColor) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:self.keywordsColor range:kRange];
            }
            
            while(kRange.location != NSNotFound) {
//                NSLog(@"start = %@", NSStringFromRange(kRange));
                NSUInteger start = 0;
                NSUInteger end = kRange.location;
                NSRange temp = NSMakeRange(start, end);
                kRange = [text rangeOfString:self.keywords options:NSBackwardsSearch range:temp];
                
                if (self.keywordsFont) {
                    [attributedString addAttribute:NSFontAttributeName value:self.keywordsFont range:kRange];
                }
                if (self.keywordsColor) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:self.keywordsColor range:kRange];
                }
            }
        }
    }
    
    //下划线
    if (self.underlineStr.length > 0) {
        
        NSRange uRange = [text rangeOfString:self.underlineStr options:NSBackwardsSearch range:NSMakeRange(0, text.length)];
        
        if (uRange.length > 0) {
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:uRange];
            if (self.underlineColor) {
                [attributedString addAttribute:NSUnderlineColorAttributeName value:self.underlineColor range:uRange];
            }
            
            while(uRange.location != NSNotFound) {
//                NSLog(@"start = %@", NSStringFromRange(uRange));
                NSUInteger start = 0;
                NSUInteger end = uRange.location;
                NSRange temp = NSMakeRange(start, end);
                uRange = [text rangeOfString:self.underlineStr options:NSBackwardsSearch range:temp];
                
                [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:uRange];
                if (self.underlineColor) {
                    [attributedString addAttribute:NSUnderlineColorAttributeName value:self.underlineColor range:uRange];
                }
            }
        }
    }

    self.attributedText = attributedString;
}

/**
 AttributedString addAttributes
 */
- (void)setAttributeName:(NSString *)name
          attributeValue:(id)value
                   range:(NSRange)range {
    if (!self.attributes) {
        self.attributes = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    
    if (value) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:value, @"value", [NSValue valueWithRange:range], @"range", nil];
        if (dic && name.length > 0) {
            [self.attributes setObject:dic forKey:name];
        }
    }
}

- (void)setStrokeText:(NSString *)text
          strokeWidth:(CGFloat)width
          strokeColor:(UIColor *)color {
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]initWithString:text];
    CGFloat strokeWidth = -width;
    [mutableAttributedString addAttribute:NSStrokeWidthAttributeName value:@(strokeWidth) range:NSMakeRange(0, [text length])];//设置描边宽度,如果为负数实心颜色会有,如果为正数会变成空心(无实心颜色)
    [mutableAttributedString addAttribute:NSStrokeColorAttributeName value:color range:NSMakeRange(0, [text length])];
    self.attributedText = mutableAttributedString;
}

- (CGSize)getLabelSizeWithMaxWidth:(CGFloat)maxWidth {
    /*
    CGRect rect = [self.attributedText  boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    //设置paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;后高度计算不准确
    */
    
    CGSize maximumLabelSize = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize size = [self sizeThatFits:maximumLabelSize];
//    if (self.lineSpace > 0) {
//        if (size.height < self.font.pointSize * 2) { //1行
//            size.height -= self.lineSpace;
//        }
//    }
    
    return size;
}

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
                numberOfLines:(NSInteger)numberOfLines {
    return [self getTextSizeWithText:text
                            maxWidth:maxWidth
                                font:font
                       numberOfLines:numberOfLines
                           lineSpace:0 wordSpace:0];
}

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
                                 wordSpace:(CGFloat)wordSpace {
    if (text.length <= 0) {
        return CGSizeZero;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.numberOfLines = numberOfLines;
    label.textAlignment = NSTextAlignmentLeft;
    label.lineSpace = lineSpace;
    label.wordSpace = wordSpace;
    label.text = text;
    
    CGSize size = [label getLabelSizeWithMaxWidth:maxWidth];
    return size;
}

+ (CGSize)getTextSizeWithText:(NSString *)text
                     maxWidth:(CGFloat)maxWidth
                         font:(UIFont *)font
                numberOfLines:(NSInteger)numberOfLines
                    lineSpace:(CGFloat)lineSpace {
    return [self getTextSizeWithText:text
                            maxWidth:maxWidth
                                font:font
                       numberOfLines:numberOfLines
                           lineSpace:lineSpace
                           wordSpace:0];
}

#pragma mark - HTML

- (NSString *)htmlString {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHtmlString:(NSString *)htmlString {
    objc_setAssociatedObject(self, @selector(htmlString), htmlString, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (htmlString.length <= 0) {
        return;
    }
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    self.attributedText = attrStr;
    
    /*
     改变字体需在设置htmlString之后设置 
     */
}

+ (CGSize)getTextSizeForHtmlString:(NSString *)htmlString
                          maxWidth:(CGFloat)maxWidth
                     numberOfLines:(NSInteger)numberOfLines{
    if (htmlString.length <= 0) {
        return CGSizeZero;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = numberOfLines;
    label.htmlString = htmlString;
    
    CGSize size = [label getLabelSizeWithMaxWidth:maxWidth];
    return size;
}

@end
