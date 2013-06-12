//
//  BodyStats.m
//  CalFoo
//
//  Created by Wayne Cochran on 6/12/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "BodyStats.h"

@implementation BodyStats

#define kTimeStamp @"timestamp"
#define kWeightKey @"weight"
#define kBodyFatPercentageKey @"bodyfatpercentage"

-(id)init {
    if (self = [super init]) {
        _timeStamp = nil;
        _weight = 0.0;
        _bodyFatPercentage = 0.0;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _timeStamp = [aDecoder decodeObjectForKey:kTimeStamp];
        _weight = [aDecoder decodeFloatForKey:kWeightKey];
        _bodyFatPercentage = [aDecoder decodeFloatForKey:kBodyFatPercentageKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_timeStamp forKey:kTimeStamp];
    [aCoder encodeFloat:_weight forKey:kWeightKey];
    [aCoder encodeFloat:_bodyFatPercentage forKey:kWeightKey];
}

-(id)copyWithZone:(NSZone *)zone {
    BodyStats *clone = [[[self class] alloc] init];
    clone.weight = _weight;
    clone.bodyFatPercentage = _bodyFatPercentage;
    return clone;
}


@end
