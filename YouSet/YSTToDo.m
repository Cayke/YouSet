//
//  YSTToDo.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTToDo.h"

@implementation YSTToDo
-(id)init {
    _assignee = [[YSTAssignee alloc]init];
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dict{
    _ID = [[dict objectForKey:@"id"]intValue];
    _todo = [dict objectForKey:@"todo"];
    _assignee.status = [[dict objectForKey:@"status"]intValue];
    return self;
}

- (void)changeStatusCompleted:(YSTToDo *)todo {
    todo.assignee.status = 1;
}

- (void)changeStatusIncomplete:(YSTToDo *)todo {
    todo.assignee.status = 0;
}

-(void)incrementStatus{
    [_assignee incrementStatus];
}

@end
