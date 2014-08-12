//
//  YSTToDoStore.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTToDoStore.h"

@implementation YSTToDoStore

-(id)init{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[YSTToDoStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (id) initPrivate {
    self = [super init];
    _todos = [[NSMutableArray alloc]init];
    return self;
}


+(instancetype)sharedToDoStore {
    static YSTToDoStore *sharedToDoStore = nil;
    
    if (!sharedToDoStore) {
        sharedToDoStore = [[self alloc] initPrivate];
    }
    
    return sharedToDoStore;
}
@end
