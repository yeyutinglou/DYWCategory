

#import <Foundation/Foundation.h>

@interface NSObject (DYWSwizzling)

+ (void)DYW_methodSwizlingWithOriginalSelector:(SEL)originalSelector
                              swizzledSelector:(SEL)swizzledSelector;

@end
