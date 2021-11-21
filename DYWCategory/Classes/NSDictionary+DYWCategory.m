

#import "NSDictionary+DYWCategory.h"
#import <objc/message.h>
@implementation NSDictionary (DYWCategory)

+ (NSDictionary *)removeTheSymbolWith:(NSData *)data
{
    NSString *tmpStr  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    tmpStr = [tmpStr stringByRemovingPercentEncoding];
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (tmpStr == nil || tmpStr.length == 0) {
        return nil;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[tmpStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    return json;
}


+ (NSDictionary *)dicFromModel:(NSObject *)object
{
    NSMutableDictionary *mutaDic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            if ([name isEqualToString:@"ID"] || [name isEqualToString:@"Id"]) {
                name = @"id";
            }
            [mutaDic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [mutaDic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
        } else {
            //model
            [mutaDic setObject:[self dicFromModel:value] forKey:name];
        }
    }
    
    return [mutaDic copy];
}




//将可能存在model数组转化为普通数组
+ (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[self dicFromModel:object]];
            }
        }
        
        return [array copy];
        
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromModel:object] forKey:key];
            }
        }
        
        return [dic copy];
    }
    
    return [NSNull null];
}


@end
