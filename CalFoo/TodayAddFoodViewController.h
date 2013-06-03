//
//  FindFoodViewController.h
//  CalFoo
//
//  Created by Wayne Cochran on 5/22/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayAddFoodViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *filteredFridgeItems;

@end
