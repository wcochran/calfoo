//
//  CalSummaryViewController.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/20/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalSummaryViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableViewCell *totalCaloriesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *caloriesBurnedCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *netCaloriesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *fatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *carbsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *proteinCell;

-(void)updateSummary;

@end
