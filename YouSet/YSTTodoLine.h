//
//  YSTTodoLine.h
//  YouSet
//
//  Created by Riheldo Melo Santos on 22/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSTToDo.h"

@interface YSTTodoLine : NSObject

@property (nonatomic,readonly) NSString *path;

+(YSTTodoLine*)sharedLine;

-(void)insertTodo:(YSTToDo*)todo;

-(NSArray*)getAllTodosOnLine;

-(YSTToDo*)getNextTodoOnLine;

@end
