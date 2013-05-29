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

@interface CalSummaryViewController () <UIActionSheetDelegate>

-(void)foodChanged:(NSNotification*)notification;

@end

@implementation CalSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foodChanged:) name:kFoodChangedNotification object:nil];
    
    [self updateSummary];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)foodChanged:(NSNotification*)notification {
    [self updateSummary];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        // XXX Save current day here
        
        [appDelegate.todaysFood removeAllObjects];
        [appDelegate.todaysExercises removeAllObjects];
        appDelegate.today = [NSDate date];
        
        [self.tableView reloadData];  // get date changed in section header
        [[NSNotificationCenter defaultCenter] postNotificationName:kFoodChangedNotification object:self];
    }
}

- (IBAction)resetForNewDay:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Start a new Day" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear and reset" otherButtonTitles:nil];
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
    self.netCaloriesCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.0f", totalCalories - burnedCalories];
    
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:appDelegate.today];
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
