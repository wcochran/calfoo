//
//  FindFoodViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/22/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "DailyAddFoodViewController.h"
#import "CalFooAppDelegate.h"
#import "FoodItem.h"
#import "DailyFoodItemViewController.h"

@interface DailyAddFoodViewController () <DailyFoodItemViewControllerDelegate>

@property (strong, nonatomic) FoodItem *foodItem;

-(void)cancelAdd:(id)sender;

@end

@implementation DailyAddFoodViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.food count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DailyAddFoodCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    FoodItem *item = [appDelegate.food objectAtIndex:indexPath.row];
    cell.textLabel.text = item.description;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"srv=%0.2g %@, %0.0f/%0.0f/%0.0f %0.0f Cals", item.servingSize, item.servingUnits, item.fatGrams, item.carbsGrams, item.proteinGrams, item.calories];
    
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
    if ([segue.identifier isEqualToString:@"TodayAddFoodDetailSegue"]) {
        UINavigationController *navController = (UINavigationController*) segue.destinationViewController;
        DailyFoodItemViewController *foodItemViewController = (DailyFoodItemViewController*) navController.topViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        FoodItem *item = [appDelegate.food objectAtIndex:indexPath.row];
        foodItemViewController.addingItem = YES;
        foodItemViewController.item = self.foodItem = [item copy];
        foodItemViewController.itemDelegate = self;
    }
}

-(void)didEditFoodItem {
    // should not happen
}

-(void)didAddFoodItem {
    // XXX add item
    // XXX inform everyone
   [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)didCancelAddFoodItem {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{}];
}


@end
