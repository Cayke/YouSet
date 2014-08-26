//
//  YSTAssignee.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTAssignee.h"

@implementation YSTAssignee

- (instancetype)init
{
    self = [super init];
    if (self) {
        _status = 0;
    }
    return self;
}

-(void)incrementStatus{
    if (_status < 2) {
        _status++;
    } else {
        _status = 0;
    }
}

-(BOOL)isFromUser:(YSTUser *)user{
    return _idUser == user.ID;
}

-(void)setTaskToUser:(YSTUser *)user{
    _idUser = user.ID;
}

-(void)setIdFromArrayOfServer:(NSArray *)array{
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"user"]intValue] == _idUser) {
            _ID = [[dic objectForKey:@"id"]intValue];
        }
    }
}

@end
