

#import <Foundation/Foundation.h>

@interface NSObject (DYWModel)

///数组转模型
+ (NSArray *_Nullable)modelWithJson:(id _Nullable )json;

///字典转模型
+ (instancetype _Nullable )modelWithDic:(NSDictionary *_Nullable)dic;



@end
