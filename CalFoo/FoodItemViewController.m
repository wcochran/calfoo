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

//
//   %0.3g format will use scientif format for values > 1000
//
/* Here's an idea from http://stackoverflow.com/questions/9628645/use-printf-to-format-floats-without-decimal-places-if-only-trailing-0s
 sprintf(s1, "%f", f3);
 s2 = strchr(s1, '.');
 i = s2 - s1;
 printf("%.*g\n", (i+2), f3);
 */

@interface FoodItemViewController ()

-(void)addFoodItem:(id)sender;
-(void)cancelAddFoodItem:(id)sender;
-(void)doneEditingFoodItem:(id)sender;

@end

@implementation FoodItemViewController {
    //
    // Storing the number of servings in the slider control is a bad idea since
    // it clamps the value to its min and max value and we want to be able to store
    // values outside this range. We use the following field to cache the latest
    // value (which should be consistent with the various textfields and sliders
    // (modulo the clamping of values in the slider).
    //
    float _numServings;
}

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
    _numServings = self.item.numServings;
    self.numServingsTextField.text = [NSString stringWithFormat:@"%9.3g", _numServings];
    self.numServingsSlider.value = _numServings;
    NSString *units = ([self.item.servingUnits length] <= 0) ? @"units" : self.item.servingUnits;
    const float numUnits = _numServings * self.item.servingSize;
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
    self.item.numServings = _numServings;
    [appDelegate.todaysFood addObject:self.item];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFoodChangedNotification object:self];
    [self.itemDelegate didAddFoodItem]; // let delegate dismiss
}

-(void)cancelAddFoodItem:(id)sender {
    [self.itemDelegate didCancelAddFoodItem];  // let delegate dismiss
}

-(void)doneEditingFoodItem:(id)sender {
    self.item.numServings = _numServings;
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
    _numServings = sender.value;
    self.numServingsTextField.text = [NSString stringWithFormat:@"%0.3g", _numServings];
    self.totalCaloriesTextField.text = [NSString stringWithFormat:@"%0.3g", _numServings * self.item.calories];
    const float units = _numServings*self.item.servingSize;
    self.numUnitsSlider.value = units;
    self.numUnitsTextField.text = [NSString stringWithFormat:@"%0.3g", units];
}


- (IBAction)numServingsEdited:(UITextField *)sender {
    _numServings = [sender.text floatValue];
   // XXX NSLog(@"numServings = %f", _numServings);
    self.numServingsSlider.value = _numServings;
    self.totalCaloriesTextField.text = [NSString stringWithFormat:@"%0.3g", _numServings * self.item.calories];
    const float units = _numServings*self.item.servingSize;
    self.numUnitsSlider.value = units;
    self.numUnitsTextField.text = [NSString stringWithFormat:@"%0.3g", units];
}

- (IBAction)totalCaloriesEdited:(UITextField *)sender {
    const float calories = [sender.text floatValue];
    // XXX NSLog(@"calories = %f", calories);
    _numServings = calories / self.item.calories; // text field disabled if calories == 0
    self.numServingsSlider.value = _numServings;
    self.numServingsTextField.text = [NSString stringWithFormat:@"%0.3g", _numServings];
    const float units = _numServings*self.item.servingSize;
    self.numUnitsSlider.value = units;
    self.numUnitsTextField.text = [NSString stringWithFormat:@"%0.3g", units];
}

- (IBAction)numUnitsSliderSlid:(UISlider *)sender { // slider disabled if servingSize == 0
    const float units = sender.value;
    _numServings = units / self.item.servingSize; // text field disable if servingSize == 0
    self.numServingsSlider.value = _numServings;
    self.numServingsTextField.text = [NSString stringWithFormat:@"%0.3g", _numServings];
    self.totalCaloriesTextField.text = [NSString stringWithFormat:@"%0.3g", _numServings * self.item.calories];
    self.numUnitsTextField.text = [NSString stringWithFormat:@"%0.3g", units];
}

- (IBAction)numUnitsEdited:(UITextField *)sender { // text field disabled if servingSize == 0
    const float units = [sender.text floatValue];
    _numServings = units / self.item.servingSize; // slider disabled if servingSize == 0
    self.numServingsSlider.value = _numServings;
    self.numServingsTextField.text = [NSString stringWithFormat:@"%0.3g", _numServings];
    self.totalCaloriesTextField.text = [NSString stringWithFormat:@"%0.3g", _numServings * self.item.calories];
    self.numUnitsSlider.value = units;
}

@end
