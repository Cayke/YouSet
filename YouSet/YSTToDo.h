//
//  YSTToDo.h
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSTAssignee.h"
#import "YSTUser.h"

@class YSTAssignee;

@interface YSTToDo : NSObject

////// DEFINIR NUMEROS DOS STATUS
// 0 incompleto
// 1 iniciada
// 2 completo


@property (atomic) int ID;
@property (nonatomic) NSString *todo;
// O NSArray assignee será do tipo YSTAssignee
@property (nonatomic) NSArray *assignee;
@property (nonatomic) int idCreatedBy;
@property (nonatomic) NSDate *dateCreated;
@property (nonatomic) NSDate *dateFinished;
@property (nonatomic) NSDate *dateSchedule;
@property (atomic) int privacy;
@property (nonatomic) int serverOk;

-(id)initWithDictionary:(NSDictionary*)dict;

// incluir assign na todo
-(void)includeAssign:(YSTAssignee*)assignee;

// metodo vai incrementar o status do usuario dado
-(void)incrementStatusOfUser:(YSTUser*)user;

@end
