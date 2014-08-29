//
//  YSTEditableTableViewCell.h
//  YouSet
//
//  Created by Willian Pinho on 8/22/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTCreateNewTodo.h"

@class YSTCreateNewTodo;

@interface YSTEditableTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *contentTF;


@property (weak, nonatomic) YSTToDo *auxTodo;

@end
