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

@interface FridgeItemViewController () <UIAlertViewDelegate>

-(void)setTextFieldsEnabled:(BOOL)flag;
-(void)additem:(id)sender;
-(void)cancelAddItem:(id)sender;

@end

@implementation FridgeItemViewController {
    FoodItem *_foodItem;
}

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
        _foodItem = [appDelegate.fridge objectAtIndex:self.fridgeIndex];
        self.descriptionTextField.text = _foodItem.description;
        self.servingSizeTextField.text = [NSString stringWithFormat:@"%g", _foodItem.servingSize];
        self.servingUnitsTextField.text = _foodItem.servingUnits;
        self.fatTextField.text = [NSString stringWithFormat:@"%0g",_foodItem.fatGrams];
        self.carbsTextField.text = [NSString stringWithFormat:@"%g",_foodItem.carbsGrams];
        self.proteinTextField.text = [NSString stringWithFormat:@"%g",_foodItem.proteinGrams];
        self.caloriesTextField.text = [NSString stringWithFormat:@"%g",_foodItem.calories];
    } else {
        [self setTextFieldsEnabled:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:
                                                  @selector(additem:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddItem:)];
        _foodItem = nil;
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

//
// _foodItem has been validated and needs to be added.
//
-(void)addValidatedItem {
    //
    // Add item to global fridge stored in app delegate.
    //
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.fridge addObject:_foodItem];
    
    //
    // Post a notification that the fridge has been changed.
    //
    [[NSNotificationCenter defaultCenter] postNotificationName:kFridgeChangedNotification object:self];
    
    //
    // Dismiss view controller -- our work is done here.
    //
    [self dismissViewControllerAnimated:YES completion:^{}];
}


//
// Invoke from alert spwaned by suspicious calories / macro count values (see addItem: below).
//
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"button index = %d", buttonIndex); // XXX
    if (buttonIndex > 0) { // OK
        [self addValidatedItem];
    }
}

-(void)additem:(id)sender {
    //
    // Harvest info from form data.
    //
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceCharacterSet];
    NSString *description = [self.descriptionTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    NSString *servingSize = [self.servingSizeTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    NSString *servingUnits = [self.servingUnitsTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    NSString *fat = [self.fatTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    NSString *carbs = [self.carbsTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    NSString *protein = [self.proteinTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    NSString *calories = [self.caloriesTextField.text stringByTrimmingCharactersInSet:whiteSpace];
    
    //
    // A little form validation.
    //
    if ([description length] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Description" message:@"Enter a description please." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    //
    // Create new food item for fridge.
    //
    _foodItem = [[FoodItem alloc] init];
    _foodItem.description = ([description length] > 0) ? description : @"<New Item>";
    _foodItem.servingSize = [servingSize floatValue];
    _foodItem.servingUnits = ([servingSize length] > 0) ? servingUnits : @"units";
    _foodItem.numServings = 1.0;
    _foodItem.fatGrams = [fat floatValue];
    _foodItem.carbsGrams = [carbs floatValue];
    _foodItem.proteinGrams = [protein floatValue];
    _foodItem.calories = [calories floatValue];
    
    
    //
    // Check for suspicious calories / macro count values
    // -- we allow the user to override.
    //
    const float fatCalsPerGram = 9;
    const float carbsCalsPerGram = 4;
    const float proteinCalsPerGram = 4;
    const float macroCalories = fatCalsPerGram*_foodItem.fatGrams + carbsCalsPerGram*_foodItem.carbsGrams + proteinCalsPerGram*_foodItem.proteinGrams;
    const float maxMacroCaloriesError = 0.15;
    if (macroCalories < _foodItem.calories*(1 - maxMacroCaloriesError) || macroCalories > _foodItem.calories*(1 + maxMacroCaloriesError)) {
        NSString *msg = [NSString stringWithFormat:@"Calories from macros disagree with calorie count by more than %0.0f%%!", maxMacroCaloriesError*100];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suspicious Calories" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    [self addValidatedItem];
}


-(void)cancelAddItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];    
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
