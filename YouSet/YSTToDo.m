//
//  YSTToDo.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTToDo.h"
#import "YSTConnection.h"

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
    for (YSTAssignee *assig in _assignee) {
        if ([assig isFromUser:user]) {
            [assig incrementStatus];
            [[YSTConnection sharedConnection]updateTodo:self];
            break;
        }
    }
}

-(NSDictionary *)getDictionary {
    NSNumber *ID = [[NSNumber alloc]initWithInt:_ID];
    return @{@"id": ID, @"todo":_todo};
}

-(NSString *)getDescriptionToPost{
    NSString *assign = nil;
    for (YSTAssignee *a in _assignee) {
        if (!assign) {
            assign = @"";
        }
        // id_status_idUser
        assign = [assign stringByAppendingFormat:@"a%d_%d_%d",a.ID,a.status,a.idUser];
    }
    
    return [NSString stringWithFormat:@"&ID=%d&todo=%@&createdBy=%d&dateCreated=%@&dateFinished=%@&dateExpire=%@&public=%d&task=%@",_ID, _todo, _idCreatedBy,_dateCreated,_dateFinished, _dateExpire, _isPublic, assign];
}

@end
