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

// update todo, envia o todo para o server modificando-o ou criando
-(void)updateTodo:(YSTToDo*)todo;

// login do usuario, cria o usuario, ou retorna os todos do usuario caso o usuario exista
-(NSDictionary*)login:(YSTUser*)user;

// vai fazer uma requisicao dos todos do usuario passado
-(NSArray*)getTodosFromUser:(YSTUser*)user;

// o usuario do yst vai seguir ou deixar de seguir certo usuario
-(void)userDevice:(YSTUser*)mainUser willFollow:(BOOL)follow user:(YSTUser*)user;

// pegar os seguidores de um user dado
-(NSArray*)getFollowersFromUser:(YSTUser*)user;

// pegar seguidores do usuario do dispositivo
-(NSArray*)getFollowersFromDeviseUser;

// envia a lista de contatos do usuario do dispositivo e retorna os usuarios que sao do yst
-(NSArray*)verifyUserOfYST:(NSArray*)users;

@end
