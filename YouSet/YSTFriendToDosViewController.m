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
    //[self getUserToDos];
    
    // identificar na tabela
    //UINib *nib = [UINib nibWithNibName:@"YSTMeTableViewCell" bundle:nil];
    //[self.tableView registerNib:nib forCellReuseIdentifier:@"YSTMeTableViewCell"];
    
    self.title = _user.name;
    
    //sumir com a tabbar e colocar a toolbar
    self.tabBarController.tabBar.hidden = YES;
    
    self.toolBarItemSeguir.title = NSLocalizedString(@"Seguir", nil);
    
    //botar as actions dos tabbaritens
    [self.toolBarItemSeguir setAction:@selector(seguir)];
    [self.toolBarItemMais setAction:@selector(addTodo)];
    
    
    _tableRule = [[YSTTodosTableRule alloc]initWithTable:_tableView andUser:_user];
    _tableView.delegate = _tableRule;
    _tableView.dataSource = _tableRule;
    [_tableRule loadTable];
    
    //criar botao com a fotinha da pessoa
    self.navigationItem.rightBarButtonItem = [self createBarButtonWithPhoto];
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    if (_reloadView) {
//        [self reloadViewMethod];
//    }
//}
//
//-(void) reloadViewMethod
//{
//    [self getUserToDos];
//    
//    [_tableView reloadData];
//    
//    _reloadView = NO;
//}

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

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    
//    if ( _nCompleted > 0 && _nIncompleted > 0 && _nInProgress > 0) {
//        return 3;
//    } else if ( (_nCompleted>0 && _nIncompleted>0) || (_nCompleted>0 && _nInProgress>0) || (_nIncompleted>0 && _nInProgress>0) ) {
//        return 2;
//    }
//    
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // preservar a ordem da tabela que eh:
//    // 1: INCOMPLETOS
//    // 2: EM PROGRESSO
//    // 3: COMPLETADOS
//    
//    if (section == 0) {
//        // sessao numero 1
//        if (_nIncompleted>0) {
//            return _nIncompleted;
//            
//        } else if (_nInProgress>0) {
//            return _nInProgress;
//            
//        } else if (_nCompleted>0) {
//            return _nCompleted;
//            
//        }
//        
//    } else if (section == 1) {
//        // sessao de numero 2
//        if (_nInProgress>0 && _nIncompleted>0) {
//            return _nInProgress;
//            
//        } else if (_nCompleted>0) {
//            return _nCompleted;
//            
//        }
//        
//    } else if (section == 2) {
//        // sessao de numero 3
//        // so pode cair aqui quando exister todos em todos os estados
//        // ou seja, retorna todos completados
//        return _nCompleted;
//    }
//    
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSString static *cellIdentifier = @"YSTMeTableViewCell";
//    
//    YSTMeTableViewCell  *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    YSTToDo *thisToDo;
//    
//    // preservar a ordem da tabela que eh:
//    // 1: INCOMPLETOS
//    // 2: EM PROGRESSO
//    // 3: COMPLETADOS
//    
//    if (indexPath.section == 0) {
//        // sessao numero 1
//        if (_nIncompleted>0) {
//            // pegar do array dos todos que estao incompletos
//            thisToDo = [_arrayOfIncompleteTodos objectAtIndex:indexPath.row];
//            
//        } else if (_nInProgress>0) {
//            // pegar do array dos todos em progresso
//            thisToDo = [_arrayOfInProgressTodos objectAtIndex:indexPath.row];
//            
//        } else if (_nCompleted>0) {
//            // pegar do array dos todos completados
//            thisToDo = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
//            
//        }
//        
//    } else if (indexPath.section == 1) {
//        // sessao de numero 2
//        if (_nInProgress>0 && _nIncompleted>0) {
//            // pegar do array dos todos em progresso
//            thisToDo = [_arrayOfInProgressTodos objectAtIndex:indexPath.row];
//            
//        } else if (_nCompleted>0) {
//            // pegar do array dos todos completados
//            thisToDo = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
//            
//        }
//        
//    } else if (indexPath.section == 2) {
//        // sessao de numero 3
//        // so pode cair aqui quando exister todos em todos os estados
//        // ou seja, retorna todos completados
//        thisToDo = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
//        
//    }
//    
//    
//    [cell setCellWithTodo:thisToDo];
//    
//    if ([thisToDo getAssigneeOfUser:_user].status == 0) {
//        NSString *image = @"none.png";
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25.0, 25.0)];
//        imageView.image = [UIImage imageNamed:image];
//        [cell setAccessoryView:imageView];
//        
//    } else if ([thisToDo getAssigneeOfUser:_user].status == 1) {
//        NSString *image = @"clock.png";
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25.0, 25.0)];
//        imageView.image = [UIImage imageNamed:image];
//        [cell setAccessoryView:imageView];
//    } else {
//        NSString *image = @"check.png";
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25.0, 25.0)];
//        imageView.image = [UIImage imageNamed:image];
//        [cell setAccessoryView:imageView];
//    }
//    
//    return cell;
//    
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    // preservar a ordem da tabela que eh:
//    // 1: INCOMPLETOS
//    // 2: EM PROGRESSO
//    // 3: COMPLETADOS
//    
//    if (section == 0) {
//        // sessao numero 1
//        if (_nIncompleted>0) {
//            return @"Incompletas";
//            
//        } else if (_nInProgress>0) {
//            return @"Em Progresso";
//            
//        } else if (_nCompleted>0) {
//            return @"Terminadas";
//            
//        }
//        
//    } else if (section == 1) {
//        // sessao de numero 2
//        if (_nInProgress>0 && _nIncompleted>0) {
//            return @"Em Progresso";
//            
//        } else if (_nCompleted>0) {
//            return @"Terminadas";
//            
//        }
//        
//    } else if (section == 2) {
//        // sessao de numero 3
//        // so pode cair aqui quando exister todos em todos os estados
//        // ou seja, retorna todos completados
//        return @"Terminadas";
//    }
//    
//    return @"";
//}
//
//-(void)reloadArraysOfTodos{
//    
//    NSMutableArray *completedTodos, *incompletedTodos, *inProgressTodos;
//    
//    completedTodos = [[NSMutableArray alloc]init];
//    incompletedTodos = [[NSMutableArray alloc]init];
//    inProgressTodos = [[NSMutableArray alloc]init];
//    
//    for (YSTToDo *todo in _arrayToDos) {
//        int status = [todo getAssigneeOfUser:_user].status;
//        switch (status) {
//            case 0:
//                [incompletedTodos addObject:todo];
//                break;
//            case 1:
//                [inProgressTodos addObject:todo];
//                break;
//            case 2:
//                [completedTodos addObject:todo];
//                break;
//        }
//    }
//    
//    _arrayOfCompletedTodos = completedTodos;
//    _arrayOfIncompleteTodos = incompletedTodos;
//    _arrayOfInProgressTodos = inProgressTodos;
//    
//    // Return the number of sections.
//    _nCompleted = [_arrayOfCompletedTodos count];
//    _nIncompleted = [_arrayOfIncompleteTodos count];
//    _nInProgress = [_arrayOfInProgressTodos count];
//    
//}
//
//-(void) getUserToDos
//{
//    _arrayToDos = [[YSTConnection sharedConnection]getTodosFromUser:self.user withError:nil];
//    [self reloadArraysOfTodos];
//}

@end
