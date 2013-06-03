//
//  FoodItemViewController.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/22/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodItem;

@protocol TodayFoodItemViewControllerDelegate <NSObject>

-(void)didEditFoodItem;
-(void)didAddFoodItem;
-(void)didCancelAddFoodItem;

@end

@interface TodayFoodItemViewController : UITableViewController <UITextFieldDelegate>

@property (assign, nonatomic) BOOL addingItem;
@property (strong, nonatomic) FoodItem *item;
@property (weak, nonatomic) id<TodayFoodItemViewControllerDelegate> itemDelegate;

@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITextField *totalCaloriesTextField;
@property (weak, nonatomic) IBOutlet UITextField *numServingsTextField;
@property (weak, nonatomic) IBOutlet UISlider *numServingsSlider;
@property (weak, nonatomic) IBOutlet UITextField *numUnitsTextField;
@property (weak, nonatomic) IBOutlet UISlider *numUnitsSlider;
@property (weak, nonatomic) IBOutlet UILabel *unitsLabel;

- (IBAction)numServingsSliderSlid:(UISlider *)sender;
- (IBAction)numServingsEdited:(UITextField *)sender;
- (IBAction)totalCaloriesEdited:(UITextField *)sender;
- (IBAction)numUnitsSliderSlid:(UISlider *)sender;
- (IBAction)numUnitsEdited:(UITextField *)sender;

@end
