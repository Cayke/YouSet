//
//  YSTConnection.h
//  YouSet
//
//  Created by Riheldo Santos on 14/8/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSTToDo.h"
#import "YSTUser.h"

@interface YSTConnection : NSObject

+(id)sharedConnection;

-(void)updateTodo:(YSTToDo*)todo;

@end
