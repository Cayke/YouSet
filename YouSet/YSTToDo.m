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

@end
