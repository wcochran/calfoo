//
//  FridgeItemViewController.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/21/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FridgeItemViewController : UITableViewController

@property (assign, nonatomic) NSInteger fridgeIndex; // -1 => adding new item

@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *servingSizeTextField;
@property (weak, nonatomic) IBOutlet UITextField *servingUnitsTextField;
@property (weak, nonatomic) IBOutlet UITextField *fatTextField;
@property (weak, nonatomic) IBOutlet UITextField *carbsTextField;
@property (weak, nonatomic) IBOutlet UITextField *proteinTextField;
@property (weak, nonatomic) IBOutlet UITextField *caloriesTextField;

@end
