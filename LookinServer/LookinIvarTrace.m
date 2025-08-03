 

//
//  LookinIvarTrace.m
//  Lookin
//
//  Created by Li Kai on 2019/4/30.
//  https://lookin.work
//

#import "LookinIvarTrace.h"

NSString *const LookinIvarTraceRelationValue_Self = @"self";

@implementation LookinIvarTrace

#pragma mark - Equal

- (NSDictionary *)toJson {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // 如果 relation 存在，则添加到字典
    if (self.relation) {
        dict[@"relation"] = self.relation;
    }
    
    // 如果 hostClassName 存在，则添加到字典
    if (self.hostClassName) {
        dict[@"hostClassName"] = self.hostClassName;
    }
    
    // 如果 ivarName 存在，则添加到字典
    if (self.ivarName) {
        dict[@"ivarName"] = self.ivarName;
    }
    // 子节点 可能死循环 TODO
    // if (self.ivarTraces) {
    //     NSMutableArray *tracesArray = [NSMutableArray array];
    //     for (LookinIvarTrace *trace in self.ivarTraces) {
    //         [tracesArray addObject:[trace toJson]]; // 递归调用 toJson
    //     }
    //     dict[@"ivarTraces"] = tracesArray;
    // }
    
    // 返回不可变字典
    return [dict copy];
}

- (NSUInteger)hash {
    return self.hostClassName.hash ^ self.ivarName.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[LookinIvarTrace class]]) {
        return NO;
    }
    LookinIvarTrace *comparedObj = object;
    if ([self.hostClassName isEqualToString:comparedObj.hostClassName] && [self.ivarName isEqualToString:comparedObj.ivarName]) {
        return YES;
    }
    return NO;
}

#pragma mark - <NSCopying>
    
- (id)copyWithZone:(NSZone *)zone {
    LookinIvarTrace *newTrace = [[LookinIvarTrace allocWithZone:zone] init];
    newTrace.relation = self.relation;
    newTrace.hostClassName = self.hostClassName;
    newTrace.ivarName = self.ivarName;
    return newTrace;
}

#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.relation forKey:@"relation"];
    [aCoder encodeObject:self.hostClassName forKey:@"hostClassName"];
    [aCoder encodeObject:self.ivarName forKey:@"ivarName"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.relation = [aDecoder decodeObjectForKey:@"relation"];
        self.hostClassName = [aDecoder decodeObjectForKey:@"hostClassName"];
        self.ivarName = [aDecoder decodeObjectForKey:@"ivarName"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end


