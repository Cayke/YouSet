//
//  YSTCreateNewTodo.h
//  YouSet
//
//  Created by Riheldo Melo Santos on 12/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTToDo.h"
#import "YSTFriendToDosViewController.h"

#import "YSTEditableTableViewCell.h"
#import "YSTToDoStore.h"
#import "YSTPickDateTableViewCell.h"
#import "YSTSwitchTableViewCell.h"

@class YSTEditableTableViewCell;

@interface YSTCreateNewTodo : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSArray *sectionOfRequiredFields;
@property (nonatomic) NSArray *sectionOfOptionalFields;
@property (nonatomic) NSArray *arrayOfSections;

@property (nonatomic) YSTUser *userToDelegateTask;

@property (weak, nonatomic) YSTFriendToDosViewController *friendToDoVC;

// tableview
@property (weak, nonatomic) IBOutlet UITableView *toDoTableView;
@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic) YSTToDo *auxTodo;

@property (nonatomic, weak) YSTEditableTableViewCell *edtTVCell;
@end
