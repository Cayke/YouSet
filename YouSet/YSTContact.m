//
//  YSTContact.m
//  YouSet
//
//  Created by Cayke Prudente on 21/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTContact.h"
#import "YSTPhone.h"
#import "YSTUser.h"

@implementation YSTContact

-(id)init
{
    _phones = [[NSMutableArray alloc]init];
    return self;
}

-(void) addPhone:(NSString *) phone withType:(NSString *) type
{
    YSTPhone *newPhone = [[YSTPhone alloc]init];
    newPhone.phone = phone;
    NSString *tipo = [[type componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet]invertedSet]] componentsJoinedByString:@""];
    newPhone.type = tipo;
    
    [self.phones addObject:newPhone];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@ phones: %@", self.name, self.phones];
}

-(NSString*)getJustNumbersOfPhone:(NSString*)phone{
    //usar predicado para transformar numero para apenas numeros
    return [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"1234567890"]invertedSet]] componentsJoinedByString:@""];
}

-(NSString *)getPostDescription{
    NSString *phones = @"";
    for (YSTPhone *p in _phones) {
        phones = [phones stringByAppendingFormat:@"p%@", [self getJustNumbersOfPhone:p.phone]];
    }
    return phones;
}

@end
