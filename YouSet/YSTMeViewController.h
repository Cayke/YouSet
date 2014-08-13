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

@end
