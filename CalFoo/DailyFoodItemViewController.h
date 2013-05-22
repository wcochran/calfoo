//
//  FoodItemViewController.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/22/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoodItem;

@protocol DailyFoodItemViewControllerDelegate <NSObject>

-(void)didEditFoodItem;
-(void)didAddFoodItem;
-(void)didCancelAddFoodItem;

@end

@interface DailyFoodItemViewController : UITableViewController <UITextFieldDelegate>

@property (assign, nonatomic) BOOL addingItem;
@property (strong, nonatomic) FoodItem *item;
@property (weak, nonatomic) id<DailyFoodItemViewControllerDelegate> itemDelegate;

@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITextField *totalCaloriesTextField;
@property (weak, nonatomic) IBOutlet UITextField *numServingsTextField;
@property (weak, nonatomic) IBOutlet UISlider *numServingsSlider;

- (IBAction)numServingsSliderSlid:(UISlider *)sender;
- (IBAction)numServingsEdited:(UITextField *)sender;
- (IBAction)totalCaloriesEdited:(UITextField *)sender;

@end
