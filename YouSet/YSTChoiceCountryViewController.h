//
//  YSTChoiceCountryViewController.h
//  YouSet
//
//  Created by Riheldo Melo Santos on 26/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTLoginViewController.h"

@interface YSTChoiceCountryViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *countries;

@property (weak, nonatomic) YSTLoginViewController *loginVC;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
