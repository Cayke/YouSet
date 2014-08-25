//
//  YSTPickDateTableViewCell.m
//  YouSet
//
//  Created by Willian Pinho on 8/22/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTPickDateTableViewCell.h"

@implementation YSTPickDateTableViewCell

- (void)awakeFromNib
{
//    self.datePicker = [[UIDatePicker alloc] init];
//    self.datePicker.datePickerMode = UIDatePickerModeDate;
//    NSDate *date = [[NSDate alloc]init];
//    [self.datePicker setDate:date animated:NO];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createDateFormatter {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}



@end
