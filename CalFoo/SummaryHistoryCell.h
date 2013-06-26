//
//  SummaryHistoryCell.h
//  CalFoo
//
//  Created by Wayne Cochran on 6/19/13.
//  Copyright (c) 2013 Wayne Cochran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *proteinGramsLabel;
@property (weak, nonatomic) IBOutlet UILabel *macrosLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCalsLabel;
@property (weak, nonatomic) IBOutlet UILabel *burnedCalsLabel;
@property (weak, nonatomic) IBOutlet UILabel *netCalsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyStatsLabel;

@end
