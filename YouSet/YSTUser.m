//
//  YSTUser.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTUser.h"

@implementation YSTUser

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
            
            _ID = [[userDict objectForKey:@"id"]intValue];
            _phone = [userDict objectForKey:@"phone"];
            _name = [userDict objectForKey:@"name"];
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

-(NSString*)getJustNumbersOfPhone{
    //usar predicado para transformar numero para apenas numeros
    NSString *numeros = [[_phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"1234567890"]invertedSet]] componentsJoinedByString:@""];
    return numeros;
}

-(void)save{
    NSNumber *ID = [[NSNumber alloc]initWithInt:_ID];
    NSDictionary *userDict = @{@"id": ID, @"name": _name, @"phone": _phone};
    [userDict writeToFile:[_path stringByAppendingString:@"/user.plist"] atomically:YES];
}

-(NSString *)getDescriptionToPost{
    return [NSString stringWithFormat:@"&id=%d&name=%@&phone=%@",_ID,_name,[self getJustNumbersOfPhone]];
}

-(void)setUserFromServer:(NSDictionary *)d{
    // id, name, phone.
    _ID = [[d objectForKey:@"id"]intValue];
    _name = [d objectForKey:@"name"];
    _photo = [d objectForKey:@"photo"];
}

@end
