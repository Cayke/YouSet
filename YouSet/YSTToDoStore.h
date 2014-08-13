//
//  YSTToDoStore.h
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSTToDo.h"

@class YSTToDo;

@interface YSTToDoStore : NSObject

// guardar todos
@property (nonatomic) NSMutableArray *toDos;

+ (instancetype)sharedToDoStore;
+ (NSArray*)meToDos;
@end
