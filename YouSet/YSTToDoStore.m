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
+ (NSArray*)meToDos {
    NSMutableArray *todos = [[NSMutableArray alloc]init];
    YSTToDo *toDo;
    
    int count = 10;
    for (int i = 0; i < count; i++) {
        toDo = [[YSTToDo alloc]init];
        toDo.ID = i;
        toDo.todo = [NSString stringWithFormat:@"ToDo number %d",i];
        toDo.idCreatedBy = 1;
        toDo.dateCreated = [[NSDate alloc]init];
        toDo.privacy = 2;
        
        [todos addObject:toDo];
    }

    
    return [NSArray arrayWithArray:todos];
}


@end
