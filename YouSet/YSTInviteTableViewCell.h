//
//  YSTInviteTableViewCell.h
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTInviteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelType;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;

@property (nonatomic) NSString *type;
@property (nonatomic) NSString *phone;

-(void) mount;
@end
