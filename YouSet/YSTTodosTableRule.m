//
//  YSTTodosTableRule.m
//  YouSet
//
//  Created by Riheldo Melo Santos on 03/09/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTTodosTableRule.h"

@implementation YSTTodosTableRule

-(id)init{
    @throw [[NSException alloc]initWithName:@"rule has to init with initWithTable..." reason:@"rule has to init with table and user" userInfo:nil];
    return nil;
}

-(id)initWithTable:(UITableView *)tableView andUser:(YSTUser *)user{
    // inicializacao obrigatoria
    _tableView = tableView;
    _todosFromUser = user;
    return self;
}

-(void)loadTable{
    // ler celula da tabela
    UINib *nib = [UINib nibWithNibName:@"YSTMeTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"YSTMeTableViewCell"];
    
    // quando puxar a tabela para baixo, atualizar a tabela
    _refreshControl = [[UIRefreshControl alloc]init];
    [_tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents: UIControlEventValueChanged];
    
    // carregar do server
    _todosArray = [[YSTConnection sharedConnection]getTodosFromUser:_todosFromUser withError:nil];
    
    // atualizar tabela
    [self reloadArraysOfTodos];
    [_tableView reloadData];
}

- (void)refreshTable {
    //TODO: refresh your data
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        _todosArray = [[YSTConnection sharedConnection] getTodosFromUser:_todosFromUser withError:error];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!error) {
                [_refreshControl endRefreshing];
                [self reloadArraysOfTodos];
                [_tableView reloadData];
            }
        });
    });
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
    
    
    [cell setCellWithTodo:thisToDo andUserRepresentation:_todosFromUser];
    
    if ([thisToDo status] == 0) {
        NSString *image = @"none.png";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25.0, 25.0)];
        imageView.image = [UIImage imageNamed:image];
        [cell setAccessoryView:imageView];
        
    } else if ([thisToDo status] == 1) {
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
            return NSLocalizedString(@"Incompletas", nil);
            
        } else if (_nInProgress>0) {
            return NSLocalizedString(@"Em Progresso", nil);
            
        } else if (_nCompleted>0) {
            return NSLocalizedString(@"Terminadas", nil);
            
        }
        
    } else if (section == 1) {
        // sessao de numero 2
        if (_nInProgress>0 && _nIncompleted>0) {
            return NSLocalizedString(@"Em Progresso", nil);
            
        } else if (_nCompleted>0) {
            return NSLocalizedString(@"Terminadas", nil);
            
        }
        
    } else if (section == 2) {
        // sessao de numero 3
        // so pode cair aqui quando exister todos em todos os estados
        // ou seja, retorna todos completados
        return NSLocalizedString(@"Terminadas", nil);
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
    [_tableView reloadData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSTToDo *todoCell;
    
    // preservar a ordem da tabela que eh:
    // 1: INCOMPLETOS
    // 2: EM PROGRESSO
    // 3: COMPLETADOS
    
    if (indexPath.section == 0) {
        // sessao numero 1
        if (_nIncompleted>0) {
            // pegar do array dos todos que estao incompletos
            todoCell = [_arrayOfIncompleteTodos objectAtIndex:indexPath.row];
            
        } else if (_nInProgress>0) {
            // pegar do array dos todos em progresso
            todoCell = [_arrayOfInProgressTodos objectAtIndex:indexPath.row];
            
        } else if (_nCompleted>0) {
            // pegar do array dos todos completados
            todoCell = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
            
        }
        
    } else if (indexPath.section == 1) {
        // sessao de numero 2
        if (_nInProgress>0 && _nIncompleted>0) {
            // pegar do array dos todos em progresso
            todoCell = [_arrayOfInProgressTodos objectAtIndex:indexPath.row];
            
        } else if (_nCompleted>0) {
            // pegar do array dos todos completados
            todoCell = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
            
        }
        
    } else if (indexPath.section == 2) {
        // sessao de numero 3
        // so pode cair aqui quando exister todos em todos os estados
        // ou seja, retorna todos completados
        todoCell = [_arrayOfCompletedTodos objectAtIndex:indexPath.row];
        
    }
    
    // altura do label = ??
    // mais o rodape = 12
    // mais especao de respiro = 16
    
    UILabel *label = [[UILabel alloc]init];
    label.text = todoCell.todo;
    label.numberOfLines = 6;
    
    CGSize size = [label sizeThatFits:CGSizeMake(280, FLT_MAX)];
    
    return size.height + 12 + 14;
}

-(void)reloadArraysOfTodos{
    
    NSMutableArray *completedTodos, *incompletedTodos, *inProgressTodos;
    
    completedTodos = [[NSMutableArray alloc]init];
    incompletedTodos = [[NSMutableArray alloc]init];
    inProgressTodos = [[NSMutableArray alloc]init];
    
    for (YSTToDo *todo in _todosArray) {
        switch ([todo status]) {
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

@end
