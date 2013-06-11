//
//  CalFooAppDelegate.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodItem.h"
#import "WorkoutItem.h"

#define kFridgeChangedNotification @"FridgeChangedNotification"
#define kFoodChangedNotification @"FoodChangedNotification"
#define kExercisesChangedNotification @"kExercisesChangedNotification"
#define kTodaysExercisesChangedNotification @"kTodaysExercisesChangedNotification"

@interface CalFooAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//
// Local database of foods and excersize routines.
//
@property (nonatomic, strong) NSMutableArray *fridge;
@property (nonatomic, strong) NSMutableArray *exercises;

//
// Today's food consumed and exercise performed.
//
@property (nonatomic, strong) NSDate *today;
@property (nonatomic, strong) NSMutableArray *todaysFood;
@property (nonatomic, strong) NSMutableArray *todaysExercises;

-(void)archiveToday;

@end
