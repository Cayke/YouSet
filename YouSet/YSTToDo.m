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
    [self setWithDictionary:dict];
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

-(int)status{
    int sum = 0;
    int qtd = 0;
    for (YSTAssignee *a in _assignee) {
        sum += a.status;
        qtd++;
    }
    
    if (qtd==1) {
        return sum;
    } else {
        return sum/qtd;
    }
}

-(NSDictionary *)getDictionary {
    NSNumber *ID = [[NSNumber alloc]initWithInt:_ID];
    NSNumber *idCreatedBy = [[NSNumber alloc]initWithInt:_idCreatedBy];
    NSNumber *public = [[NSNumber alloc]initWithBool:_isPublic];
    NSNumber *serverOK = [[NSNumber alloc]initWithInt:_serverOk];
    
    NSMutableArray *assigns = [[NSMutableArray alloc]init];
    for (YSTAssignee *ass in _assignee) {
        [assigns addObject:[ass getDictionary]];
    }
    
    if (!_dateCreated) {
        _dateCreated = [NSDate date];
    }
    if (!_dateExpire) {
        _dateExpire = [NSDate date];
    }
    if (!_dateFinished) {
        _dateFinished = [NSDate date];
    }
    
    return @{@"id": ID, @"todo":_todo, @"assignee": assigns, @"createdBy": idCreatedBy, @"dateCreated": _dateCreated, @"dateFinished": _dateFinished, @"dateExpire": _dateExpire, @"isPublic": public, @"serverOk":serverOK};
}

-(void)setWithDictionary:(NSDictionary *)dict{
    _ID = [[dict objectForKey:@"id"]intValue];
    _todo = [dict objectForKey:@"todo"];
    
    YSTAssignee *reloadAss = nil;
    for (NSDictionary *a in [dict objectForKey:@"assignee"]) {
        reloadAss = [[YSTAssignee alloc]init];
        [reloadAss setWithDictionary:a];
        [self includeAssign:reloadAss];
    }
    
    _idCreatedBy = [[dict objectForKey:@"createdBy"]intValue];
    _dateCreated = [dict objectForKey:@"dateCreated"];
    _dateFinished = [dict objectForKey:@"dateFinished"];
    _dateExpire = [dict objectForKey:@"dateExpire"];
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

-(YSTAssignee *)getAssigneeOfUser:(YSTUser *)user{
    for (YSTAssignee *a in _assignee) {
        if (a.idUser == user.ID) {
            return a;
        }
    }
    return nil;
}

-(void)setFromServer:(NSDictionary *)dict{
    _ID = [[dict objectForKey:@"id"]intValue];
    _todo = [dict objectForKey:@"todo"];
    _serverOk = 3;
    _isPublic = [[dict objectForKey:@"public"]boolValue];
    
    YSTAssignee *reloadAss = nil;
    for (NSDictionary *a in [dict objectForKey:@"tasks"]) {
        reloadAss = [[YSTAssignee alloc]init];
        [reloadAss setWithDictionary:a];
        [self includeAssign:reloadAss];
    }
    _createdByName = [dict objectForKey:@"createdByName"];
    _idCreatedBy = [[dict objectForKey:@"createdById"]intValue];
    _dateCreated = [dict objectForKey:@"dateCreated"];
    _dateFinished = [dict objectForKey:@"dateFinished"];
    _dateExpire = [dict objectForKey:@"dateExpire"];
}
@end
