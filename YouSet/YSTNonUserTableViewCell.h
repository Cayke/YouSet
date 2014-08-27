//
//  YSTNonUserTableViewCell
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTNonUserTableViewCell : UITableViewCell

@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *photo;

@property (weak, nonatomic) IBOutlet UILabel *labelNome;

-(void)mount;


@end
