//
//  UIFont+Versa.m
//  Mirror
//
//  Created by sheen on 17/3/13.
//  Copyright © 2017年 sheen. All rights reserved.
//

#import "UIFont+Versa.h"
#import <CoreText/CoreText.h>

@implementation UIFont (Versa)
+ (UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size
{
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

+ (UIFont*)AthelasBoldItalicFontWithSize:(CGFloat)fontSize
{
    NSString* fontPath = [[NSBundle mainBundle] pathForResource:@"Athelas Bold Italic" ofType:@"TTF"];
 
    return [UIFont customFontWithPath:fontPath size:fontSize];
}

+ (UIFont*)AthelasBoldFontWithSize:(CGFloat)fontSize {
    NSString* fontPath = [[NSBundle mainBundle] pathForResource:@"Athelas-Bold" ofType:@"ttf"];
    return [UIFont customFontWithPath:fontPath size:fontSize];
}

+ (UIFont*)jollyGoodBoldFontWithSize:(CGFloat)fontSize {
    NSString* fontPath = [[NSBundle mainBundle] pathForResource:@"JollyGoodSemiBold" ofType:@"ttf"];
    return [UIFont customFontWithPath:fontPath size:fontSize];
}

+ (UIFont*)ledFontWithSize:(CGFloat)fontSize {
    NSString* fontPath = [[NSBundle mainBundle] pathForResource:@"Led" ofType:@"TTF"];
    return [UIFont customFontWithPath:fontPath size:fontSize];
}

+ (UIFont*)customFontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    NSString* fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:nil];
    return [UIFont customFontWithPath:fontPath size:fontSize];
}


@end
