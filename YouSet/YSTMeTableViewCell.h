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
@property (weak, nonatomic) IBOutlet UILabel *idToDo;

@property (weak, nonatomic) IBOutlet UILabel *description;

-(void)setCellWithTodo:(YSTToDo*)todo;

@end
