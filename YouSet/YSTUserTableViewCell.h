//
//  YSTUserTableViewCell.h
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTUserTableViewCell : UITableViewCell

@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *photo;

@property (weak, nonatomic, readonly) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelNome;

-(void)mountWithPhoto:(BOOL) photo;


@end
