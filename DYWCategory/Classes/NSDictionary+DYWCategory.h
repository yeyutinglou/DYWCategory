

#import <Foundation/Foundation.h>

@interface NSDictionary (DYWCategory)


+ (NSDictionary *)removeTheSymbolWith:(NSData *)data;


/**
 字典转模型

 @param object 模型
 @return 字典
 */
+ (NSDictionary *)dicFromModel:(NSObject *)object;

@end
