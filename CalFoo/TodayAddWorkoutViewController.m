//
//  TodayAddWorkoutViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 6/4/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "TodayAddWorkoutViewController.h"
#import "TodayWorkoutItemViewController.h"
#import "CalFooAppDelegate.h"
#import "WorkoutItem.h"

@interface TodayAddWorkoutViewController () <TodayWorkoutItemViewControllerDelegate>
-(void)cancelAdd:(id)sender;
@end

@implementation TodayAddWorkoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAdd:)];
}

-(void)cancelAdd:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didAddWorkoutItem:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];    
}

-(void)didCancelAddWorkoutItem:(id)sender {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{}];
}

-(void)didEditWorkoutItem:(id)sender {
    // should not happen !
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
    static NSString *CellIdentifier = @"DailyAddWorkoutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    WorkoutItem *item = [appDelegate.exercises objectAtIndex:indexPath.row];
    cell.textLabel.text = item.description;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
     return NO;
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
    if ([segue.identifier isEqualToString:@"TodayAddWorkoutDetailSegue"]) {
        UINavigationController *navController = (UINavigationController*) segue.destinationViewController;
        TodayWorkoutItemViewController *workoutItemViewController = (TodayWorkoutItemViewController*) navController.topViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        WorkoutItem *item = [appDelegate.exercises objectAtIndex:indexPath.row];
        workoutItemViewController.addingItem = YES;
        workoutItemViewController.item = [item copy]; // DEEP COPY
        workoutItemViewController.itemDelegate = self;
    }
}

@end
