//
//  YSTEditableTableViewCell.m
//  YouSet
//
//  Created by Willian Pinho on 8/22/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTEditableTableViewCell.h"

@implementation YSTEditableTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.contentTF.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
