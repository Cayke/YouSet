//
//  YSTFriendTableViewCell.m
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTFriendTableViewCell.h"

@implementation YSTFriendTableViewCell

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
    _labelContato.text = _nome;
    _labelPendent.text = [NSString stringWithFormat:@"%d pendente(s)", _numeroPendente];
    self.imageView.image = [UIImage imageNamed:@"user91.png"];
}

@end
