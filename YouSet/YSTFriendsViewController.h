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
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic) NSArray *amigos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

-(void) addContact;

@end
