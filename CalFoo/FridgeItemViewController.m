//
//  FridgeItemViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/21/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "FridgeItemViewController.h"
#import "CalFooAppDelegate.h"
#import "FoodItem.h"

@interface FridgeItemViewController ()

@end

@implementation FridgeItemViewController

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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (0 <= self.fridgeIndex && self.fridgeIndex < [appDelegate.food count]) {
        FoodItem *item = [appDelegate.food objectAtIndex:self.fridgeIndex];
        self.descriptionTextField.text = item.description;
        self.servingSizeTextField.text = [NSString stringWithFormat:@"%0.3f", item.servingSize];
        // XXXX
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// STATIC TABLE VIEW


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
