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
    
    self.title = @"Eu";
    
    
    UIBarButtonItem *btnAddToDO = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newToDo:)];
    btnAddToDO.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btnAddToDO;
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    _toDoMeArray = [YSTToDoStore sharedToDoStore].toDos;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_toDoMeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString static *cellIdentifier = @"YSTMeTableViewCell";
    YSTMeTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    YSTToDo *thisToDo = [_toDoMeArray objectAtIndex:indexPath.row];
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YSTToDo *tappedToDO = [_toDoMeArray objectAtIndex:indexPath.row];
    [tappedToDO incrementStatusOfUser:[YSTUser sharedUser]];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.meTableView reloadData];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSTMeTableViewCell *cell = (YSTMeTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    float cellHeight = 40.0f;
    
    if (cell.tag == 10) {
        float cellHeight = 70.0f;
        [cell.description sizeToFit];
        return cellHeight;
    }

    return cellHeight;
}



@end
