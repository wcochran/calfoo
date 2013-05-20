//
//  FridgeItem.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDescriptionKey @"description"
#define kServingSizeKey @"servingsize"
#define kServingUnitsKey @"servingunits"
#define kNumServingsKey @"numservings"
#define kFatGramsKey @"fatgrams"
#define kCarbsGramsKey @"carbsgrams"
#define kProteinGramsKey @"proteingrams"
#define kCaloriesKey @"calories"

@interface FoodItem : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString *description;
@property (nonatomic, assign) float servingSize;
@property (nonatomic, copy) NSString *servingUnits;
@property (nonatomic, assign) float numServings;
@property (nonatomic, assign) float fatGrams;
@property (nonatomic, assign) float carbsGrams;
@property (nonatomic, assign) float proteinGrams;
@property (nonatomic, assign) float calories;

-(id)init;
-(id)initWithDictionary:(NSDictionary*)dict;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)copyWithZone:(NSZone *)zone;

@end
