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

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithTodo:(YSTToDo *)todo{
//    self.idToDo.text = [NSString stringWithFormat:@"%d",todo.ID];
    self.description.text = todo.todo;
}

- (CGFloat)cellHeightForContentWidth:(CGFloat)contentWidth {
    return [self.textLabel sizeThatFits:CGSizeMake(contentWidth, CGFLOAT_MAX)].height;
}




@end
