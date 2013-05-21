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

-(void)setTextFieldsEnabled:(BOOL)flag;

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
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setTextFieldsEnabled:NO];
    
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (0 <= self.fridgeIndex && self.fridgeIndex < [appDelegate.food count]) {
        FoodItem *item = [appDelegate.food objectAtIndex:self.fridgeIndex];
        self.descriptionTextField.text = item.description;
        self.servingSizeTextField.text = [NSString stringWithFormat:@"%g", item.servingSize];
        self.servingUnitsTextField.text = item.servingUnits;
        self.fatTextField.text = [NSString stringWithFormat:@"%0g",item.fatGrams];
        self.carbsTextField.text = [NSString stringWithFormat:@"%g",item.carbsGrams];
        self.proteinTextField.text = [NSString stringWithFormat:@"%g",item.proteinGrams];
        self.caloriesTextField.text = [NSString stringWithFormat:@"%g",item.calories];
    }
}

-(void)setTextFieldsEnabled:(BOOL)flag {
    self.descriptionTextField.enabled = flag;
    self.servingSizeTextField.enabled = flag;
    self.servingUnitsTextField.enabled = flag;
    self.fatTextField.enabled = flag;
    self.carbsTextField.enabled = flag;
    self.proteinTextField.enabled = flag;
    self.caloriesTextField.enabled = flag;
    
    UITextBorderStyle borderStyile = flag ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    self.descriptionTextField.borderStyle = borderStyile;
    self.servingSizeTextField.borderStyle = borderStyile;
    self.servingUnitsTextField.borderStyle = borderStyile;
    self.fatTextField.borderStyle = borderStyile;
    self.carbsTextField.borderStyle = borderStyile;
    self.proteinTextField.borderStyle = borderStyile;
    self.caloriesTextField.borderStyle = borderStyile;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing) {
        [self setTextFieldsEnabled:YES];
    } else {
        [self setTextFieldsEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// STATIC TABLE VIEW

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end
