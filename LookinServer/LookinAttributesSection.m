 

//
//  LookinAttributesSection.m
//  Lookin
//
//  Created by Li Kai on 2019/3/2.
//  https://lookin.work
//



#import "LookinAttributesSection.h"
#import "LookinAttribute.h"

#import "NSArray+Lookin.h"

@implementation LookinAttributesSection

#pragma mark - <NSCopying>
- (NSDictionary *)toJson {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // if (self.identifier) {
    //     dict[@"identifier"] = self.identifier;
    // }

    
    if (self.attributes) {
        NSMutableArray *attrArray = [NSMutableArray array];
        for (LookinAttribute *attr in self.attributes) {
            NSDictionary * attrJson = [attr toJson];
            if(!IsEmptyDict(attrJson)){
                [attrArray addObject:[attr toJson]]; // 递归调用 toJson
            }
        }
        if(!IsEmptyArray(attrArray)){
            dict[@"attrArray"] = attrArray;
        }
    }
    
    return [dict copy];
}
- (id)copyWithZone:(NSZone *)zone {
    LookinAttributesSection *newSection = [[LookinAttributesSection allocWithZone:zone] init];
    newSection.identifier = self.identifier;
    newSection.attributes = [self.attributes lookin_map:^id(NSUInteger idx, LookinAttribute *value) {
        return value.copy;
    }];
    return newSection;
}

#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.attributes forKey:@"attributes"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.attributes = [aDecoder decodeObjectForKey:@"attributes"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (BOOL)isUserCustom {
    return [self.identifier isEqualToString:LookinAttrSec_UserCustom];
}

@end


