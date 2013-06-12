//
//  BodyStatsViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 6/12/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "BodyStatsViewController.h"
#import "CalFooAppDelegate.h"
#import "BodyStats.h"

@interface BodyStatsViewController () <UIAlertViewDelegate>

-(void)doneEditing:(id)sender;
-(void)cancelEditing:(id)sender;

@end

@implementation BodyStatsViewController {
    BOOL _edited;
    float _weight;
    float _bodyfat;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEditing:)];
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    float weight = 0.0;
    float bodyfat = 0.0;
    if (appDelegate.todaysBodyStats != nil) {
        weight = appDelegate.todaysBodyStats.weight;
        bodyfat = appDelegate.todaysBodyStats.bodyFatPercentage;
    }
    self.weightTextField.text = [NSString stringWithFormat:@"%0.3g", weight];
    self.bodyFatTextField.text = [NSString stringWithFormat:@"%0.3g", bodyfat];
    
    _edited = NO;
}

-(void)saveBodyStats {
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.todaysBodyStats == nil)
        appDelegate.todaysBodyStats = [[BodyStats alloc] init];
    appDelegate.todaysBodyStats.timeStamp = [NSDate date];
    appDelegate.todaysBodyStats.weight = _weight;
    appDelegate.todaysBodyStats.bodyFatPercentage = _bodyfat;
    [[NSNotificationCenter defaultCenter] postNotificationName:kBodyStatsChangedNotification object:self];    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self saveBodyStats];
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

-(void)doneEditing:(id)sender {
    if (_edited) {
        _weight = [self.weightTextField.text floatValue];
        _bodyfat = [self.bodyFatTextField.text floatValue];
        if ((_weight !=  0.0 && (_weight < 50.0 || _weight > 500.0)) ||
            (_bodyfat != 0.0 && (_bodyfat < 1.0 || _bodyfat > 80.0))) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Bogus Body Stats!"
                                  message:@"Proceed with strange values (use 0 to ignore value)!?"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        [self saveBodyStats];
    }
    [self dismissViewControllerAnimated:YES completion:^{}]; 
}

-(void)cancelEditing:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
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

- (IBAction)editingChangedTextField:(UITextField *)sender {
    _edited = YES;
}

@end
