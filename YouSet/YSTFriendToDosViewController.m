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
#import "YSTCreateNewTodo.h"
#import "YSTShowPhotoViewController.h"
#import "YSTImage.h"

@interface YSTFriendToDosViewController ()

@end

@implementation YSTFriendToDosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        _reloadView = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getUserToDos];
    
    
    self.title = _user.name;
    
    //sumir com a tabbar e colocar a toolbar
    self.tabBarController.tabBar.hidden = YES;
    
    //botar as actions dos tabbaritens
    [self.toolBarItemSeguir setAction:@selector(seguir)];
    [self.toolBarItemMais setAction:@selector(addTodo)];
    
    
    //criar botao com a fotinha da pessoa
    self.navigationItem.rightBarButtonItem = [self createBarButtonWithPhoto];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (_reloadView) {
        [self reloadViewMethod];
    }
}

-(void) reloadViewMethod
{
    [self getUserToDos];
    
    [_tableView reloadData];
    
    _reloadView = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIBarButtonItem *) createBarButtonWithPhoto
{
    //altura de 44 pontos
    CGRect frame = CGRectMake(0, 0, 40,40);
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: frame];
    imageView.layer.cornerRadius = 20;
    imageView.clipsToBounds = YES;
   // imageView.layer.borderWidth = 1;
   // imageView.layer.borderColor = [[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1] CGColor];
    imageView.backgroundColor = [UIColor whiteColor];
    
    //colocar image view como property da classe
    _viewOfImage = imageView;
    
    //sombra
//    UIView *topView= [[UIView alloc] initWithFrame: frame];
//    topView.center=  CGPointMake(frame.size.width / 2, frame.size.height / 2);
//    topView.backgroundColor  =[UIColor clearColor];
//    topView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    topView.layer.shadowOpacity = 0.2;
//    topView.layer.shadowRadius = 1;
//    topView.layer.shadowOffset = CGSizeMake(0, 3);
//    topView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds cornerRadius:60].CGPath;
//    topView.layer.shouldRasterize = YES;
//    topView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//    
//    [topView addSubview:imageView];
    
//    [button addSubview:topView];
    [button addSubview:imageView];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonWithPhoto = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self setImageWithPath];
    
    return buttonWithPhoto;
}

-(void) setImageWithPath {
    YSTImage *image = [[YSTImage alloc]init];
    [image setImageNamed:_user.photo toUIImageView:_viewOfImage andActivivyIndicator:nil];
}

- (void) showPhoto
{
    YSTShowPhotoViewController *show = [[YSTShowPhotoViewController alloc]init];
    show.title = self.user.name;
    show.navigationItem.backBarButtonItem.title = self.title;
    show.photo = self.viewOfImage.image;
    [self.navigationController pushViewController:show animated:YES];
    
}
-(void) addTodo
{
    //chamar tela para criar novo todo
    YSTCreateNewTodo *friendToDo = [[YSTCreateNewTodo alloc]init];
    friendToDo.friendToDoVC = self;
    friendToDo.userToDelegateTask = self.user;
    
    UINavigationController *navFriendToDo = [[UINavigationController alloc]initWithRootViewController:friendToDo];
    [self.navigationController presentViewController:navFriendToDo animated:YES completion:nil];
}

-(void) seguir
{
    self.friendsVC.reloadFriendsInfo = YES;
    [[YSTConnection sharedConnection] userDevice:[YSTUser sharedUser] willFollow:YES user:self.user];
    NSLog(@"agora vc segue tal pessoa");
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brbr"];
    YSTToDo *todo = [_arrayToDos objectAtIndex:indexPath.row];
    cell.textLabel.text = todo.todo;
    
    if ([todo getAssigneeOfUser:self.user].status == 2 ) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
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

-(void) getUserToDos
{
    _arrayToDos = [[YSTConnection sharedConnection]getTodosFromUser:self.user withError:nil];
    NSLog(@"pegou todos");
}

@end
