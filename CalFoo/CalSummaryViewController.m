//
//  CalSummaryViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "CalSummaryViewController.h"
#import "CalFooAppDelegate.h"
#import "FoodItem.h"
#import "WorkoutItem.h"

static NSString *getDateString(NSDate *date) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    return formattedDateString;
}

@interface CalSummaryViewController () <UIActionSheetDelegate>

-(void)foodChanged:(NSNotification*)notification;
-(void)workoutChanged:(NSNotification*)notification;

-(void)saveToday;
-(void)clearToday;

@end

@implementation CalSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foodChanged:) name:kFoodChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workoutChanged:) name:kTodaysExercisesChangedNotification object:nil];
    
    [self updateSummary];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)foodChanged:(NSNotification*)notification {
    [self updateSummary];
}

-(void)workoutChanged:(NSNotification*)notification {
    [self updateSummary];
}

-(BOOL)todayInfoIsEmpty {
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.todaysFood count] == 0 && [appDelegate.todaysExercises count] == 0;
}

-(void)saveToday {
    NSLog(@"Save data here!");
}

-(void)clearToday {
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.todaysFood removeAllObjects];
    [appDelegate.todaysExercises removeAllObjects];
    appDelegate.today = [NSDate date];
    
    [self.tableView reloadData];  // get date changed in section header
    [[NSNotificationCenter defaultCenter] postNotificationName:kFoodChangedNotification object:self];    
}

#define RESET_SHEET_TAG 1
#define SAVE_SHEET_TAG 2

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    const int tag = actionSheet.tag;
    if (tag == RESET_SHEET_TAG) {
    
        if (buttonIndex == 0) { // reset
            if (![self todayInfoIsEmpty]) { // ask to save first
                CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSString *formattedDateString = getDateString(appDelegate.today);
                NSString *title = [NSString stringWithFormat:@"Save %@ info?", formattedDateString];
                UIActionSheet *saveSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Save" otherButtonTitles:@"Discard", nil];
                saveSheet.tag = SAVE_SHEET_TAG;
                [saveSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
            } else {
                [self clearToday];
            }
        } // else cancel
        
    } else if (tag == SAVE_SHEET_TAG) {
        
        if (buttonIndex == 0) { // save and reset
            
                        
            [self clearToday];
        } else if (buttonIndex == 1) { // discard and reset
            
            [self clearToday];
        } // else cancel
    }
}

- (IBAction)resetForNewDay:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Start a new day" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear and reset" otherButtonTitles:nil];
    sheet.tag = RESET_SHEET_TAG;
    [sheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

-(void)updateSummary {
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    float fatGrams = 0;
    float carbsGrams = 0;
    float proteinGrams = 0;
    float totalCalories = 0;
    for (FoodItem *item in appDelegate.todaysFood) {
        fatGrams += item.fatGrams*item.numServings;
        carbsGrams += item.carbsGrams*item.numServings;
        proteinGrams += item.proteinGrams*item.numServings;
        totalCalories += item.calories*item.numServings;
    }
    
    float burnedCalories = 0;
    for (WorkoutItem *item in appDelegate.todaysExercises) {
        burnedCalories += item.calories;
    }
    
    self.totalCaloriesCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.0f", totalCalories];
    self.caloriesBurnedCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.0f", burnedCalories];
    const float netCalories = totalCalories - burnedCalories;
    self.netCaloriesCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.0f", netCalories];
    
    self.fatCell.textLabel.text = [NSString stringWithFormat:@"Fat (%0.0fg)", fatGrams];
    self.carbsCell.textLabel.text = [NSString stringWithFormat:@"Carbs (%0.0fg)", carbsGrams];
    self.proteinCell.textLabel.text = [NSString stringWithFormat:@"Protein (%0.0fg)", proteinGrams];
    
    const float fatCalsPerGram = 9;
    const float carbsCalsPerGram = 4;
    const float proteinCalsPerGram = 4;
    const float macroCalories = fatCalsPerGram*fatGrams + carbsCalsPerGram*carbsGrams + proteinCalsPerGram*proteinGrams;
    
    const float fatPercent = (macroCalories > 0) ? fatGrams*fatCalsPerGram/macroCalories * 100 : 0;
    const float carbsPercent = (macroCalories > 0) ? carbsGrams*carbsCalsPerGram/macroCalories * 100 : 0;
    const float proteinPercent = (macroCalories > 0) ? proteinGrams*proteinCalsPerGram/macroCalories * 100 : 0;
    
    self.fatCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.0f%%", fatPercent];
    self.carbsCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.0f%%", carbsPercent];
    self.proteinCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.0f%%", proteinPercent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Table view data source  (STATIC CELLS in IB)

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *formattedDateString = getDateString(appDelegate.today);
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//    NSString *formattedDateString = [dateFormatter stringFromDate:appDelegate.today];
    return formattedDateString;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
