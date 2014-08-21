//
//  YSTCreateNewTodo.h
//  YouSet
//
//  Created by Riheldo Melo Santos on 12/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTCreateNewTodo : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSArray *sectionOfRequiredFields;
@property (nonatomic) NSArray *sectionOfOptionalFields;
@property (nonatomic) NSArray *arrayOfSections;
@property (weak, nonatomic) IBOutlet UITableView *toDoTableView;

@end
