//
//  DebugOption.m
//  YYLabel_vs_UILabel
//
//  Created by chengqihan on 2020/2/19.
//  Copyright © 2020 chengqihan. All rights reserved.
//

#import "DebugOption.h"
@import VSText;

@implementation DebugOption

+ (void)setDebug:(BOOL)debug {
    YYTextDebugOption *debugOptions = [YYTextDebugOption new];
    if (debug) {
        debugOptions.baselineColor = [UIColor redColor];
        debugOptions.CTFrameBorderColor = [UIColor brownColor];
        debugOptions.CTLineFillColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:0.180];
        debugOptions.CGGlyphBorderColor = [UIColor purpleColor];
    } else {
        [debugOptions clear];
    }
    [YYTextDebugOption setSharedDebugOption:debugOptions];

}

@end
