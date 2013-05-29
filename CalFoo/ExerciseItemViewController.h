//
//  ExerciseItemViewController.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/29/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkoutItem;


@interface ExerciseItemViewController : UITableViewController <UITextViewDelegate>

@property (assign, nonatomic) NSInteger exercisesIndex; // -1 => adding item

@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *caloriesTextField;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

- (IBAction)editingChangedForTextField:(UITextField*)sender;

@end
