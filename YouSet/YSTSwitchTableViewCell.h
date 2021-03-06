//
//  YSTSwitchTableViewCell.h
//  YouSet
//
//  Created by Willian Pinho on 8/25/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTCreateNewTodo.h"

@class YSTCreateNewTodo;
@interface YSTSwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic) IBOutlet UISwitch *switchOfCell;
@property (weak, nonatomic) YSTToDo *auxTodo;


@end
