//
//  ExerciseItemViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/29/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "WorkoutItemViewController.h"
#import "CalFooAppDelegate.h"
#import "WorkoutItem.h"

#define DESCRIPTION_TAG 1  // set in IB
#define CALORIES_TAG 2
#define NOTES_TAG 3

@interface WorkoutItemViewController ()

-(void)additem:(id)sender;
-(void)cancelAddItem:(id)sender;
-(void)setTextEditingEnabled:(BOOL)flag;

@end

@implementation WorkoutItemViewController {
    WorkoutItem *_exerciseItem;
    int _exerciseItemDirtyBits;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.exercisesIndex >= 0) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        _exerciseItem = [appDelegate.exercises objectAtIndex:self.exercisesIndex];
        self.descriptionTextField.text = _exerciseItem.descriptor;
        self.caloriesTextField.text = [NSString stringWithFormat:@"%g", _exerciseItem.calories];
        self.notesTextView.text = _exerciseItem.notes;
        [self setTextEditingEnabled:NO];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:
                                                  @selector(additem:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddItem:)];
        [self setTextEditingEnabled:YES];
        _exerciseItem = nil;
    }
    
    _exerciseItemDirtyBits = 0;
    
}

-(void)setTextEditingEnabled:(BOOL)flag {
    self.descriptionTextField.enabled = flag;
    self.caloriesTextField.enabled = flag;
    self.notesTextView.editable = flag;
    
    const UITextBorderStyle borderStyle = flag ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    self.descriptionTextField.borderStyle = borderStyle;
    self.caloriesTextField.borderStyle = borderStyle;
}

-(void)additem:(id)sender {
    NSString *description = self.descriptionTextField.text;
    
    if ([description length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Description" message:@"Enter a description please." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    if (_exerciseItem == nil)
        _exerciseItem = [[WorkoutItem alloc] init];
    _exerciseItem.descriptor = description;
    _exerciseItem.calories = [self.caloriesTextField.text floatValue];
    _exerciseItem.notes = self.notesTextView.text;
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.exercises addObject:_exerciseItem];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kExercisesChangedNotification object:self];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)cancelAddItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    if (self.isEditing && !editing && _exerciseItemDirtyBits != 0) { // user touched "done" (finished editing)
        if ((_exerciseItemDirtyBits & (1 << DESCRIPTION_TAG)) != 0)
            _exerciseItem.descriptor = self.descriptionTextField.text;
        if ((_exerciseItemDirtyBits & (1 << CALORIES_TAG)) != 0)
            _exerciseItem.calories = [self.caloriesTextField.text floatValue];
        if ((_exerciseItemDirtyBits & (1 << NOTES_TAG)) != 0)
            _exerciseItem.notes = self.notesTextView.text;
        
        _exerciseItemDirtyBits = 0;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kExercisesChangedNotification object:self];
    }
    
    [super setEditing:editing animated:YES];
    [self setTextEditingEnabled:editing];
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

- (IBAction)editingChangedForTextField:(UITextField*)sender {
    _exerciseItemDirtyBits |= (1 << sender.tag);
}

#pragma mark Text View Delegate

- (void)textViewDidChange:(UITextView *)textView {
    _exerciseItemDirtyBits |= (1 << textView.tag);
}

@end
