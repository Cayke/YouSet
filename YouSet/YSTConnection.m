//
//  YSTConnection.m
//  YouSet
//
//  Created by Riheldo Santos on 14/8/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTConnection.h"
#import "CPStub.h"
#import "YSTTodoLine.h"

@implementation YSTConnection

-(id)init{
    @throw [NSException exceptionWithName:@"YSTConnection init erro, isso é um singleton" reason:@"use sharedConnection" userInfo:nil];
    
    return nil;
}

-(id)initPrivate{
    self = [super init];
    
    if (self) {
        _site = @"http://127.0.0.1:8000/youset/default";
    }
    
    return self;
}

+(id)sharedConnection{
    static YSTConnection *connection = nil;
    
    if (!connection) {
        connection = [[YSTConnection alloc]initPrivate];
    }
    
    return connection;
}

// update todo, envia o todo para o server modificando-o ou criando
-(void)updateTodo:(YSTToDo*)todo { // assyncrono
    NSLog(@"[YSTConnection todo] = %@", todo);
    
    // preparar o todo para ser enviado para o servidor
    NSString *post = [NSString stringWithFormat:@""];
    
    // criar o request
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@/%@",_site,@"updateTodo"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    
    // comecar assyncrono
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // fazer algum request para o servidor
        NSError *error = nil;
        NSData *dataFromConnection = [self makePostRequest:request post:post withError:error];
        
        
        //This is your completion handler
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"%@",todo);
            if (!error && dataFromConnection) {
                // nao deu erro e o server retornou alguma coisa, completar a tarefa
                NSString *message = [[NSString alloc]initWithData:dataFromConnection encoding:NSUTF8StringEncoding];
                
                if ([message isEqualToString:@"ok"]) {
                    // retornou uma mensagem de ok, quando o todo eh atualizado
                } else if ([message isEqualToString:@"error"]) {
                    // retornou erro
                } else {
                    // retornou o id do todo
                }
            } else {
                NSLog(@"something goes wrong");
                // colocar todo na fila de todos para serem envidos ao servidor
            }
        });
    });

}

// login do usuario, cria o usuario, ou retorna os todos do usuario caso o usuario exista
-(NSDictionary*)login:(YSTUser*)user withError:(NSError*)error {
    return nil;
    // definir url da area de login
    NSURL *url = [[NSURL alloc]initWithString:@"http://www."];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    ////// variaveis em post
    // setar post string
    NSString *post = [NSString stringWithFormat:@"&code=%@", [self codeOfServer]];
    
    NSData *dataFromConnection = [self makePostRequest:request post: post withError:error];
    
    
    if (!error && dataFromConnection) {
        NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:&error];
        if (!error) {
            return a;
        }
    }
    
    return nil;
}

// vai fazer uma requisicao dos todos do usuario passado
-(NSArray*)getTodosFromUser:(YSTUser*)user withError:(NSError*)error {
    return nil;
}

// o usuario do yst vai seguir ou deixar de seguir certo usuario
-(void)userDevice:(YSTUser*)mainUser willFollow:(BOOL)follow user:(YSTUser*)user { // assyncrono
    NSLog(@"[YSTConnection userDevice:willFollow:user");
}

// pegar os seguidores de um user dado
-(NSArray*)getFollowersFromUser:(YSTUser*)user withError:(NSError*)error {
    return nil;
}

// pegar seguidores do usuario do dispositivo
-(NSArray*)getFollowersFromDeviseUserWithError:(NSError*)error{
    return nil;
}

// envia a lista de contatos do usuario do dispositivo e retorna os usuarios que sao do yst
-(NSArray*)verifyUserOfYST:(NSArray*)users withError:(NSError*)error{
    return nil;
}

-(NSData*)makePostRequest:(NSMutableURLRequest*)request post:(NSString*)post withError:(NSError*)error{
    [request setTimeoutInterval:20];
    
    // Encode the post string using NSASCIIStringEncoding and also the post string you need to send in NSData format.
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    // You need to send the actual length of your data. Calculate the length of the post string.
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    // set http method
    [request setHTTPMethod:@"POST"];
    // Set HTTP header field with length of the post data.
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    // Also set the Encoded value for HTTP header Field.
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    // Set the HTTPBody of the urlrequest with postData.
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    
    return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

-(NSString*)codeOfServer{
    return @"TRDFyluihijIt76UILUHgTYDeTSD7adokIUHplOU7tdRT&yojikbG7y9";
}

@end
