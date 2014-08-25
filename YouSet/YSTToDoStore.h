//
//  YSTToDoStore.h
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSTToDo.h"
#import "YSTConnection.h"
#import "YSTUser.h"

@class YSTToDo;

@interface YSTToDoStore : NSObject

@property (nonatomic) NSString *path;

// guardar todos
@property (nonatomic) NSMutableArray *toDos;

+ (instancetype)sharedToDoStore;

-(void)createTodo:(YSTToDo*)todo;
+ (NSArray *)allToDosOfUser;

-(YSTToDo*)nextTodoOnLine;

-(void)saveTodos;

-(void)reloadTodos;

@end
