

#import "NSObject+DYWPropertyLog.h"

@implementation NSObject (DYWPropertyLog)


+ (void)resolveDic:(NSDictionary *)dic
{
    //拼接属性字符串
    NSMutableString *strM = [NSMutableString string];
    //遍历字典,把所以key取出,生成对应的属性代码
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        //类型
//        NSString *type;
//        if ([obj isKindOfClass:NSString.class]) {
//            type = @"NSString";
//        } else if ([obj isKindOfClass:NSClassFromString(@"NSArray")]) {
//            type = @"NSArray";
//        }else if ([obj isKindOfClass:NSClassFromString(@"NSNumber")]) {
//            type = @"int";
//        } else if ([obj isKindOfClass:NSClassFromString(@"NSDictionary")]) {
//            type = @"NSDictionary";
//        }
        
        //属性字符串
        NSString *str;
        if ([obj isKindOfClass:NSString.class]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        } else if ([obj isKindOfClass:NSNumber.class]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
        } else if ([obj isKindOfClass:NSDictionary.class]) {
            [self resolveDic:obj];
        } else if ([obj isKindOfClass:NSArray.class]) {
            NSArray *arr = obj;
            if (arr.count && [arr[0] isKindOfClass:NSDictionary.class]) {
                [self resolveDic:arr[0]];
            }
        } else {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) unknown %@;",key];
        }
        
        //生成属性字符串,自动换行
        [strM appendFormat:@"\n%@\n",str];
        
    }];
    
    NSLog(@"%@",strM);
    
}

@end
