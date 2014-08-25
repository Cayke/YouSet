//
//  YSTInviteTableViewCell.m
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTInviteTableViewCell.h"

@implementation YSTInviteTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) mount
{
    _labelPhone.text = _phone;
    _labelType.text = _type;
}

@end
