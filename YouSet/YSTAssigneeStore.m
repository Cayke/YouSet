//
//  YSTAssigneeStore.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTAssigneeStore.h"

@implementation YSTAssigneeStore

- (id) initPrivate {
    self = [super init];
    
    return self;
}


+(instancetype)sharedAssigneeStore {
    static YSTAssigneeStore *sharedAssigneeStore = nil;
    
    if (!sharedAssigneeStore) {
        sharedAssigneeStore = [[self alloc] initPrivate];
    }
    
    return sharedAssigneeStore;
}

@end
