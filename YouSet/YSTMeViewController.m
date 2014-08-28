//
//  YSTMeViewController.m
//  YouSet
//
//  Created by Willian Pinho on 8/8/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTMeViewController.h"
#import "YSTCreateNewTodo.h"
#import "YSTMeTableViewCell.h"
#import "YSTToDo.h"
#import "YSTToDoStore.h"
#import "CPStub.h"



@interface YSTMeViewController ()

@end

@implementation YSTMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _toDoMeArray = [YSTToDoStore allToDosOfUser];
    
     UINib *nib = [UINib nibWithNibName:@"YSTMeTableViewCell" bundle:nil];
    [self.meTableView registerNib:nib forCellReuseIdentifier:@"YSTMeTableViewCell"];
    
    self.meTableView.delegate = self;
    self.meTableView.dataSource = self;
    [self reloadArraysOfTodos];
    
    
    self.title = @"Eu";
    
    
    UIBarButtonItem *btnAddToDO = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newToDo:)];
    btnAddToDO.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnAddToDO;
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    _toDoMeArray = [YSTToDoStore sharedToDoStore].toDos;
    [self reloadArraysOfTodos];
    [_meTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)newToDo:(UIBarButtonItem*)bar{
    NSLog(@"novo ToDo");
    YSTCreateNewTodo *createNewToDoVC = [[YSTCreateNewTodo alloc]init];
    createNewToDoVC.userToDelegateTask = [YSTUser sharedUser];
    
    UINavigationController *navCreateNewTodo = [[UINavigationController alloc]initWithRootViewController:createNewToDoVC];

    [self presentViewController:navCreateNewTodo animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    NSUInteger completed = [_arrayOfCompletedTodos count];
    NSUInteger incompleted = [_arrayOfIncompleteTodos count];
    NSUInteger inProgress = [_arrayOfInProgressTodos count];
    
    if ( completed > 0 && incompleted > 0 && inProgress > 0) {
        return 3;
    } else if ( (completed>0 && incompleted>0) || (completed>0 && inProgress>0) || (incompleted>0 && inProgress>0) ) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        // todos incompletos
        return [_arrayOfIncompleteTodos count];
        
    } else if (section == 1) {
        // todos em progresso
        return [_arrayOfInProgressTodos count];
        
    } else if (section == 2) {
        // todos que estao completos
        return [_arrayOfCompletedTodos count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString static *cellIdentifier = @"YSTMeTableViewCell";
    
    YSTMeTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    YSTToDo *thisToDo;
    
    
    if (indexPath.section == 0) {
        thisToDo = [_arrayOfIncompleteTodos objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        thisToDo = [_arrayOfInProgressTodos objectAtIndex:indexPath.row];
    } else {
        thisToDo = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
    }
    
    
    [cell setCellWithTodo:thisToDo];
   
    if ([thisToDo getAssigneeOfUser:[YSTUser sharedUser]].status == 0) {
       NSString *image = @"none.png";
       UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25.0, 25.0)];
       imageView.image = [UIImage imageNamed:image];
       [cell setAccessoryView:imageView];
    
    } else if ([thisToDo getAssigneeOfUser:[YSTUser sharedUser]].status == 1) {
        NSString *image = @"clock.png";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25.0, 25.0)];
        imageView.image = [UIImage imageNamed:image];
        [cell setAccessoryView:imageView];
    } else {
        NSString *image = @"check.png";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25.0, 25.0)];
        imageView.image = [UIImage imageNamed:image];
        [cell setAccessoryView:imageView];
    }
    
    return cell;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Incompletas";
            break;
        case 1:
            return @"Em Progresso";
            break;
        case 2:
            return @"Terminadas";
            break;
    }
    return @"";
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSTToDo *tappedToDO;
    
    if (indexPath.section == 0) {
        tappedToDO = [_arrayOfIncompleteTodos objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        tappedToDO = [_arrayOfInProgressTodos objectAtIndex:indexPath.row];
    } else {
        tappedToDO = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
    }
    
    
    [tappedToDO incrementStatusOfUser:[YSTUser sharedUser]];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self reloadArraysOfTodos];
    [self.meTableView reloadData];
}

-(void)reloadArraysOfTodos{
    
    NSMutableArray *completedTodos, *incompletedTodos, *inProgressTodos;
    
    completedTodos = [[NSMutableArray alloc]init];
    incompletedTodos = [[NSMutableArray alloc]init];
    inProgressTodos = [[NSMutableArray alloc]init];
    
    for (YSTToDo *todo in _toDoMeArray) {
        int status = [todo getAssigneeOfUser:[YSTUser sharedUser]].status;
        switch (status) {
            case 0:
                [incompletedTodos addObject:todo];
                break;
            case 1:
                [inProgressTodos addObject:todo];
                break;
            case 2:
                [completedTodos addObject:todo];
                break;
        }
    }
    
    _arrayOfCompletedTodos = completedTodos;
    _arrayOfIncompleteTodos = incompletedTodos;
    _arrayOfInProgressTodos = inProgressTodos;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    YSTToDo *thisToDo = [_toDoMeArray objectAtIndex:indexPath.row];
//    NSString *text = thisToDo.todo;
////    YSTMeTableViewCell *cell = (YSTMeTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
//    
//    CGREct textOfRect = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>]
//    
//    CGRect textRect = [text boundingRectWithSize:constraint
//                                         options:NSStringDrawingUsesLineFragmentOrigin
//                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Myriad Pro"
//                                                                                       size:18.0f]}
//                                         context:nil];
//    CGSize size = textRect.size;
//    
//    CGFloat height = MAX(size.height, 44.0f);
//    
//    
//    float cellHeight = height + (CELL_CONTENT_MARGIN * 13);
//    cellHeight = (cellHeight == 174) ? 165 : cellHeight;
//    
//    cellHeight = (cellHeight < 200 && cellHeight != 174) ? cellHeight - 20 : cellHeight;
//    
//    
//    
// 
//
//    return cellHeight;
//}



@end
