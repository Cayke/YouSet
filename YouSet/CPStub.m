//
//  CPStub.m
//  contacts
//
//  Created by Cayke Prudente on 13/08/14.
//  Copyright (c) 2014 Cayke. All rights reserved.
//

#import "CPStub.h"

@implementation CPStub

+(BOOL)isYouSetUser:(NSString *)phone
{
    if ([phone intValue]%2 == 0) {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
