//
//  YSTMeTableViewCell.m
//  YouSet
//
//  Created by Willian Pinho on 8/13/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTMeTableViewCell.h"

@interface YSTMeTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end


@implementation YSTMeTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    _description.textAlignment = NSTextAlignmentJustified;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithTodo:(YSTToDo *)todo{
    _todo = todo;
    self.description.text = todo.todo;
    
    NSString *s = @"";
    BOOL todoOfAnotherUser = NO;
    for (YSTAssignee *a in todo.assignee) {
        if (a.nameOfUser) {
            s = [s stringByAppendingFormat:@"%@. ",a.nameOfUser];
            todoOfAnotherUser = YES;
        }
    }
    
    _usersOfTask.hidden = NO;
    _usersOfTask.text = [NSString stringWithFormat:@"To %@",s];
    
    if (!todoOfAnotherUser) {
        _usersOfTask.hidden = YES;
        
        if (todo.idCreatedBy != [YSTUser sharedUser].ID) {
            if (![todo.createdByName isEqualToString:@""]) {
                _usersOfTask.hidden = NO;
                _usersOfTask.text = [NSString stringWithFormat:@"From %@",todo.createdByName];
            }
        }
    }
}

- (CGFloat)cellHeightForContentWidth:(CGFloat)contentWidth {
    return [self.textLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
}


@end
