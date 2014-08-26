//
//  YSTFriendToDosViewController.h
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTUser.h"

@interface YSTFriendToDosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) YSTUser *user ;
@property (nonatomic) NSArray *arrayToDos;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarItemSeguir;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarItemMais;

@property (nonatomic) UIImage *imageBarButton;

@end
