//
//  CalsTodayViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/21/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "CalsTodayViewController.h"
#import "CalFooAppDelegate.h"
#import "FoodItem.h"
#import "WorkoutItem.h"
#import "TodayFoodItemViewController.h"

@interface CalsTodayViewController () <UIActionSheetDelegate, TodayFoodItemViewControllerDelegate>

-(void)foodChanged:(NSNotification*)notification;

@end

@implementation CalsTodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foodChanged:) name:kFoodChangedNotification object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)foodChanged:(NSNotification*)notification {
    if (notification.object != self) {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return section == 0 ? [appDelegate.todaysFood count] : [appDelegate.todaysExercises count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"CalsTodayFoodCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        FoodItem *item = [appDelegate.todaysFood objectAtIndex:indexPath.row];
        cell.textLabel.text = item.description;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.0f", item.calories * item.numServings];
    } else {
        static NSString *CellIdentifier = @"CalsTodayExerciseCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        WorkoutItem *item = [appDelegate.todaysExercises objectAtIndex:indexPath.row];
        cell.textLabel.text = item.description;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.0f", item.calories];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if (indexPath.section == 0) {
            [appDelegate.todaysFood removeObjectAtIndex:indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:kFoodChangedNotification object:self];
        } else {
            [appDelegate.todaysExercises removeObjectAtIndex:indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:kFoodChangedNotification object:self];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (fromIndexPath.section == 0) {
        FoodItem *item = [appDelegate.todaysFood objectAtIndex:fromIndexPath.row];
        [appDelegate.todaysFood removeObjectAtIndex:fromIndexPath.row];
        [appDelegate.todaysFood insertObject:item atIndex:toIndexPath.row];
    } else {
        WorkoutItem *item = [appDelegate.todaysExercises objectAtIndex:fromIndexPath.row];
        [appDelegate.todaysExercises removeObjectAtIndex:fromIndexPath.row];
        [appDelegate.todaysExercises insertObject:item atIndex:toIndexPath.row];
    }
    // XXX Notify everyone of change? Probably not necessary for simple reordering.
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//
// Only allow intra-section moves! We'll snap the cell back to whence it came otherwise.
//
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section != proposedDestinationIndexPath.section)
        return sourceIndexPath;
    return proposedDestinationIndexPath;
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

#define ADD_FOOD_BUTTON_INDEX 0
#define ADD_WORKOUT_BUTTON_INDEX 1
#define CANCEL_BUTTON_INDEX 2

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch(buttonIndex) {
        case ADD_FOOD_BUTTON_INDEX:
            [self performSegueWithIdentifier:@"TodayAddFoodSegue" sender:self];
            break;
        case ADD_WORKOUT_BUTTON_INDEX:
            NSLog(@"add workout..."); // XXXX
            break;
        case CANCEL_BUTTON_INDEX:
            NSLog(@"cancel...");
    }
}

- (IBAction)addCalItem:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Add Calorie Item" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Food", @"Add Workout", nil];
    [sheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TodayFoodItemDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        FoodItem *item = [appDelegate.todaysFood objectAtIndex:indexPath.row];
        TodayFoodItemViewController *foodItemViewController = (TodayFoodItemViewController*)segue.destinationViewController;
        foodItemViewController.item = item;
        foodItemViewController.addingItem = NO;
        foodItemViewController.itemDelegate = self;
    }
}

-(void)didEditFoodItem {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didAddFoodItem {
    // should not happen (happens in "adding" item)
}

-(void)didCancelAddFoodItem {
    // should not happen (happens in "adding" item)
}


@end
