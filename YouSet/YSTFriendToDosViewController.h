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

@end
