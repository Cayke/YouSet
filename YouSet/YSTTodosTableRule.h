//
//  YSTTodosTableRule.h
//  YouSet
//
//  Created by Riheldo Melo Santos on 03/09/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSTMeTableViewCell.h"
#import "YSTConnection.h"
#import "YSTUser.h"
#import "YSTMeTableViewCell.h"

@interface YSTTodosTableRule : NSObject
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) YSTUser *todosFromUser;

@property (nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSArray *todosArray;

@property (nonatomic) UIRefreshControl *refreshControl;

// array of competed/incompleted todos
@property (nonatomic, readonly) NSArray *arrayOfCompletedTodos;
@property (nonatomic, readonly) NSArray *arrayOfIncompleteTodos;
@property (nonatomic, readonly) NSArray *arrayOfInProgressTodos;

@property (nonatomic, readonly) NSInteger nCompleted;
@property (nonatomic, readonly) NSInteger nInProgress;
@property (nonatomic, readonly) NSInteger nIncompleted;

-(id)initWithTable:(UITableView*)tableView andUser:(YSTUser*)user;

-(void)loadTable;

@end
