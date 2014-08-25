//
//  YSTFriendToDosViewController.m
//  YouSet
//
//  Created by Cayke Prudente on 25/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTFriendToDosViewController.h"
#import "YSTConnection.h"
#import "YSTToDo.h"

@interface YSTFriendToDosViewController ()

@end

@implementation YSTFriendToDosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //_arrayToDos = [[YSTConnection sharedConnection]getTodosFromUser:self.user withError:nil];
        YSTToDo *todo1 = [[YSTToDo alloc]init];
        todo1.todo = @"HUEBR";
        YSTToDo *todo2 = [[YSTToDo alloc]init];
        todo2.todo = @"ME CHUPA WILL VIADO";
        
        _arrayToDos = [[NSArray alloc]initWithObjects:todo1,todo2, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = _user.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brbr"];
    YSTToDo *todo = [_arrayToDos objectAtIndex:indexPath.row];
    cell.textLabel.text = todo.todo;
    [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [_arrayToDos count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
