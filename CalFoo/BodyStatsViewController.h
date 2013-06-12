//
//  BodyStatsViewController.h
//  CalFoo
//
//  Created by Wayne Cochran on 6/12/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyStatsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *bodyFatTextField;

- (IBAction)editingChangedTextField:(UITextField *)sender;
@end
