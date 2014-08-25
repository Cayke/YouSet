//
//  YSTToDoStore.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTToDoStore.h"
#import "YSTToDo.h"

@implementation YSTToDoStore

-(id)init{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[YSTToDoStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (id) initPrivate {
    self = [super init];
    
    if (self) {
        self.toDos = [[NSMutableArray alloc]init];
        
        // path
        _path = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    }
    
    return self;
}


+(instancetype)sharedToDoStore {
    static YSTToDoStore *sharedToDoStore = nil;
    
    if (!sharedToDoStore) {
        sharedToDoStore = [[self alloc] initPrivate];
    }
    
    return sharedToDoStore;
}


// apagar depois
// funcoes para teste
+ (NSArray *)allToDosOfUser {
    NSMutableArray *todos = [[NSMutableArray alloc]init];
    YSTToDo *toDo;
    YSTAssignee *assignee = [[YSTAssignee alloc]init];
    int count = 10;
    for (int i = 0; i < count; i++) {
        toDo = [[YSTToDo alloc]init];
        toDo.ID = i;
        toDo.todo = [NSString stringWithFormat:@"ToDo number %d",i];
        toDo.idCreatedBy = 1;
        toDo.dateCreated = [[NSDate alloc]init];
        toDo.isPublic = YES;
        [toDo includeAssign:assignee];
        assignee.status = 0;
        [todos addObject:toDo];
    }
    
    
    return [NSArray arrayWithArray:todos];
}

//-(int)getNewID{
//    NSDictionary *info = [[NSDictionary alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_path,@"info.plist"]];
//    
//    int lastid = 0;
//    if (info) {
//        lastid = [[info objectForKey:@"lastid"]intValue];
//        lastid++;
//        
//        NSMutableDictionary *updateInfo = [[NSMutableDictionary alloc]initWithDictionary:info];
//        [updateInfo removeObjectForKey:@"lastid"];
//        [updateInfo setObject:[[NSNumber alloc]initWithInt:lastid] forKey:@"lastid"];
//        
//        [updateInfo writeToFile:[NSString stringWithFormat:@"%@/%@",_path,@"info.plist"] atomically:YES];
//    } else {
//        NSDictionary *newinfo = @{@"lastid": [[NSNumber alloc]initWithInt:0]};
//        [newinfo writeToFile:[NSString stringWithFormat:@"%@/%@",_path,@"info.plist"] atomically:YES];
//        
//    }
//    return lastid;
//}

-(void)createTodo:(YSTToDo *)todo{
    // registrar o todo na store
    [_toDos addObject:todo];
    
    // enviar o todo criado para o servidor
    [[YSTConnection sharedConnection]updateTodo:todo];
}


-(YSTToDo *)nextTodoOnLine{
    YSTToDo *nextTodo = nil;
    for (YSTToDo *t in _toDos) {
        if (t.serverOk == 0) {
            nextTodo = t;
            break;
        }
    }
    return nextTodo;
}

-(void)saveTodos{
    NSString *todosPlist = [NSString stringWithFormat:@"%@/%@",_path,@"todos.plist"];
    
    NSMutableArray *todos = [[NSMutableArray alloc]init];
    for (YSTToDo *todo in _toDos) {
        [todos addObject:[todo getDictionary]];
    }
    
    [todos writeToFile:todosPlist atomically:YES];
}

-(void)reloadTodos{
    _toDos = [[NSMutableArray alloc]init];
    
    NSString *todosPlist = [NSString stringWithFormat:@"%@/%@",_path,@"todos.plist"];
    
    NSArray *todos = [NSArray arrayWithContentsOfFile:todosPlist];
    for (NSDictionary *d in todos) {
        [_toDos addObject:[[YSTToDo alloc]initWithDictionary:d]];
    }
    
}

@end
