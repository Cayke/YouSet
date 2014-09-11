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

@property (nonatomic, readonly) NSString *site;

+(id)sharedConnection;

// update todo, envia o todo para o server modificando-o ou criando
-(void)updateTodo:(YSTToDo*)todo; // assyncrono

// login do usuario, cria o usuario, ou retorna os dados do usuario caso ele exista
-(YSTUser*)login:(YSTUser*)user withError:(NSError*)error;

// vai fazer uma requisicao dos todos do usuario passado
-(NSArray*)getTodosFromUser:(YSTUser*)user withError:(NSError*)error;

// o usuario do yst vai seguir ou deixar de seguir certo usuario
-(void)userDevice:(YSTUser*)mainUser willFollow:(BOOL)follow user:(YSTUser*)user; // assyncrono

// pegar os seguidores de um user dado
-(NSArray*)getFollowersFromUser:(YSTUser*)user withError:(NSError*)error;

// pegar seguidores do usuario do dispositivo
-(NSArray*)getFollowersFromDeviseUserWithError:(NSError*)error;

// envia a lista de contatos do usuario do dispositivo e retorna os usuarios que sao do yst
-(NSArray*)verifyUserOfYST:(NSArray*)contacts withError:(NSError*)error;

// enviar imagem para server
-(void)uploadPhoto:(UIImage*)image ofUser:(YSTUser*)user withError:(NSError**)error;

@end
