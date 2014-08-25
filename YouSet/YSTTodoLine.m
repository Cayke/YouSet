//
//  YSTTodoLine.m
//  YouSet
//
//  Created by Riheldo Melo Santos on 22/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTTodoLine.h"

@implementation YSTTodoLine

- (id)initPrivate {
    self = [super init];
    if (self) {
        _path = [NSString stringWithFormat:@"%@/Documents/lineOfTodos.plist",NSHomeDirectory()];
    }
    return self;
}

+(YSTTodoLine *)sharedLine{
    static YSTTodoLine *todoLine = nil;
    
    if (!todoLine) {
        todoLine = [[self alloc]initPrivate];
    }
    
    return todoLine;
}

-(void)insertTodo:(YSTToDo *)todo{
    NSMutableArray *todos = [[NSMutableArray alloc]initWithContentsOfFile:_path];
    
    if (!todos) {
        todos = [[NSMutableArray alloc]init];

    }
}

@end
