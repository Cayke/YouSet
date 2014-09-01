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
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.meTableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents: UIControlEventValueChanged];
    
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

- (void)refreshTable {
    //TODO: refresh your data
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        _toDoMeArray = [[YSTConnection sharedConnection] getTodosFromUser: [YSTUser sharedUser] withError:error];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!error) {
                [_refreshControl endRefreshing];
                [self reloadArraysOfTodos];
                [_meTableView reloadData];
            }
        });
    });
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
    
    if ( _nCompleted > 0 && _nIncompleted > 0 && _nInProgress > 0) {
        return 3;
    } else if ( (_nCompleted>0 && _nIncompleted>0) || (_nCompleted>0 && _nInProgress>0) || (_nIncompleted>0 && _nInProgress>0) ) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // preservar a ordem da tabela que eh:
    // 1: INCOMPLETOS
    // 2: EM PROGRESSO
    // 3: COMPLETADOS
    
    if (section == 0) {
        // sessao numero 1
        if (_nIncompleted>0) {
            return _nIncompleted;
            
        } else if (_nInProgress>0) {
            return _nInProgress;
            
        } else if (_nCompleted>0) {
            return _nCompleted;

        }
        
    } else if (section == 1) {
        // sessao de numero 2
        if (_nInProgress>0 && _nIncompleted>0) {
            return _nInProgress;
            
        } else if (_nCompleted>0) {
            return _nCompleted;
            
        }
        
    } else if (section == 2) {
        // sessao de numero 3
        // so pode cair aqui quando exister todos em todos os estados
        // ou seja, retorna todos completados
        return _nCompleted;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString static *cellIdentifier = @"YSTMeTableViewCell";
    
    YSTMeTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    YSTToDo *thisToDo;
    
    // preservar a ordem da tabela que eh:
    // 1: INCOMPLETOS
    // 2: EM PROGRESSO
    // 3: COMPLETADOS
    
    if (indexPath.section == 0) {
        // sessao numero 1
        if (_nIncompleted>0) {
            // pegar do array dos todos que estao incompletos
            thisToDo = [_arrayOfIncompleteTodos objectAtIndex:indexPath.row];
            
        } else if (_nInProgress>0) {
            // pegar do array dos todos em progresso
            thisToDo = [_arrayOfInProgressTodos objectAtIndex:indexPath.row];
            
        } else if (_nCompleted>0) {
            // pegar do array dos todos completados
            thisToDo = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
            
        }
        
    } else if (indexPath.section == 1) {
        // sessao de numero 2
        if (_nInProgress>0 && _nIncompleted>0) {
            // pegar do array dos todos em progresso
            thisToDo = [_arrayOfInProgressTodos objectAtIndex:indexPath.row];
            
        } else if (_nCompleted>0) {
            // pegar do array dos todos completados
            thisToDo = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];

        }
        
    } else if (indexPath.section == 2) {
        // sessao de numero 3
        // so pode cair aqui quando exister todos em todos os estados
        // ou seja, retorna todos completados
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
    
    // preservar a ordem da tabela que eh:
    // 1: INCOMPLETOS
    // 2: EM PROGRESSO
    // 3: COMPLETADOS
    
    if (section == 0) {
        // sessao numero 1
        if (_nIncompleted>0) {
            return @"Incompletas";
            
        } else if (_nInProgress>0) {
            return @"Em Progresso";
            
        } else if (_nCompleted>0) {
            return @"Terminadas";
            
        }
        
    } else if (section == 1) {
        // sessao de numero 2
        if (_nInProgress>0 && _nIncompleted>0) {
            return @"Em Progresso";
            
        } else if (_nCompleted>0) {
            return @"Terminadas";
            
        }
        
    } else if (section == 2) {
        // sessao de numero 3
        // so pode cair aqui quando exister todos em todos os estados
        // ou seja, retorna todos completados
        return @"Terminadas";
    }
   
    return @"";
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSTToDo *tappedToDO;
    
    // preservar a ordem da tabela que eh:
    // 1: INCOMPLETOS
    // 2: EM PROGRESSO
    // 3: COMPLETADOS
    
    if (indexPath.section == 0) {
        // sessao numero 1
        if (_nIncompleted>0) {
            // pegar do array dos todos que estao incompletos
            tappedToDO = [_arrayOfIncompleteTodos objectAtIndex:indexPath.row];
            
        } else if (_nInProgress>0) {
            // pegar do array dos todos em progresso
            tappedToDO = [_arrayOfInProgressTodos objectAtIndex:indexPath.row];
            
        } else if (_nCompleted>0) {
            // pegar do array dos todos completados
            tappedToDO = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
            
        }
        
    } else if (indexPath.section == 1) {
        // sessao de numero 2
        if (_nInProgress>0 && _nIncompleted>0) {
            // pegar do array dos todos em progresso
            tappedToDO = [_arrayOfInProgressTodos objectAtIndex:indexPath.row];
            
        } else if (_nCompleted>0) {
            // pegar do array dos todos completados
            tappedToDO = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
            
        }
        
    } else if (indexPath.section == 2) {
        // sessao de numero 3
        // so pode cair aqui quando exister todos em todos os estados
        // ou seja, retorna todos completados
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
    
    // Return the number of sections.
    _nCompleted = [_arrayOfCompletedTodos count];
    _nIncompleted = [_arrayOfIncompleteTodos count];
    _nInProgress = [_arrayOfInProgressTodos count];
    
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
