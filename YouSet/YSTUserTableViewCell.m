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

-(void)mountWithPhoto:(BOOL)photo
{
 
    _labelNome.text = _name;
    
    if (photo) {
        self.imageView.image = [UIImage imageNamed:@"user91.png"];
        self.imageView.hidden = NO;
    }
    else
    {
        self.imageView.hidden = YES;
    }
//
//    if (photo) {
//    //botar a foto redondinha
//    CGRect frame = CGRectMake(0, 0, 50, 50);
//    
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
//    imageView.layer.cornerRadius = 60;
//    imageView.clipsToBounds = YES;
//    imageView.layer.borderWidth = 1;
//    imageView.layer.borderColor = [[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1] CGColor];
//    imageView.backgroundColor = [UIColor whiteColor];
//    
//    //colocar image view como propriedade da classe
//   // _viewOfImage = imageView;
//    
//    //sombra
//    UIView *topView= [[UIView alloc] initWithFrame: frame];
//    topView.center=  CGPointMake(frame.size.width / 2, frame.size.height / 2);
//    topView.backgroundColor  =[UIColor clearColor];
//    topView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    topView.layer.shadowOpacity = 0.2;
//    topView.layer.shadowRadius = 1;
//    topView.layer.shadowOffset = CGSizeMake(0, 3);
//    topView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds cornerRadius:60].CGPath;
//    topView.layer.shouldRasterize = YES;
//    topView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    
//    [topView addSubview:imageView];
//    
//
//    [self addSubview: topView];
//    [self addSubview:_viewOfImage]
//    
//
//    self.imageView.image = [UIImage imageNamed:@"user91.png"];
//        self.imageView.hidden = NO;
//    }
//    else
//    {
//        self.imageView.hidden = YES;
//    }
}
@end
