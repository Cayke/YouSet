//
//  YSTContact.h
//  YouSet
//
//  Created by Cayke Prudente on 21/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTContact : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *phones;

-(void) addPhone:(NSString *) phone withType:(NSString *) type;

-(NSString*)getPostDescription;

@end
