//
//  YSTSwitchTableViewCell.m
//  YouSet
//
//  Created by Willian Pinho on 8/25/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTSwitchTableViewCell.h"


@implementation YSTSwitchTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.title.text = @"Privacy";
    self.switchOfCell = 0;
    self.accessoryView = self.switchOfCell;
    [self.switchOfCell setOn:NO animated:NO];
    [self.switchOfCell addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) switchChanged:(id)sender {
    self.switchOfCell = sender;
    if (self.switchOfCell.on) {
        self.auxTodo.privacy = 1;
    } else {
        self.auxTodo.privacy = 0;
    }
}
@end
