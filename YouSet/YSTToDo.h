//
//  YSTToDo.h
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSTAssignee.h"
@class YSTAssignee;
@interface YSTToDo : NSObject

@property (atomic) int ID;
@property (nonatomic) NSString *todo;
@property (nonatomic) YSTAssignee *assignee;
@property (nonatomic) int idCreatedBy;
@property (nonatomic) NSDate *dateCreated;
@property (nonatomic) NSDate *dateFinished;
@property (nonatomic) NSDate *dateSchedule;
@property (atomic) int privacy;
@property (nonatomic) int serverOk;

-(id)initWithDictionary:(NSDictionary*)dict;
-(void)changeStatusCompleted: (YSTToDo*)todo;
-(void)changeStatusIncomplete: (YSTToDo*)todo;

@end
