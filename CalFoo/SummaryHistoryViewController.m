//
//  HistoryViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 6/17/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "SummaryHistoryViewController.h"
#import "CalFooAppDelegate.h"
#import "SummaryHistoryCell.h"

@interface HistoryItemProvider : UIActivityItemProvider
@end

@implementation HistoryItemProvider

-(id)item {
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:@"\"Date\", \"fat(g)\", \"carbs(g)\", \"protein(g)\", \"total cals\", \"burned cals\", \"weight (lbs)\", \"bodyFat\"\n"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSArray *archive = appDelegate.summaryArchive;
    for (NSUInteger i = 0; i < archive.count; i++) {
        NSMutableDictionary *summaryEntry = [archive objectAtIndex:i];
        NSDate *date = [summaryEntry objectForKey:@"date"];
        const float fatGrams = [[summaryEntry objectForKey:@"fatgrams"] floatValue];
        const float carbsGrams = [[summaryEntry objectForKey:@"carbsgrams"] floatValue];
        const float proteinGrams = [[summaryEntry objectForKey:@"proteingrams"] floatValue];
        const float totalCalories = [[summaryEntry objectForKey:@"totalcalories"] floatValue];
        const float burnedCalories = [[summaryEntry objectForKey:@"burnedcalories"] floatValue];
        const float weight = [[summaryEntry objectForKey:@"weight"] floatValue];
        const float bodyFat = [[summaryEntry objectForKey:@"bodyfatpercentage"] floatValue];
        [result appendString:[NSString stringWithFormat:@"%@, %0.5f, %0.5f, %0.5f, %0.2f, %0.2f, %0.2f, %0.2f\n",
                              [dateFormatter stringFromDate:date],
                              fatGrams, carbsGrams, proteinGrams, totalCalories, burnedCalories, weight, bodyFat]];
    }
    
    return result;
}

@end

@interface SummaryHistoryViewController ()
-(void)shareHistory:(id)sender;
@end

@implementation SummaryHistoryViewController {
    NSDateFormatter *dateFormatter;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareHistory:)];
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, shareButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shareHistory:(id)sender {
    HistoryItemProvider *historyItemProvider = [[HistoryItemProvider alloc] initWithPlaceholderItem:@"history"];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[historyItemProvider] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToFlickr, UIActivityTypeMessage, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToTwitter, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.summaryArchive count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SummaryHistoryCell";
    SummaryHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableDictionary *summaryEntry = [appDelegate.summaryArchive objectAtIndex:indexPath.row];
    
    NSDate *date = [summaryEntry objectForKey:@"date"];
    const float fatGrams = [[summaryEntry objectForKey:@"fatgrams"] floatValue];
    const float carbsGrams = [[summaryEntry objectForKey:@"carbsgrams"] floatValue];
    const float proteinGrams = [[summaryEntry objectForKey:@"proteingrams"] floatValue];
    const float totalCalories = [[summaryEntry objectForKey:@"totalcalories"] floatValue];
    const float burnedCalories = [[summaryEntry objectForKey:@"burnedcalories"] floatValue];
    const float weight = [[summaryEntry objectForKey:@"weight"] floatValue];
    const float bodyFat = [[summaryEntry objectForKey:@"bodyfatpercentage"] floatValue];
    
    const float fatCalsPerGram = 9;
    const float carbsCalsPerGram = 4;
    const float proteinCalsPerGram = 4;
    const float macroCalories = fatCalsPerGram*fatGrams + carbsCalsPerGram*carbsGrams + proteinCalsPerGram*proteinGrams;
    
    const float fatPercent = (macroCalories > 0) ? fatGrams*fatCalsPerGram/macroCalories * 100 : 0;
    const float carbsPercent = (macroCalories > 0) ? carbsGrams*carbsCalsPerGram/macroCalories * 100 : 0;
    const float proteinPercent = (macroCalories > 0) ? proteinGrams*proteinCalsPerGram/macroCalories * 100 : 0;
    
#define RINT(f) ((int)((f) + 0.5))
    
    cell.dateLabel.text = [dateFormatter stringFromDate:date];
    cell.proteinGramsLabel.text = [NSString stringWithFormat:@"%d g", RINT(proteinGrams)];
    cell.macrosLabel.text = [NSString stringWithFormat:@"%d/%d/%d", RINT(fatPercent), RINT(carbsPercent), RINT(proteinPercent)];
    cell.totalCalsLabel.text = [NSString stringWithFormat:@"%4.0f", totalCalories];
    cell.burnedCalsLabel.text = [NSString stringWithFormat:@"%4.0f", burnedCalories];
    cell.netCalsLabel.text = [NSString stringWithFormat:@"%4.0f", totalCalories - burnedCalories];
    NSString *weightStr = @"";
    NSString *bodyFatStr = @"";
    if (weight > 0.0)
        weightStr = [NSString stringWithFormat:@"%5.1f", weight];
    if (bodyFat > 0.0)
        bodyFatStr = [NSString stringWithFormat:@"%4.1f%%", bodyFat];
    cell.bodyStatsLabel.text = [NSString stringWithFormat:@"%@ %@", weightStr, bodyFatStr];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.summaryArchive removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}

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
