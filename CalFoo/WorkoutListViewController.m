//
//  WorkoutListViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/29/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "WorkoutListViewController.h"
#import "CalFooAppDelegate.h"
#import "ExerciseItem.h"
#import "ExerciseItemViewController.h"

@interface WorkoutListViewController ()

-(void)exerciseChanged:(NSNotification*)notification;

@end

@implementation WorkoutListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exerciseChanged:) name:kExercisesChangedNotification object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)exerciseChanged:(NSNotification*)notification {
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.exercises count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WorkoutListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    ExerciseItem *item = [appDelegate.exercises objectAtIndex:indexPath.row];
    cell.textLabel.text = item.description;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.exercises removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:kExercisesChangedNotification object:self];
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    ExerciseItem *item  = [appDelegate.exercises objectAtIndex:fromIndexPath.row];
    [appDelegate.exercises removeObjectAtIndex:fromIndexPath.row];
    [appDelegate.exercises insertObject:item atIndex:toIndexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kExercisesChangedNotification object:self];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ExerciseItemDetailSegue"]) {
        ExerciseItemViewController *viewController = (ExerciseItemViewController *)segue.destinationViewController;
        viewController.exercisesIndex = [self.tableView indexPathForCell:sender].row;
    } else if ([segue.identifier isEqualToString:@"ExerciseAddItemSegue"]) {
        UINavigationController *navController = (UINavigationController*)segue.destinationViewController;
        ExerciseItemViewController *viewController = (ExerciseItemViewController *)navController.topViewController;
        viewController.exercisesIndex = -1;
    }
}

@end
