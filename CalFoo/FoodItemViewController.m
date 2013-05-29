//
//  FoodItemViewController.m
//  CalFoo
//
//  Created by Wayne Cochran on 5/22/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import "FoodItemViewController.h"
#import "FoodItem.h"
#import "CalFooAppDelegate.h"

@interface FoodItemViewController ()

-(void)addFoodItem:(id)sender;
-(void)cancelAddFoodItem:(id)sender;
-(void)doneEditingFoodItem:(id)sender;

@end

@implementation FoodItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.addingItem) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addFoodItem:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddFoodItem:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditingFoodItem:)];
    }
    
    self.descriptionCell.textLabel.text = self.item.description;
    self.descriptionCell.detailTextLabel.text = [NSString stringWithFormat:@"srv=%0.2g %@, %0.0f/%0.0f/%0.0f %0.0f Cals",
                                                 self.item.servingSize, self.item.servingUnits,
                                                 self.item.fatGrams, self.item.carbsGrams, self.item.proteinGrams, self.item.calories];
    self.totalCaloriesTextField.text = [NSString stringWithFormat:@"%0.3g", self.item.numServings * self.item.calories];
    if (self.item.calories <= 0) {
        self.totalCaloriesTextField.enabled = NO;
    }
    self.numServingsTextField.text = [NSString stringWithFormat:@"%0.3g", self.item.numServings];
    self.numServingsSlider.value = self.item.numServings;
    NSString *units = ([self.item.servingUnits length] <= 0) ? @"units" : self.item.servingUnits;
    const float numUnits = self.item.numServings * self.item.servingSize;
    self.unitsLabel.text = units;
    self.numUnitsTextField.text = [NSString stringWithFormat:@"%0.3g", numUnits];
    self.numUnitsSlider.value = numUnits;
    if (self.item.servingSize <= 0) {
        self.numUnitsTextField.enabled = NO;
        self.numUnitsSlider.enabled = NO;
    }
    
}

-(void)addFoodItem:(id)sender {
    CalFooAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.item.numServings = self.numServingsSlider.value;
    [appDelegate.todaysFood addObject:self.item];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFoodChangedNotification object:self];
    [self.itemDelegate didAddFoodItem]; // let delegate dismiss
}

-(void)cancelAddFoodItem:(id)sender {
    [self.itemDelegate didCancelAddFoodItem];  // let delegate dismiss
}

-(void)doneEditingFoodItem:(id)sender {
    self.item.numServings = self.numServingsSlider.value;
    [[NSNotificationCenter defaultCenter] postNotificationName:kFoodChangedNotification object:self];
    [self.itemDelegate didEditFoodItem];  // let delegate dismiss
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

- (IBAction)numServingsSliderSlid:(UISlider *)sender {
    const float servings = sender.value;
    self.numServingsTextField.text = [NSString stringWithFormat:@"%0.3g", servings];
    self.totalCaloriesTextField.text = [NSString stringWithFormat:@"%0.3g", servings * self.item.calories];
    const float units = servings*self.item.servingSize;
    self.numUnitsSlider.value = units;
    self.numUnitsTextField.text = [NSString stringWithFormat:@"%0.3g", units];
}


- (IBAction)numServingsEdited:(UITextField *)sender {
    const float servings = [sender.text floatValue];
    // XXX NSLog(@"numServings = %f", servings);
    self.numServingsSlider.value = servings;
    self.totalCaloriesTextField.text = [NSString stringWithFormat:@"%0.3g", servings * self.item.calories];
    const float units = servings*self.item.servingSize;
    self.numUnitsSlider.value = units;
    self.numUnitsTextField.text = [NSString stringWithFormat:@"%0.3g", units];
}

- (IBAction)totalCaloriesEdited:(UITextField *)sender {
    const float calories = [sender.text floatValue];
    // XXX NSLog(@"calories = %f", calories);
    const float servings = calories / self.item.calories; // text field disabled if calories == 0
    self.numServingsSlider.value = servings;
    self.numServingsTextField.text = [NSString stringWithFormat:@"%0.3g", servings];
    const float units = servings*self.item.servingSize;
    self.numUnitsSlider.value = units;
    self.numUnitsTextField.text = [NSString stringWithFormat:@"%0.3g", units];
}

- (IBAction)numUnitsSliderSlid:(UISlider *)sender { // slider disabled if servingSize == 0
    const float units = sender.value;
    const float servings = units / self.item.servingSize; // text field disable if servingSize == 0
    self.numServingsSlider.value = servings;
    self.numServingsTextField.text = [NSString stringWithFormat:@"%0.3g", servings];
    self.totalCaloriesTextField.text = [NSString stringWithFormat:@"%0.3g", servings * self.item.calories];
    self.numUnitsTextField.text = [NSString stringWithFormat:@"%0.3g", units];
}

- (IBAction)numUnitsEdited:(UITextField *)sender { // text field disabled if servingSize == 0
    const float units = [sender.text floatValue];
    const float servings = units / self.item.servingSize; // slider disabled if servingSize == 0
    self.numServingsSlider.value = servings;
    self.numServingsTextField.text = [NSString stringWithFormat:@"%0.3g", servings];
    self.totalCaloriesTextField.text = [NSString stringWithFormat:@"%0.3g", servings * self.item.calories];
    self.numUnitsSlider.value = units;
}

@end
