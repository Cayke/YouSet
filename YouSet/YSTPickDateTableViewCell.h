//
//  YSTPickDateTableViewCell.h
//  YouSet
//
//  Created by Willian Pinho on 8/22/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTPickDateTableViewCell : UITableViewCell
@property (nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end
