

#import <UIKit/UIKit.h>

@interface UILabel (DYWExtension)


-(CGFloat)adaptLabelHeight;

-(CGFloat)adaptLabelWidth;

/** 富文本 */
- (void)richTextWithFont:(UIFont *)font range:(NSRange)range color:(UIColor *)color;

@end
