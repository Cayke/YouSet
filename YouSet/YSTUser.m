//
//  YSTUser.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTUser.h"

@implementation YSTUser

-(id)init{
    @throw [NSException exceptionWithName:@"singleton" reason:@"use sharedUser" userInfo:nil];
    return nil;
}


- (id)initPrivate
{
    self = [super init];
    if (self) {
        // path
        _path = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];

        // pegar infos da plist user
        NSDictionary *userDict = [[NSDictionary alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_path,@"user.plist"]];
        
        if (userDict) {
            _logedin = YES;
            
            _phone = [userDict objectForKey:@"phone"];
            _name = [userDict objectForKey:@"name"];
            _phone = [userDict objectForKey:@"phone"];
            _email = [userDict objectForKey:@"email"];
        } else {
            _logedin = NO;
        }
    }
    return self;
}

+(YSTUser*)sharedUser{
    static YSTUser *user = nil;
    
    if (!user) {
        user = [[YSTUser alloc]initPrivate];
    }
    
    return user;
}

@end
