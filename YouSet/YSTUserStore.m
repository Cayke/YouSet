//
//  YSTUserStore.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTUserStore.h"

@implementation YSTUserStore

- (id) initPrivate {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

+(instancetype)sharedUserStore {
    static YSTUserStore *sharedUserStore = nil;
    
    if (!sharedUserStore) {
        sharedUserStore = [[self alloc] initPrivate];
    }
    
    return sharedUserStore;
}

@end
