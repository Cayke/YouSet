//
//  YSTContact.m
//  YouSet
//
//  Created by Cayke Prudente on 21/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTContact.h"
#import "YSTPhone.h"

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
    newPhone.type = type;
    
    [self.phones addObject:newPhone];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@ phones: %@", self.name, self.phones];
}


@end
