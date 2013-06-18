//
//  HistoryViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 6/17/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "SummaryHistoryViewController.h"
#import "CalFooAppDelegate.h"

@interface CellData : NSObject
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) float fatPercent;
@property (nonatomic, assign) float carbsPercent;
@property (nonatomic, assign) float proteinPercent;
@property (nonatomic, assign) float calories;
@property (nonatomic, assign) float weight;
@property (nonatomic, assign) float bodyFat;
@end

@implementation CellData
@end

@interface SummaryHistoryViewController ()

@end

@implementation SummaryHistoryViewController {
    NSMutableArray *cellInfo;
}

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
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *firstSummaryEntry = [appDelegate.summaryArchive objectAtIndex:0];
    NSDate *firstDay = [firstSummaryEntry objectForKey:@"date"];
    NSMutableDictionary *lastSummaryEntry = [appDelegate.summaryArchive lastObject];
    NSDate *lastDay = [lastSummaryEntry objectForKey:@"date"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //
    // From Listing 10  Getting the Sunday in the current week:
    // http://developer.apple.com/library/ios/#documentation/cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html
    //
    NSDateComponents *firstWeekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:firstDay];
    NSDateComponents *componentsToSubstract = [[NSDateComponents alloc] init];
    [componentsToSubstract setDay:0 - [firstWeekdayComponents weekday] + 1]; // sunday = 1
    NSDate *firstSunday = [gregorian dateByAddingComponents:componentsToSubstract toDate:firstDay options:0];
    
    //
    // Listing 13 Days between two dates, as the number of midnights between
    // http://developer.apple.com/library/ios/#documentation/cocoa/Conceptual/DatesAndTimes/Articles/dtCalendricalCalculations.html
    //
    NSInteger startSunday = [gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:firstSunday];
    NSInteger startDay = [gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:firstDay];
    NSInteger endDay = [gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:lastDay];
    
    const int numDays = endDay - startSunday + 1;
    cellInfo = [[NSMutableArray alloc] initWithCapacity:numDays];
    
    // XXX

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSMutableDictionary *lastSummaryEntry = [appDelegate.summaryArchive lastObject];
//    NSDate *lastDate = [lastSummaryEntry objectForKey:@"date"];
//    const NSInteger lastDay = [gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:lastDate];
//    const NSInteger numweeks = (lastDay - startSunday + 1)/7;
//    return numweeks;
    return 1; // XXX
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.summaryArchive count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
