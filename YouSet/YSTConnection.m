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
    todo.serverOk = 1;
    
    // preparar o todo para ser enviado para o servidor
    NSString *post = [NSString stringWithFormat:@"&code=%@",[self codeOfServer]];
    post = [post stringByAppendingString:[todo getDescriptionToPost]];
    
    // criar o request
    NSURL *url = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"updateTodo"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    NSLog(@"%@", post);
    
    
    // comecar assyncrono
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // fazer algum request para o servidor
        NSError *error = nil;
        NSData *dataFromConnection = [self makePostRequest:request post:post withError:&error];
        
        
        //This is your completion handler
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (!error && dataFromConnection) {
                // nao deu erro e o server retornou alguma coisa, completar a tarefa
                
                NSError *error2 = nil;
                NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:&error2];
                
                if ([[a objectForKey:@"connectionStatus"]isEqualToString:@"ok"]) {
                    // retornou uma mensagem de ok, quando o todo eh atualizado
                    todo.serverOk = 2;
                } else if ([[a objectForKey:@"connectionStatus"]isEqualToString:@"error"]) {
                    // retornou erro
                    NSLog(@"Erro no servidor");
                    @throw [NSException exceptionWithName:@"Server Error" reason:@"This happens when something stranger happen on server" userInfo:nil];
                } else {
                    // retornou o json que contem o id do todo e os ids do assign
                    todo.ID = [[a objectForKey:@"todoId"]intValue];
                    todo.serverOk = 2;
                    
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
-(YSTUser*)login:(YSTUser*)user withError:(NSError**)error {
    // definir url da area de login
    NSURL *url = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"login"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    ////// variaveis em post
    // setar post string
    NSString *post = [NSString stringWithFormat:@"&code=%@", [self codeOfServer]];
    post = [post stringByAppendingString:[user getDescriptionToPost]];
    
    NSData *dataFromConnection = [self makePostRequest:request post: post withError:error];
    
    if (!*error && dataFromConnection) {
        
        NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:error];
        if (!*error) {
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
-(NSArray*)getTodosFromUser:(YSTUser*)user withError:(NSError**)error {
    // definir url da area de login
    NSURL *url = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"getTodosFromUser"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    ////// variaveis em post
    // setar post string
    NSString *post = [NSString stringWithFormat:@"&code=%@&userOwnerId=%d", [self codeOfServer], [YSTUser sharedUser].ID];
    post = [post stringByAppendingString:[user getDescriptionToPost]];
    
    NSData *dataFromConnection = [self makePostRequest:request post: post withError:error];
    
    if (!*error && dataFromConnection) {
        NSError *error2 = nil;
        NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:&error2];
        if (!error2) {
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
    // definir url da area de login
    NSURL *url = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"mainUserFollowUser"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    ////// variaveis em post
    // setar post string
    NSString *post = [NSString stringWithFormat:@"&code=%@", [self codeOfServer]];
    post = [post stringByAppendingFormat:@"&mainUserId=%d&userToFollowId=%d",mainUser.ID,user.ID];
    
    
    // comecar assyncrono
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // fazer algum request para o servidor
        NSError *error = nil;
        NSData *dataFromConnection = [self makePostRequest:request post: post withError:&error];
        
        
        //This is your completion handler
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (!error) {
                // nao deu erro e o server retornou alguma coisa, completar a tarefa
                NSString *message = [[NSString alloc]initWithData:dataFromConnection encoding:NSUTF8StringEncoding];
                
                if ([message isEqualToString:@"ok"]) {
                    NSLog(@"esta seguindo");
                } else {
                    NSLog(@"Nao esta seguindo");
                }
                
            } else {
                NSLog(@"something goes wrong to follow user");
                // colocar todo na fila de todos para serem envidos ao servidor
            }
        });
    });
}

// pegar os seguidores de um user dado
-(NSArray*)getFollowersFromUser:(YSTUser*)user withError:(NSError**)error {
    // definir url da area de login
    NSURL *url = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"getFollowersFromUser"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    ////// variaveis em post
    // setar post string
    NSString *post = [NSString stringWithFormat:@"&code=%@", [self codeOfServer]];
    post = [post stringByAppendingString:[user getDescriptionToPost]];
    
    NSData *dataFromConnection = [self makePostRequest:request post: post withError:error];
    
    if (!*error && dataFromConnection) {
        NSError *error2;
        NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:&error2];
        if (!error2) {
            if ([a count]) {
                NSMutableArray *users = [[NSMutableArray alloc]init];
                YSTUser *user = nil;
                for (NSDictionary *d in a) {
                    user = [[YSTUser alloc]init];
                    [user setUserFromServer:d];
                    user.phone = [d objectForKey:@"phone"];
                    [users addObject:user];
                }
                return [NSArray arrayWithArray:users];
            }
        }
    }
    
    return nil;
}

// pegar seguidores do usuario do dispositivo
-(NSArray*)getFollowersFromDeviseUserWithError:(NSError**)error{
    return [self getFollowersFromUser:[YSTUser sharedUser] withError:error];
}

// envia a lista de contatos do usuario do dispositivo e retorna os usuarios que sao do yst
-(NSArray*)verifyUserOfYST:(NSArray*)contacts withError:(NSError**)error{
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
    
    if (!*error && dataFromConnection) {
        NSError *error2= nil;
        NSDictionary *a = [NSJSONSerialization JSONObjectWithData:dataFromConnection options:0 error:&error2];
        if (!error2) {
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

-(void)uploadPhoto:(UIImage *)image ofUser:(YSTUser *)user withError:(NSError**)error{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---boundry_of_YouSetPicture---pqo";
    // header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                stringBoundary];
    
    // set header
    [request addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    //codigo para acessar a funcao no webserver
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"code\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[self codeOfServer] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //client id
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"userID\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%d", user.ID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //image
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"youset_item_image\"; filename=\"item.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // get the image data from main bundle directly into NSData object
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    // add it to body
    [body appendData:imgData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"message added");
    // final boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add body to post
    [request setHTTPBody:body];
    
    // set URL
    NSURL *requestURL = [[NSURL alloc]initWithString: [_site stringByAppendingString:@"image"]];
    [request setURL:requestURL];
    
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
}



-(NSData*)makePostRequest:(NSMutableURLRequest*)request post:(NSString*)post withError:(NSError**)error{
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
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    
    return data;
}


-(NSString*)codeOfServer{
    return @"TRDFyluihijIt76UILUHgTYDeTSD7adokIUHplOU7tdRTyojikbG7y9";
}

@end
