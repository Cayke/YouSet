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
    
    self.title.text = NSLocalizedString(@"Público", nil);
    self.accessoryView = self.switchOfCell;
    [self.switchOfCell addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) switchChanged:(id)sender {
    BOOL isPublic = [sender isOn];
    if (isPublic == YES) {
        self.auxTodo.isPublic = YES;
    } else {
        self.auxTodo.isPublic = NO;
    }
}


@end