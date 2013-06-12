//
//  BodyStats.h
//  CalFoo
//
//  Created by Wayne Cochran on 6/12/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BodyStats : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, assign) float weight;   // lbs
@property (nonatomic, assign) float bodyFatPercentage;


-(id)init;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)copyWithZone:(NSZone *)zone;

@end
