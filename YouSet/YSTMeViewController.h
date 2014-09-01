//
//  YSTMeViewController.h
//  YouSet
//
//  Created by Willian Pinho on 8/8/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTMeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *meTableView;

@property (strong,nonatomic) NSArray *toDoMeArray;

@property (nonatomic) UIRefreshControl *refreshControl;

// array of competed/incompleted todos
@property (nonatomic, readonly) NSArray *arrayOfCompletedTodos;
@property (nonatomic, readonly) NSArray *arrayOfIncompleteTodos;
@property (nonatomic, readonly) NSArray *arrayOfInProgressTodos;

@property (nonatomic, readonly) NSInteger nCompleted;
@property (nonatomic, readonly) NSInteger nInProgress;
@property (nonatomic, readonly) NSInteger nIncompleted;

@end
