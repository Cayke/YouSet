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

// incrementa o status
-(void)incrementStatus;

// verifica se o assignee é do usuario passado
-(BOOL)isFromUser:(YSTUser*)user;

// colocar tarefa do usuario
-(void)setTaskToUser:(YSTUser*)user;

// traz informacoes do servidor
-(void)setIdFromArrayOfServer:(NSArray*)array;

// retorna um dicionario
-(NSDictionary*)getDictionary;

// recebe dicionario e seta a instancia em questao
-(void)setWithDictionary:(NSDictionary*)dict;

@end
