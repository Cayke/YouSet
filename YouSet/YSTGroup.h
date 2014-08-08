//
//  YSTGroup.h
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YSTGroup : NSObject

@property (nonatomic) int idGroup;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *photo;
@property (nonatomic) NSDate *dateCreated;
@property (nonatomic) NSArray *members;
@property (nonatomic) NSArray *toDos;

@end
