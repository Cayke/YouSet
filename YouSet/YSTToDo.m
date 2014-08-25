//
//  YSTToDo.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTToDo.h"

@implementation YSTToDo

-(id)initWithDictionary:(NSDictionary *)dict{
    _ID = [[dict objectForKey:@"id"]intValue];
    _todo = [dict objectForKey:@"todo"];
    return self;
}

-(void)includeAssign:(YSTAssignee *)assignee {
    if (!_assignee) {
        _assignee = @[assignee];
    } else {
        NSMutableArray *newAssignee = [[NSMutableArray alloc]initWithArray:_assignee];
        [newAssignee addObject:assignee];
    }
}

-(void)incrementStatusOfUser:(YSTUser*)user{
    YSTAssignee *assigneeToChange = nil;
    for (YSTAssignee *assig in _assignee) {
        if ([assig isFromUser:user]) {
            assigneeToChange = assig;
            break;
        }
    }
    [assigneeToChange incrementStatus];
}

-(NSDictionary *)getDictionary {
    NSNumber *ID = [[NSNumber alloc]initWithInt:_ID];
    return @{@"id": ID, @"todo":_todo};
}

@end
