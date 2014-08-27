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
#import "YSTCreateNewFriendToDo.h"
#import "YSTShowPhotoViewController.h"

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
        
        self.hidesBottomBarWhenPushed = YES;
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
    self.navigationItem.rightBarButtonItem = [self createBarButtonWithPhoto];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIBarButtonItem *) createBarButtonWithPhoto
{
    //altura de 44 pontos
    CGRect frame = CGRectMake(0, 0, 44,44);
    
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    
    CGRect frame = CGRectMake(10, 2.5, 75, 75);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: frame];
    imageView.layer.cornerRadius = 38;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 1;
    imageView.layer.borderColor = [[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1] CGColor];
    imageView.backgroundColor = [UIColor whiteColor];
    
    //colocar image view como property da classe
    _viewOfImage = imageView;
    
    //sombra
    UIView *topView= [[UIView alloc] initWithFrame: frame];
    topView.center=  CGPointMake(frame.size.width / 2, frame.size.height / 2);
    topView.backgroundColor  =[UIColor clearColor];
    topView.layer.shadowColor = [[UIColor blackColor] CGColor];
    topView.layer.shadowOpacity = 0.2;
    topView.layer.shadowRadius = 1;
    topView.layer.shadowOffset = CGSizeMake(10, 3);
    topView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds cornerRadius:60].CGPath;
    topView.layer.shouldRasterize = YES;
    topView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [topView addSubview:imageView];
    
    [button addSubview:topView];
    [button setShowsTouchWhenHighlighted:YES];
    [button addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchDown];
    
  //  UIBarButtonItem *buttonWithPhoto
    
    [self setImageWithPath:nil];
    
//    UIButton *button = [[UIButton alloc]initWithFrame:frame];
//    [button setBackgroundImage:_imageBarButton forState:UIControlStateNormal];
//    [button setShowsTouchWhenHighlighted:YES];
//    
//    [button addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchDown];
//    
//    UIBarButtonItem *buttonWithPhoto = [[UIBarButtonItem alloc]initWithCustomView:button];
//    
//    [self putPhoto];
}

-(void) setImageWithPath:(NSString*)path {
    //    SOImage *image = [[SOImage alloc]init];
    //    [image setImageNamed:path toUIImageView:_viewOfImage andActivivyIndicator:_carregando];
    _viewOfImage.image = [UIImage imageNamed:@"user91.png"];
}

- (void) showPhoto
{
    YSTShowPhotoViewController *show = [[YSTShowPhotoViewController alloc]init];
    show.title = self.user.name;
    show.navigationItem.backBarButtonItem.title = self.title;
    show.photo = self.imageBarButton;
    [self.navigationController pushViewController:show animated:YES];
    
}
-(void) addTodo
{
    //chamar tela para criar novo todo
    NSLog(@"add todo tal pessoa");
    
    YSTCreateNewFriendToDo *friendToDo = [[YSTCreateNewFriendToDo alloc]init];
    UINavigationController *navFriendToDo = [[UINavigationController alloc]initWithRootViewController:friendToDo];
    [self.navigationController presentViewController:navFriendToDo animated:YES completion:nil];    
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
