

#import "UILabel+DYWExtension.h"

@implementation UILabel (DYWExtension)

- (CGFloat)adaptLabelHeight
{
    
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil];
    return ceilf(rect.size.height);
}

- (CGFloat)adaptLabelWidth {
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.width) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil];
    return ceil(rect.size.width);
}


- (void)richTextWithFont:(UIFont *)font range:(NSRange)range color:(UIColor *)color {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSFontAttributeName value:font range:range];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = str;
}

@end
