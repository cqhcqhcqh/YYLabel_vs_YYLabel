//
//  YYTextLayout+VerticalForm.m
//  YYLabel_vs_UILabel
//
//  Created by caitou on 2020/2/26.
//  Copyright © 2020 chengqihan. All rights reserved.
//

#import "YYTextLayout+VerticalForm.h"

static NSString *const kYYTextLayoutRunDelegateUserInfoActualAdvanceWidthKey = @"kYYTextLayoutRunDelegateUserInfoActualAdvanceWidthKey";

@implementation YYTextLayout (VerticalForm)

- (NSAttributedString *)verticalFormTextAddTextRunDelegateIfNeeded {
    if (!self.container.isVerticalForm) {
        return self.text;
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:self.text];
    NSArray *lines = self.lines;
    NSUInteger startLocation = 0;
    for (NSUInteger l = 0, lMax = lines.count; l < lMax; l++) {
        YYTextLine *line = lines[l];
        if (self.truncatedLine && self.truncatedLine.index == line.index) line = self.truncatedLine;
        NSArray *lineRunRanges = line.verticalRotateRange;
        CFArrayRef runs = CTLineGetGlyphRuns(line.CTLine);
        for (NSUInteger r = 0, rMax = CFArrayGetCount(runs); r < rMax; r++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, r);
            NSUInteger glyphCount = CTRunGetGlyphCount(run);
            CGSize glyphAdvances[glyphCount];
            CTRunGetAdvances(run, CFRangeMake(0, 0), glyphAdvances);
            
            for (YYTextRunGlyphRange *oneRange in lineRunRanges[r]) {
                NSRange range = oneRange.glyphRangeInRun;
                NSUInteger rangeMax = range.location + range.length;
                YYTextRunGlyphDrawMode mode = oneRange.drawMode;
                startLocation += range.location;
                NSLog(@"%lu", (unsigned long)startLocation);
                for (NSUInteger g = range.location; g < rangeMax; g++) {
                    if (mode) {
                        CGFloat width = glyphAdvances[g].width;
                        CGFloat fontSize = line.width;
                        if (fontSize > width) {
                            YYTextRunDelegate *delegate = [YYTextRunDelegate new];
                            delegate.width = fontSize;
                            delegate.ascent = line.ascent;
                            delegate.descent = line.descent;
                            delegate.userInfo = @{kYYTextLayoutRunDelegateUserInfoActualAdvanceWidthKey: @(width)};
                            CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
                            [text yy_setRunDelegate:delegateRef range:NSMakeRange(startLocation + g, 1)];
                            if (delegate) CFRelease(delegateRef);
                        }
                    }
                }
            }
        }
    }
    return [text copy];
}

- (void)modifyRunGlyphRangeIfNeeded {
    if (!self.container.isVerticalForm) {
        return;
    }
    NSArray *lines = self.lines;
    for (NSUInteger l = 0, lMax = lines.count; l < lMax; l++) {
        YYTextLine *line = lines[l];
        if (self.truncatedLine && self.truncatedLine.index == line.index) line = self.truncatedLine;
        NSArray *lineRunRanges = line.verticalRotateRange;
        CFArrayRef runs = CTLineGetGlyphRuns(line.CTLine);
        for (NSUInteger r = 0, rMax = CFArrayGetCount(runs); r < rMax; r++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, r);
            NSUInteger glyphCount = CTRunGetGlyphCount(run);
            CGSize glyphAdvances[glyphCount];
            CTRunGetAdvances(run, CFRangeMake(0, 0), glyphAdvances);
            CFDictionaryRef runAttrs = CTRunGetAttributes(run);
            CTRunDelegateRef delegate = CFDictionaryGetValue(runAttrs, kCTRunDelegateAttributeName);
            void * ref = CTRunDelegateGetRefCon(delegate);
            YYTextRunDelegate *textRunDelegate = (__bridge YYTextRunDelegate *)(ref);
            for (YYTextRunGlyphRange *oneRange in lineRunRanges[r]) {
                NSRange range = oneRange.glyphRangeInRun;
                NSUInteger rangeMax = range.location + range.length;
                YYTextRunGlyphDrawMode mode = oneRange.drawMode;
                
                for (NSUInteger g = range.location; g < rangeMax; g++) {
                    if (mode && textRunDelegate.userInfo != nil) {
                        oneRange.actualAdvanceWidth = [textRunDelegate.userInfo[kYYTextLayoutRunDelegateUserInfoActualAdvanceWidthKey] floatValue];
                        oneRange.glyphAdvanceChanged = YES;
                    }
                }
            }
        }
    }
}

@end
