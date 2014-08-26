//
//  YSTAssignee.h
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSTToDo.h"
#import "YSTUser.h"

@interface YSTAssignee : NSObject

@property (atomic) int ID;
@property (atomic) int idUser;
@property (atomic) int status;

-(void)incrementStatus;

-(BOOL)isFromUser:(YSTUser*)user;

-(void)setTaskToUser:(YSTUser*)user;

-(void)setIdFromArrayOfServer:(NSArray*)array;

@end
