//
//  YYTextLayout+VerticalForm.h
//  YYLabel_vs_UILabel
//
//  Created by caitou on 2020/2/26.
//  Copyright © 2020 chengqihan. All rights reserved.
//

@import VSText;

NS_ASSUME_NONNULL_BEGIN

@interface YYTextLayout (VerticalForm)

- (NSAttributedString *)verticalFormTextAddTextRunDelegateIfNeeded;
- (void)modifyRunGlyphRangeIfNeeded;

@end

NS_ASSUME_NONNULL_END
