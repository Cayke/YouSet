//
//  YSTFriendTableViewCell.m
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTFriendTableViewCell.h"
#import "YSTImage.h"

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
    _labelContato.text = _user.name;
    _labelPendent.text = [NSString stringWithFormat:NSLocalizedString(@"%d pendente(s)", nil), _user.pendentTodos];
    
    if (_viewOfImage == nil)
    {
        
        CGRect frame = CGRectMake(10, 2.5, 75, 75);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: frame];
        imageView.layer.cornerRadius = 38;
        imageView.clipsToBounds = YES;
       // imageView.layer.borderWidth = 0;
       // imageView.layer.borderColor = [[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1] CGColor];
        imageView.backgroundColor = [UIColor whiteColor];
        
        //colocar image view como property da classe
        _viewOfImage = imageView;
        
        //sombra
//        UIView *topView= [[UIView alloc] initWithFrame: frame];
//        topView.center=  CGPointMake(frame.size.width / 2, frame.size.height / 2);
//        topView.backgroundColor  =[UIColor clearColor];
//        topView.layer.shadowColor = [[UIColor blackColor] CGColor];
//        topView.layer.shadowOpacity = 0.2;
//        topView.layer.shadowRadius = 1;
//        topView.layer.shadowOffset = CGSizeMake(10, 3);
//        topView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds cornerRadius:60].CGPath;
//        topView.layer.shouldRasterize = YES;
//        topView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        
//        [topView addSubview:imageView];
//        
//        [self addSubview: topView];
        
        [self addSubview:imageView];
        
        [self setImageWithPath];
    }

    else
    {
        [self setImageWithPath];
    }   
}

-(void) setImageWithPath {
    YSTImage *image = [[YSTImage alloc]init];
    [image setImageNamed:_user.photo toUIImageView:_viewOfImage andActivivyIndicator:nil];
}

@end
