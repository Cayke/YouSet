//
//  YSTConnection.m
//  YouSet
//
//  Created by Riheldo Santos on 14/8/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTConnection.h"
#import "CPStub.h"
#import "YSTToDoStore.h"
#import "YSTContact.h"

@implementation YSTConnection

-(id)init{
    @throw [NSException exceptionWithName:@"YSTConnection init erro, isso é um singleton" reason:@"use sharedConnection" userInfo:nil];
    
    return nil;
}

-(id)initPrivate{
    self = [super init];
    
    if (self) {
        _site = @"http://107.170.189.125/youset/app/";
        // apagar para distribuicao, deixar para teste no mac do riheldo
        //_site = @"http://127.0.0.1:8000/youset/app/";
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
    
    todo.serverOk = 0;
    
    // preparar o todo para ser enviado para o servidor
    NSString *post = [NSString stringWithFormat:@"&code=%@",[self codeOfServer]];
    post = [post stringByAppendingString:[todo getDescriptionToPost]];
    
    // criar o request
    NSURL *url = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"updateTodo"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    
    // comecar assyncrono
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // fazer algum request para o servidor
        NSError *error = nil;
        NSData *dataFromConnection = [self makePostRequest:request post:post withError:error];
        
        
        //This is your completion handler
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (!error) {
                // nao deu erro e o server retornou alguma coisa, completar a tarefa
                
                NSError *error2 = nil;
                NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:&error2];
                
                if ([[a objectForKey:@"connectionStatus"]isEqualToString:@"ok"]) {
                    // retornou uma mensagem de ok, quando o todo eh atualizado
                    todo.serverOk = 1;
                } else if ([[a objectForKey:@"connectionStatus"]isEqualToString:@"error"]) {
                    // retornou erro
                    NSLog(@"Erro no servidor");
                    @throw [NSException exceptionWithName:@"Server Error" reason:@"This happens when something stranger happen on server" userInfo:nil];
                } else {
                    // retornou o json que contem o id do todo e os ids do assign
                    todo.ID = [[a objectForKey:@"todoId"]intValue];
                    todo.serverOk = 1;
                    
                    // colocar ids nos assigns
                    for (YSTAssignee *assi in todo.assignee) {
                        [assi setIdFromArrayOfServer:[a objectForKey:@"tasks"]];
                    }
                    
                    // mandar outros todos para o server, se houver
                    YSTToDo *nextTodo = [[YSTToDoStore sharedToDoStore]nextTodoOnLine];
                    if (nextTodo) {
                        [self updateTodo:nextTodo];
                    }
                }
            } else {
                NSLog(@"something goes wrong");
                // colocar todo na fila de todos para serem envidos ao servidor
                todo.serverOk = 0;
            }
        });
    });

}

// login do usuario, cria o usuario, ou retorna os todos do usuario caso o usuario exista
-(YSTUser*)login:(YSTUser*)user withError:(NSError*)error {
    // definir url da area de login
    NSURL *url = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"login"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    ////// variaveis em post
    // setar post string
    NSString *post = [NSString stringWithFormat:@"&code=%@", [self codeOfServer]];
    post = [post stringByAppendingString:[user getDescriptionToPost]];
    
    NSData *dataFromConnection = [self makePostRequest:request post: post withError:error];
    
    if (!error && dataFromConnection) {
        
        NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:&error];
        if (!error) {
            if ([[a objectForKey:@"userStatus"]isEqualToString:@"notFounded"]) {
                return nil;
            } else {
                [user setUserFromServer:a];
                return user;
            }
        }
    }
    
    return nil;
}

// vai fazer uma requisicao dos todos do usuario passado
-(NSArray*)getTodosFromUser:(YSTUser*)user withError:(NSError*)error {
    // definir url da area de login
    NSURL *url = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"getTodosFromUser"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    ////// variaveis em post
    // setar post string
    NSString *post = [NSString stringWithFormat:@"&code=%@", [self codeOfServer]];
    post = [post stringByAppendingString:[user getDescriptionToPost]];
    
    NSData *dataFromConnection = [self makePostRequest:request post: post withError:error];
    
    if (!error && dataFromConnection) {
        
        NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:&error];
        if (!error) {
            NSMutableArray *todos = [[NSMutableArray alloc]init];
            YSTToDo *newTodo = nil;
            for (NSDictionary *d in a) {
                newTodo = [[YSTToDo alloc]init];
                [newTodo setFromServer:d];
                [todos addObject:newTodo];
            }
            return [NSArray arrayWithArray:todos];
        }
    }
    
    return nil;
}

// o usuario do yst vai seguir ou deixar de seguir certo usuario
-(void)userDevice:(YSTUser*)mainUser willFollow:(BOOL)follow user:(YSTUser*)user { // assyncrono
    NSLog(@"[YSTConnection userDevice:willFollow:user");
}

// pegar os seguidores de um user dado
-(NSArray*)getFollowersFromUser:(YSTUser*)user withError:(NSError*)error {
    // definir url da area de login
    NSURL *url = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"getFollowersFromUser"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    ////// variaveis em post
    // setar post string
    NSString *post = [NSString stringWithFormat:@"&code=%@", [self codeOfServer]];
    post = [post stringByAppendingString:[user getDescriptionToPost]];
    
    NSData *dataFromConnection = [self makePostRequest:request post: post withError:error];
    
    if (!error && dataFromConnection) {
        
        NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:&error];
        if (!error) {
            NSMutableArray *todos = [[NSMutableArray alloc]init];
            YSTToDo *newTodo = nil;
            for (NSDictionary *d in a) {
                newTodo = [[YSTToDo alloc]init];
                [newTodo setFromServer:d];
                [todos addObject:newTodo];
            }
            return [NSArray arrayWithArray:todos];
        }
    }
    
    return nil;
}

// pegar seguidores do usuario do dispositivo
-(NSArray*)getFollowersFromDeviseUserWithError:(NSError*)error{
    return [self getFollowersFromUser:[YSTUser sharedUser] withError:error];
}

// envia a lista de contatos do usuario do dispositivo e retorna os usuarios que sao do yst
-(NSArray*)verifyUserOfYST:(NSArray*)contacts withError:(NSError*)error{
    // definir url da area de login
    NSURL *url = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"verifyUsersOfYST"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    NSString *phones = @"";
    for (YSTContact *c in contacts) {
        phones = [phones stringByAppendingString:[c getPostDescription]];
    }
    
    ////// variaveis em post
    // setar post string
    NSString *post = [NSString stringWithFormat:@"&code=%@", [self codeOfServer]];
    post = [post stringByAppendingFormat:@"&phones=%@",phones];
    
    NSData *dataFromConnection = [self makePostRequest:request post: post withError:error];
    
    if (!error && dataFromConnection) {
        
        NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:&error];
        if (!error) {
            YSTUser *user = nil;
            NSMutableArray *users = [[NSMutableArray alloc]init];
            for (NSDictionary *d in a) {
                user = [[YSTUser alloc]init];
                [user setUserFromServer:d];
                [users addObject:user];
            }
            
            return [NSArray arrayWithArray:users];
        }
    }
    
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
    return @"TRDFyluihijIt76UILUHgTYDeTSD7adokIUHplOU7tdRTyojikbG7y9";
}

@end
