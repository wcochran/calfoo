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
-(void)additem:(id)sender;
-(void)cancelAddItem:(id)sender;

@end

@implementation FridgeItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    //
    // self.fridgeIndex >= 0 => viewing/editing existing item
    // self.fridgeIndex < 0  -> adding new item
    //
    if (self.fridgeIndex >= 0) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self setTextFieldsEnabled:NO];
        CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        FoodItem *item = [appDelegate.food objectAtIndex:self.fridgeIndex];
        self.descriptionTextField.text = item.description;
        self.servingSizeTextField.text = [NSString stringWithFormat:@"%g", item.servingSize];
        self.servingUnitsTextField.text = item.servingUnits;
        self.fatTextField.text = [NSString stringWithFormat:@"%0g",item.fatGrams];
        self.carbsTextField.text = [NSString stringWithFormat:@"%g",item.carbsGrams];
        self.proteinTextField.text = [NSString stringWithFormat:@"%g",item.proteinGrams];
        self.caloriesTextField.text = [NSString stringWithFormat:@"%g",item.calories];
    } else {
        [self setTextFieldsEnabled:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:
                                                  @selector(additem:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddItem:)];
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
    
    UITextBorderStyle borderStyle = flag ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    self.descriptionTextField.borderStyle = borderStyle;
    self.servingSizeTextField.borderStyle = borderStyle;
    self.servingUnitsTextField.borderStyle = borderStyle;
    self.fatTextField.borderStyle = borderStyle;
    self.carbsTextField.borderStyle = borderStyle;
    self.proteinTextField.borderStyle = borderStyle;
    self.caloriesTextField.borderStyle = borderStyle;
}

-(void)additem:(id)sender {
    // XXX add new item
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)cancelAddItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];    
}

-(BOOL)validateAndSetFoodItem:(FoodItem*)item {
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceCharacterSet];
    NSString *errorString = nil;
    
    NSString *description = [self.descriptionTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    if ([description length] <= 0) {
        NSLog(@"description=<%@>", description);
        errorString = @"Empty Description!";
    }
    NSString *servingSize = [self.servingSizeTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    if ([servingSize length] <= 0) {
        errorString = @"Empty serving size!";
    }
    NSString *servingUnits = [self.servingUnitsTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    if ([servingUnits length] <= 0) {
        errorString = @"Empty serving units!";
    }
    NSString *fat = [self.fatTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    if ([fat length] <= 0) {
        errorString = @"No fat grams!";
    }
    NSString *carbs = [self.carbsTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    if ([carbs length] <= 0) {
        errorString = @"No carb grams!";
    }
    NSString *protein = [self.proteinTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    if ([protein length] <= 0) {
        errorString = @"No protein grams!";
    }
    NSString *calories = [self.caloriesTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    if ([calories length] <= 0) {
        NSLog(@"calories=<%@> : [%@]", calories, self.caloriesTextField.text);
        errorString = @"No calories!";
    }
    if (errorString != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete form!" message:errorString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return NO;
    }
    
    item.description = description;
    item.servingSize = [servingSize floatValue];
    item.servingUnits = servingUnits;
    item.numServings = 1.0;
    item.fatGrams = [fat floatValue];
    item.carbsGrams = [carbs floatValue];
    item.proteinGrams = [protein floatValue];
    item.calories = [calories floatValue];
    
    // XXX warn if macro grams and calories disagree?
    
    return YES;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    const BOOL wasEditing = self.isEditing;
    [super setEditing:editing animated:YES];
    [self setTextFieldsEnabled:editing];
    if (!editing && wasEditing) {
        // XXX Save edited item (if actually altered).
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
