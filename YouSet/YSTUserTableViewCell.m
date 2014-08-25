//
//  YSTUserTableViewCell.m
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTUserTableViewCell.h"

@implementation YSTUserTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)mount
{
 
    _labelNome.text = _name;
    
    self.imageView.image = [UIImage imageNamed:@"user91.png"];
}
@end
