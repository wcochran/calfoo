//
//  ExerciseItem.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "ExerciseItem.h"

#define kDescriptionKey @"description"
#define kCaloriesKey @"calories"
#define kNotesKey @"notes"

@implementation ExerciseItem

-(id)init {
    if (self = [super init]) {
        _description = @"";
        _calories = 0.0;
        _notes = @"";
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _description = [aDecoder decodeObjectForKey:kDescriptionKey];
        _calories = [aDecoder decodeFloatForKey:kCaloriesKey];
        _notes = [aDecoder decodeObjectForKey:kNotesKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_description forKey:kDescriptionKey];
    [aCoder encodeFloat:_calories forKey:kCaloriesKey];
    [aCoder encodeObject:_notes forKey:kNotesKey];
}

-(id)copyWithZone:(NSZone *)zone {
    ExerciseItem *clone = [[[self class] alloc] init];
    clone.description = _description;
    clone.calories = _calories;
    clone.notes = _notes;
    return clone;
}

@end
