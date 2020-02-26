//
//  UIFont+Versa.h
//  Mirror
//
//  Created by sheen on 17/3/13.
//  Copyright © 2017年 sheen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Versa)
+ (UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size;
+ (UIFont*)customFontWithName:(NSString *)fontName size:(CGFloat)fontSize;

+ (UIFont*)AthelasBoldItalicFontWithSize:(CGFloat)fontSize;
+ (UIFont*)AthelasBoldFontWithSize:(CGFloat)fontSize;
+ (UIFont*)jollyGoodBoldFontWithSize:(CGFloat)fontSize;
+ (UIFont*)ledFontWithSize:(CGFloat)fontSize;

@end
