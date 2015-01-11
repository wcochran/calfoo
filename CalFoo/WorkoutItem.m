//
//  ExerciseItem.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "WorkoutItem.h"

#define kDescriptorKey @"descriptor"
#define kCaloriesKey @"calories"
#define kNotesKey @"notes"

@implementation WorkoutItem

-(id)init {
    if (self = [super init]) {
        _descriptor = @"";
        _calories = 0.0;
        _notes = @"";
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _descriptor = [aDecoder decodeObjectForKey:kDescriptorKey];
        _calories = [aDecoder decodeFloatForKey:kCaloriesKey];
        _notes = [aDecoder decodeObjectForKey:kNotesKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_descriptor forKey:kDescriptorKey];
    [aCoder encodeFloat:_calories forKey:kCaloriesKey];
    [aCoder encodeObject:_notes forKey:kNotesKey];
}

-(id)copyWithZone:(NSZone *)zone {
    WorkoutItem *clone = [[[self class] alloc] init];
    clone.descriptor = _descriptor;
    clone.calories = _calories;
    clone.notes = _notes;
    return clone;
}

@end
