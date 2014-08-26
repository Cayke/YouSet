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
    
    self.title = @"Me";
    
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
//   if ([thisToDo.assignee objectAtIndex:0].sta  == 0) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    
    
//    cell.description.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.description.numberOfLines = 0;
//    
//    CGSize maximumLabelSize = CGSizeMake(290, FLT_MAX);
//    CGRect textRect = [cell.description.text boundingRectWithSize:maximumLabelSize
//                       
//                                                  options:NSStringDrawingUsesLineFragmentOrigin
//                       
//                                               attributes:@{NSFontAttributeName:cell.description.font}
//                       
//                                                  context:nil];
//    CGSize expectedLabelSize = textRect.size;
//    int offsetYCoordinate = 65;
//    offsetYCoordinate = (expectedLabelSize.height > 50 && expectedLabelSize.height < 70) ? 55 : offsetYCoordinate;
//    offsetYCoordinate = (expectedLabelSize.height > 10 && expectedLabelSize.height < 20) ? 60 : offsetYCoordinate;
//    CGRect newFrame = cell.description.frame;
//    newFrame.origin.y = offsetYCoordinate;
//    int heightForCell = expectedLabelSize.height + offsetYCoordinate;
//    newFrame.size.height = heightForCell;
//    cell.description.frame = newFrame;
    
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    YSTToDo *tappedToDO = [_toDoMeArray objectAtIndex:indexPath.row];
    [tappedToDO incrementStatusOfUser:[YSTUser sharedUser]];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
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
