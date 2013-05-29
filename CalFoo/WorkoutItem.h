//
//  ExerciseItem.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkoutItem : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) float calories;
@property (nonatomic, copy) NSString *notes;

-(id)init;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)copyWithZone:(NSZone *)zone;

@end
