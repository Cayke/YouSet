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
#import "YSTTodosTableRule.h"

@interface YSTFriendToDosViewController : UIViewController

@property (nonatomic) YSTUser *user ;
@property (nonatomic) NSArray *arrayToDos;
@property (nonatomic) BOOL reloadView;

@property (weak, nonatomic) YSTFriendsViewController *friendsVC;

// regras da tabela
@property (nonatomic) YSTTodosTableRule *tableRule;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarItemSeguir;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarItemMais;

@property (weak, nonatomic, readonly) UIImageView *viewOfImage;

@end
