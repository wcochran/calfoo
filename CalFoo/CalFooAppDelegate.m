//
//  CalFooAppDelegate.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "CalFooAppDelegate.h"
//#import <sqlite3.h>

#define kFoodFileName @"food.archive"
#define kExercisesFileName @"exercises.archive"
#define kTodayFileName @"today.archive"

#define kSummaryArchive @"summaryarchive.plist"

#define kFoodArrayKey @"foodarray"
#define kExerciseArrayKey @"exercisearray"
#define kTodaysDateKey @"todaysdate"
#define kTodaysFoodKey @"todaysfood"
#define kTodaysExerciseKey @"todaysexercise"
#define kBodyStatsKey @"bodyStatsKey"

@interface CalFooAppDelegate ()

-(NSString*)pathForFileName:(NSString*)fname;

@end

@implementation CalFooAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //
    // XXX
    // http://www.raywenderlich.com/6015/beginning-icloud-in-ios-5-tutorial-part-1
    //
//    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
//    if (ubiq) {
//        NSLog(@"iCloud access at %@", ubiq);
//        // TODO: Load data from iCloud
//    } else {
//        NSLog(@"No iCloud access");
//    }
    
    //
    // Initialize food data.
    //
    NSString *foodFileName = [self pathForFileName:kFoodFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:foodFileName]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:foodFileName];
        NSKeyedUnarchiver *aDecoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *a = [aDecoder decodeObjectForKey:kFoodArrayKey];
        self.fridge = [a mutableCopy];
        [aDecoder finishDecoding];
    } else {
        NSDictionary *oatmeal = @{kDescriptorKey : @"Oatmeal (Old Fashioned)",
                                  kServingSizeKey : @(0.5), kServingUnitsKey : @"cups", kNumServingsKey : @(1.0),
                                  kFatGramsKey : @(3.0), kCarbsGramsKey : @(27.0), kProteinGramsKey : @(5), kCaloriesKey: @(150)};
        FoodItem *oatmealItem = [[FoodItem alloc] initWithDictionary:oatmeal];
        self.fridge = [[NSMutableArray alloc] initWithArray:@[oatmealItem]];
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
        self.todaysBodyStats = [aDecoder decodeObjectForKey:kBodyStatsKey];
    } else {
        self.today = [NSDate date];
        self.todaysFood = [[NSMutableArray alloc] init];
        self.todaysExercises = [[NSMutableArray alloc] init];
        self.todaysBodyStats = nil;
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
    [aCoder encodeObject:self.fridge forKey:kFoodArrayKey];
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
    // Save today's calories, exorcises, and body stat data in sandbox.
    //
    data = [[NSMutableData alloc] init];
    aCoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [aCoder encodeObject:self.today forKey:kTodaysDateKey];
    [aCoder encodeObject:self.todaysFood forKey:kTodaysFoodKey];
    [aCoder encodeObject:self.todaysExercises forKey:kTodaysExerciseKey];
    [aCoder encodeObject:self.todaysBodyStats forKey:kBodyStatsKey];
    [aCoder finishEncoding];
    NSString *todayFileName = [self pathForFileName:kTodayFileName];
    [data writeToFile:todayFileName atomically:YES];
    
    //
    // Save summary archive as plist in sandbox (read lazily).
    //
    NSString *summaryArchivePath = [self pathForFileName:kSummaryArchive];
    [self.summaryArchive writeToFile:summaryArchivePath atomically:YES];
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

-(void)postFridgeChangedNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFridgeChangedNotification object:self];
}

-(NSMutableArray*)summaryArchive {
    if (_summaryArchive == nil) {
        NSString *path = [self pathForFileName:kSummaryArchive];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSArray *array = [NSArray arrayWithContentsOfFile:path];
            _summaryArchive = [[NSMutableArray alloc] initWithArray:array];
        } else {
            _summaryArchive = [[NSMutableArray alloc] init];
        }
    }
    return _summaryArchive;
}

-(void)archiveToday {
    float fatGrams = 0;
    float carbsGrams = 0;
    float proteinGrams = 0;
    float totalCalories = 0;
    for (FoodItem *item in self.todaysFood) {
        fatGrams += item.fatGrams*item.numServings;
        carbsGrams += item.carbsGrams*item.numServings;
        proteinGrams += item.proteinGrams*item.numServings;
        totalCalories += item.calories*item.numServings;
    }
 
    float burnedCalories = 0;
    for (WorkoutItem *item in self.todaysExercises) {
        burnedCalories += item.calories;
    }
    
    NSMutableDictionary *entry = [[NSMutableDictionary alloc] init];
    [entry setObject:self.today forKey:@"date"];
    [entry setObject:[NSNumber numberWithFloat:fatGrams] forKey:@"fatgrams"];
    [entry setObject:[NSNumber numberWithFloat:carbsGrams] forKey:@"carbsgrams"];
    [entry setObject:[NSNumber numberWithFloat:proteinGrams] forKey:@"proteingrams"];
    [entry setObject:[NSNumber numberWithFloat:totalCalories] forKey:@"totalcalories"];
    [entry setObject:[NSNumber numberWithFloat:burnedCalories] forKey:@"burnedcalories"];
    float weight = 0.0;
    float bodyFat = 0.0;
    if (self.todaysBodyStats) {
        weight = self.todaysBodyStats.weight;
        bodyFat = self.todaysBodyStats.bodyFatPercentage;
    }
    [entry setObject:[NSNumber numberWithFloat:weight] forKey:@"weight"];
    [entry setObject:[NSNumber numberWithFloat:bodyFat] forKey:@"bodyfatpercentage"];
    
    [self.summaryArchive addObject:entry];
}


@end
