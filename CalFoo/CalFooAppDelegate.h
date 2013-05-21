//
//  CalFooAppDelegate.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodItem.h"
#import "ExerciseItem.h"

@interface CalFooAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//
// Local database of foods and excersize routines.
//
@property (nonatomic, retain) NSMutableArray *food;
@property (nonatomic, retain) NSMutableArray *exercises;

//
// Today's food consumed and exercise performed.
//
@property (nonatomic, retain) NSDate *today;
@property (nonatomic, retain) NSMutableArray *todaysFood;
@property (nonatomic, retain) NSMutableArray *todaysExercises;

@end
