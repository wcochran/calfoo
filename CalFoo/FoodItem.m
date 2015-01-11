//
//  FridgeItem.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "FoodItem.h"

@implementation FoodItem

-(id)init {
    if (self = [super init]) {
        _descriptor = @"";
        _servingSize = 0.0;
        _numServings = 1.0;
        _servingUnits = @"";
        _fatGrams = _carbsGrams = _proteinGrams = _calories = 0.0;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary*)dict {
    if (self = [super init]) {
        _descriptor = [dict objectForKey:kDescriptorKey];
        _servingSize = [[dict objectForKey:kServingSizeKey] floatValue];
        _servingUnits = [dict objectForKey:kServingUnitsKey];
        _numServings = [[dict objectForKey:kNumServingsKey] floatValue];
        _fatGrams = [[dict objectForKey:kFatGramsKey] floatValue];
        _carbsGrams = [[dict objectForKey:kCarbsGramsKey] floatValue];
        _proteinGrams = [[dict objectForKey:kProteinGramsKey] floatValue];
        _calories = [[dict objectForKey:kCaloriesKey] floatValue];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _descriptor = [aDecoder decodeObjectForKey:kDescriptorKey];
        _servingSize = [aDecoder decodeFloatForKey:kServingSizeKey];
        _servingUnits = [aDecoder decodeObjectForKey:kServingUnitsKey];
        _numServings = [aDecoder decodeFloatForKey:kNumServingsKey];
        _fatGrams = [aDecoder decodeFloatForKey:kFatGramsKey];
        _carbsGrams = [aDecoder decodeFloatForKey:kCarbsGramsKey];
        _proteinGrams = [aDecoder decodeFloatForKey:kProteinGramsKey];
        _calories = [aDecoder decodeFloatForKey:kCaloriesKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_descriptor forKey:kDescriptorKey];
    [aCoder encodeFloat:_servingSize forKey:kServingSizeKey];
    [aCoder encodeObject:_servingUnits forKey:kServingUnitsKey];
    [aCoder encodeFloat:_numServings forKey:kNumServingsKey];
    [aCoder encodeFloat:_fatGrams forKey:kFatGramsKey];
    [aCoder encodeFloat:_carbsGrams forKey:kCarbsGramsKey];
    [aCoder encodeFloat:_proteinGrams forKey:kProteinGramsKey];
    [aCoder encodeFloat:_calories forKey:kCaloriesKey];
}

-(id)copyWithZone:(NSZone *)zone {
    FoodItem *clone = [[[self class] alloc] init];
    clone.descriptor = _descriptor;
    clone.servingSize = _servingSize;
    clone.servingUnits = _servingUnits;
    clone.numServings = _numServings;
    clone.fatGrams = _fatGrams;
    clone.carbsGrams = _carbsGrams;
    clone.proteinGrams = _proteinGrams;
    clone.calories = _calories;
    return clone;
}

@end
