//
//  TodayWorkoutItemViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 6/3/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "TodayWorkoutItemViewController.h"

@interface TodayWorkoutItemViewController ()

-(void)cancelAddItem:(id)sender;

@end

@implementation TodayWorkoutItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.addingItem) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddItem:)];
        // XXX
    } else {
        
    }
}

-(void)cancelAddItem:(id)sender {
    // XXX
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

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
}

#pragma mark Text View Delegate

- (void)textViewDidChange:(UITextView *)textView {
}

@end
