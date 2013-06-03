//
//  TodayWorkoutItemViewController.h
//  CalFoo
//
//  Created by Wayne Cochran on 6/3/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkoutItem;

@interface TodayWorkoutItemViewController : UITableViewController <UITextViewDelegate>

@property (strong, nonatomic) WorkoutItem *item;
@property (assign, nonatomic) BOOL addingItem;

@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *caloriesTextField;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

- (IBAction)textFieldEditingChanged:(UITextField *)sender;

@end
