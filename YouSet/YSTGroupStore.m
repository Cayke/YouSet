//
//  YSTGroupStore.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTGroupStore.h"

@implementation YSTGroupStore

- (id) initPrivate {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

+(instancetype)sharedGroupStore {
    static YSTGroupStore *sharedGroupStore = nil;
    
    if (!sharedGroupStore) {
        sharedGroupStore = [[self alloc] initPrivate];
    }
    
    return sharedGroupStore;
}
@end
