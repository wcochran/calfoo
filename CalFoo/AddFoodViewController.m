//
//  FindFoodViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/22/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "AddFoodViewController.h"
#import "CalFooAppDelegate.h"
#import "FoodItem.h"
#import "FoodItemViewController.h"

@interface AddFoodViewController () <FoodItemViewControllerDelegate>

@property (strong, nonatomic) FoodItem *foodItem;

-(void)cancelAdd:(id)sender;

@end

@implementation AddFoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.filteredFridgeItems = [NSMutableArray arrayWithCapacity:[appDelegate.fridge count]];

    //
    // Note : there is no need to register as observer since this controller is loaded modally
    // and can not modify the fridge.
    //
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;?
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAdd:)];
}

//-(void)fridgeChanged:(NSNotification*)notification { // controller loaded modally, fridge not modified
//    [self.tableView reloadData];
//}

-(void)cancelAdd:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredFridgeItems count];
    }
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.fridge count];
}

#define TABLE_VIEW_CELL_TAG 1
#define SEARCH_RESULTS_TABLE_VIEW_CELL_TAG 2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DailyAddFoodCell";
    // note: use 'self.tableview' here since that is what the cell is registered with in the storyboard
    // See http://stackoverflow.com/questions/14207142/search-bar-in-tableviewcontroller-ios-6
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    FoodItem *item;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        item = [self.filteredFridgeItems objectAtIndex:indexPath.row];
        cell.tag = SEARCH_RESULTS_TABLE_VIEW_CELL_TAG;
    } else {
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        item = [appDelegate.fridge objectAtIndex:indexPath.row];
        cell.tag = TABLE_VIEW_CELL_TAG;
    }
   
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
        FoodItemViewController *foodItemViewController = (FoodItemViewController*) navController.topViewController;
        int tag = [sender tag];
        FoodItem *item;
        if (tag == SEARCH_RESULTS_TABLE_VIEW_CELL_TAG) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            item = [self.filteredFridgeItems objectAtIndex:indexPath.row];
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            item = [appDelegate.fridge objectAtIndex:indexPath.row];
        }
        foodItemViewController.addingItem = YES;
        foodItemViewController.item = self.foodItem = [item copy]; // DEEP COPY OF ITEM!
        foodItemViewController.itemDelegate = self;
    }
}

#pragma mark - Food Item Delegate Methid

-(void)didEditFoodItem {
    // should not happen
}

-(void)didAddFoodItem {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}

-(void)didCancelAddFoodItem {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Content Filtering

-(void)filterContentForSearchText:(NSString*)searchText {
    [self.filteredFridgeItems removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.description contains[c] %@",searchText];
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.filteredFridgeItems = [NSMutableArray arrayWithArray:[appDelegate.fridge filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString];
    return YES;
}

@end
