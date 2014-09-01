//
//  YSTMeTableViewCell.h
//  YouSet
//
//  Created by Willian Pinho on 8/13/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTToDo.h"

@interface YSTMeTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *usersOfTask;

@property (weak, nonatomic) YSTToDo *todo;

-(void)setCellWithTodo:(YSTToDo*)todo;
- (CGFloat)cellHeightForContentWidth:(CGFloat)contentWidth;
@end
