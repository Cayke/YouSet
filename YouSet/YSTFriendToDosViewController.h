//
//  YSTFriendToDosViewController.h
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTUser.h"
#import "YSTFriendsViewController.h"

@interface YSTFriendToDosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) YSTUser *user ;
@property (nonatomic) NSArray *arrayToDos;
@property (nonatomic) BOOL reloadView;

@property (weak, nonatomic) YSTFriendsViewController *friendsVC;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarItemSeguir;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarItemMais;

@property (weak, nonatomic, readonly) UIImageView *viewOfImage;


// arrays para mostragem de todos deitos e nao feitos e em progresso
@property (nonatomic, readonly) NSArray *arrayOfCompletedTodos;
@property (nonatomic, readonly) NSArray *arrayOfIncompleteTodos;
@property (nonatomic, readonly) NSArray *arrayOfInProgressTodos;

@property (nonatomic, readonly) NSUInteger nCompleted;
@property (nonatomic, readonly) NSUInteger nIncompleted;
@property (nonatomic, readonly) NSUInteger nInProgress;

@end
