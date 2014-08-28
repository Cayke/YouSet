//
//  YSTFriendTableViewCell.h
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTUser.h"

@interface YSTFriendTableViewCell : UITableViewCell

@property (nonatomic) YSTUser *user;

@property (weak, nonatomic, readonly) UIImageView *viewOfImage;
@property (weak, nonatomic) IBOutlet UILabel *labelContato;
@property (weak, nonatomic) IBOutlet UILabel *labelPendent;

-(void) mount;
@end
