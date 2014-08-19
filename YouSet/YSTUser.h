//
//  YSTUser.h
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTUser : NSObject

@property (atomic) int ID;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *photo;

@property (nonatomic) NSDictionary *following;
@property (nonatomic) NSDictionary *followers;

// verifica se o usuario esta logado
@property (nonatomic) BOOL logedin;

// caminho para inormacoes do usuario
@property (nonatomic) NSString *path;

+(YSTUser*)sharedUser;

@end
