//
//  YSTMeTableViewCell.h
//  YouSet
//
//  Created by Willian Pinho on 8/13/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTToDo.h"
#import "YSTUser.h"

@interface YSTMeTableViewCell : UITableViewCell

@property (weak, nonatomic) YSTUser *userRepresentation;

@property (weak, nonatomic) IBOutlet UILabel *desciption;
@property (weak, nonatomic) IBOutlet UILabel *usersOfTask;

@property (weak, nonatomic) YSTToDo *todo;

-(void)setCellWithTodo:(YSTToDo*)todo andUserRepresentation:(YSTUser*)userRep;

@end
