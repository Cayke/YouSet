//
//  YSTImage.h
//  YouSet
//
//  Created by Riheldo Melo Santos on 28/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSTImage : NSObject

@property (nonatomic, readonly) NSString *pathToImages;

-(void)setImageNamed:(NSString*)imageName toUIImageView:(UIImageView*)imageView andActivivyIndicator:(UIActivityIndicatorView*)activityIndicator;

@end
