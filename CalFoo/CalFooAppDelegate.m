//
//  CalFooAppDelegate.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "CalFooAppDelegate.h"

#define kFoodFileName @"food.archive"
#define kExercisesFileName @"exercises.archive"
#define kTodayFileName @"today.archive"

#define kFoodArrayKey @"foodarray"
#define kExerciseArrayKey @"exercisearray"
#define kTodaysDateKey @"todaysdate"
#define kTodaysFoodKey @"todaysfood"
#define kTodaysExerciseKey @"todaysexercise"

@interface CalFooAppDelegate ()

-(NSString*)pathForFileName:(NSString*)fname;

@end

@implementation CalFooAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //
    // Initialize food data.
    //
    NSString *foodFileName = [self pathForFileName:kFoodFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:foodFileName]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:foodFileName];
        NSKeyedUnarchiver *aDecoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *a = [aDecoder decodeObjectForKey:kFoodArrayKey];
        self.food = [a mutableCopy];
        [aDecoder finishDecoding];
    } else {
        NSDictionary *oatmeal = @{kDescriptionKey : @"Oatmeal (Old Fashioned)",
                                  kServingSizeKey : @(0.5), kServingUnitsKey : @"cups", kNumServingsKey : @(1.0),
                                  kFatGramsKey : @(3.0), kCarbsGramsKey : @(27.0), kProteinGramsKey : @(5), kCaloriesKey: @(150)};
        FoodItem *oatmealItem = [[FoodItem alloc] initWithDictionary:oatmeal];
        self.food = [[NSMutableArray alloc] initWithArray:@[oatmealItem]];
    }
    
    //
    // Initialize exercise data.
    //
    NSString *exercisesFileName = [self pathForFileName:kExercisesFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:exercisesFileName]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:exercisesFileName];
        NSKeyedUnarchiver *aDecoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *a = [aDecoder decodeObjectForKey:kExerciseArrayKey];
        self.exercises = [a mutableCopy];
        [aDecoder finishDecoding];
    } else {
        self.exercises = [[NSMutableArray alloc] init];
    }
    
    //
    // Initialize today's calorie data.
    //
    NSString *todayFileName = [self pathForFileName:kTodayFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:todayFileName]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:todayFileName];
        NSKeyedUnarchiver *aDecoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.today = [aDecoder decodeObjectForKey:kTodaysDateKey];
        NSArray *a = [aDecoder decodeObjectForKey:kTodaysFoodKey];
        self.todaysFood = [a mutableCopy];
        a = [aDecoder decodeObjectForKey:kTodaysExerciseKey];
        self.todaysExercises = [a mutableCopy];
    } else {
        self.today = [NSDate date];
        self.todaysFood = [[NSMutableArray alloc] init];
        self.todaysExercises = [[NSMutableArray alloc] init];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //
    // Save food data in sandbox.
    //
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *aCoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [aCoder encodeObject:self.food forKey:kFoodArrayKey];
    [aCoder finishEncoding];
    NSString *foodFileName = [self pathForFileName:kFoodFileName];
    [data writeToFile:foodFileName atomically:YES];
    
    //
    // Save exercise data in sandbox.
    //
    data = [[NSMutableData alloc] init];
    aCoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [aCoder encodeObject:self.exercises forKey:kExerciseArrayKey];
    [aCoder finishEncoding];
    NSString *exercisesFileName = [self pathForFileName:kExercisesFileName];
    [data writeToFile:exercisesFileName atomically:YES];
    
    //
    // Save today's calories data in sandbox.
    //
    data = [[NSMutableData alloc] init];
    aCoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [aCoder encodeObject:self.today forKey:kTodaysDateKey];
    [aCoder encodeObject:self.todaysFood forKey:kTodaysFoodKey];
    [aCoder encodeObject:self.todaysExercises forKey:kTodaysExerciseKey];
    [aCoder finishEncoding];
    NSString *todayFileName = [self pathForFileName:kTodayFileName];
    [data writeToFile:todayFileName atomically:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSString*)pathForFileName:(NSString*)fname {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *pathName = [docDir stringByAppendingPathComponent:fname];
    return pathName;
}

@end
