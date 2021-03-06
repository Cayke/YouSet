//
//  YSTFriendsViewController.h
//  YouSet
//
//  Created by Cayke Prudente on 18/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTUser.h"

@interface YSTFriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *amigos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *carregando;
@property (nonatomic) BOOL reloadFriendsInfo;

-(void) addContact;
-(void) reloadFriends;

@end
