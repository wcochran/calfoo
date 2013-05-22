//
//  FoodItemViewController.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/22/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyFoodItemViewController : UITableViewController

@property (assign, nonatomic) NSInteger foodIndex; // -1 => new daily food item

@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITextField *totalCaloriesTextField;
@property (weak, nonatomic) IBOutlet UITextField *numServingsTextField;
@property (weak, nonatomic) IBOutlet UISlider *numServingsSlider;

@end
