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
    
    //sumir com a tabbar e colocar a toolbar
    self.tabBarController.tabBar.hidden = YES;
    
    //botar as actions dos tabbaritens
    [self.toolBarItemSeguir setAction:@selector(seguir)];
    [self.toolBarItemMais setAction:@selector(addTodo)];
    

    //criar botao com a fotinha da pessoa
    [self putPhoto];
//    UIBarButtonItem *buttonWithPhoto = [[UIBarButtonItem alloc]initWithImage:_imageBarButton style:UIBarButtonItemStyleBordered target:self action:@selector(showPhoto)];
    //buttonWithPhoto setImageInsets:uiedge
    
    CGRect frame = CGRectMake(0, 0, 44,44);
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setBackgroundImage:_imageBarButton forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    
    [button addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *buttonWithPhoto = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
    
    self.navigationItem.rightBarButtonItem = buttonWithPhoto;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) putPhoto
{
    _imageBarButton = [[UIImage imageNamed:@"user91.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

}

- (void) showPhoto
{
    NSLog(@"mostrar fotinha");
}
-(void) addTodo
{
    NSLog(@"add todo tal pessoa");
    
}

-(void) seguir
{
    NSLog(@"agora vc segue tal pessoa");
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
  //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
