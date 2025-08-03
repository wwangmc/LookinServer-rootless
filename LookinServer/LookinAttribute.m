 

//
//  LookinAttribute.m
//  qmuidemo
//
//  Created by Li Kai on 2018/11/17.
//  Copyright © 2018 QMUI Team. All rights reserved.
//



#import "LookinAttribute.h"
#import "LookinDisplayItem.h"

@implementation LookinAttribute

#pragma mark - <NSCopying>
- (NSDictionary *)toJson {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // if (self.identifier) {
    //     dict[@"identifier"] = self.identifier;
    // }
    if (self.displayTitle) {
        dict[@"displayTitle"] = self.displayTitle;
    }
    // if (self.attrType) {
    //     dict[@"attrType"] = self.attrType;
    // }
    // if (self.value) {
    //     dict[@"value"] = self.value;
    // }
    // if (self.extraValue) {
    //     dict[@"extraValue"] = self.extraValue;
    // }
    [self setRealValue:dict];
    if (self.customSetterID) {
        dict[@"customSetterID"] = self.customSetterID;
    }
    // if (self.ivarTraces) {
    //     NSMutableArray *tracesArray = [NSMutableArray array];
    //     for (LookinIvarTrace *trace in self.ivarTraces) {
    //         [tracesArray addObject:[trace toJson]]; // 递归调用 toJson
    //     }
    //     dict[@"ivarTraces"] = tracesArray;
    // }
    
    return [dict copy];
}
- (void)setRealValue:(NSMutableDictionary *)dict {
    // TODO 部分类型未适配
    switch (self.attrType) {
        case LookinAttrTypeEnumString:
        case LookinAttrTypeNSString: {
            if (self.value) {
                NSString *newValue = self.value;
                dict[@"value"] = newValue;
            }
            if (self.extraValue) {
                NSString *newValue = self.extraValue;
                dict[@"extraValue"] = newValue;
            }
            return;
        }
        case LookinAttrTypeBOOL: 
        case LookinAttrTypeDouble: {
            if (self.value) {
                NSNumber *newValue = self.value;
                dict[@"value"] = newValue;
            }
            if (self.extraValue) {
                NSNumber *newValue = self.extraValue;
                dict[@"extraValue"] = newValue;
            }
            return;
        }      
        default:
            // NSLog(@"***unMatch:%s",self.attrType);
            return;
    }
}
- (id)copyWithZone:(NSZone *)zone {
    LookinAttribute *newAttr = [[LookinAttribute allocWithZone:zone] init];
    newAttr.identifier = self.identifier;
    newAttr.displayTitle = self.displayTitle;
    newAttr.value = self.value;
    newAttr.attrType = self.attrType;
    newAttr.extraValue = self.extraValue;
    newAttr.customSetterID = self.customSetterID;
    return newAttr;
}

#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.displayTitle forKey:@"displayTitle"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeInteger:self.attrType forKey:@"attrType"];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.extraValue forKey:@"extraValue"];
    [aCoder encodeObject:self.customSetterID forKey:@"customSetterID"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.displayTitle = [aDecoder decodeObjectForKey:@"displayTitle"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.attrType = [aDecoder decodeIntegerForKey:@"attrType"];
        self.value = [aDecoder decodeObjectForKey:@"value"];
        self.extraValue = [aDecoder decodeObjectForKey:@"extraValue"];
        self.customSetterID = [aDecoder decodeObjectForKey:@"customSetterID"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (BOOL)isUserCustom {
    return [self.identifier isEqualToString:LookinAttr_UserCustom];
}

@end


