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
#import "ExerciseItem.h"

@interface CalsTodayViewController ()

@end

@implementation CalsTodayViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
        ExerciseItem *item = [appDelegate.todaysExercises objectAtIndex:indexPath.row];
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
            // XXX Notify everyone of change
        } else {
            [appDelegate.todaysExercises removeObjectAtIndex:indexPath.row];
            // XXX Notify everyone of change
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
        ExerciseItem *item = [appDelegate.todaysExercises objectAtIndex:fromIndexPath.row];
        [appDelegate.todaysExercises removeObjectAtIndex:fromIndexPath.row];
        [appDelegate.todaysExercises insertObject:item atIndex:toIndexPath.row];
    }
    // XXX Notify everyone of change?
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

@end
