//
//  TodayWorkoutItemViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 6/3/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "TodayWorkoutItemViewController.h"
#import "WorkoutItem.h"
#import "CalFooAppDelegate.h"

@interface TodayWorkoutItemViewController ()

-(void)cancelAddItem:(id)sender;
-(void)addItem:(id)sender;
-(void)doneEditingItem:(id)sender;

@end

@implementation TodayWorkoutItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

     if (self.addingItem) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddItem:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addItem:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditingItem:)];
    }
    
    self.descriptionTextField.text = self.item.description;
    self.caloriesTextField.text = [NSString stringWithFormat:@"%0.3g", self.item.calories];
    self.notesTextView.text = self.item.notes;
}

-(void)cancelAddItem:(id)sender {
    [self.itemDelegate didCancelAddWorkoutItem:self]; // let delegate dismiss controller
}

-(void)addItem:(id)sender {
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.todaysExercises addObject:self.item];
    self.item.description = self.descriptionTextField.text;  // XXX check for empty description?
    self.item.calories = [self.caloriesTextField.text floatValue];
    self.item.notes = self.notesTextView.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTodaysExercisesChangedNotification object:self];
    [self.itemDelegate didAddWorkoutItem:self];  // let delegate dismiss controller
}

-(void)doneEditingItem:(id)sender {
    self.item.description = self.descriptionTextField.text;  // XXX check for empty description?
    self.item.calories = [self.caloriesTextField.text floatValue];
    self.item.notes = self.notesTextView.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:kTodaysExercisesChangedNotification object:self];
    [self.itemDelegate didEditWorkoutItem:self]; // let delegate dismiss controller
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


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

- (IBAction)textFieldEditingChanged:(UITextField *)sender { // unused (for now)
}

#pragma mark Text View Delegate

- (void)textViewDidChange:(UITextView *)textView {  // unused (for now)
}

@end
