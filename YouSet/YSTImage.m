//
//  YSTImage.m
//  YouSet
//
//  Created by Riheldo Melo Santos on 28/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTImage.h"

@implementation YSTImage

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/SuperOnline/images", NSHomeDirectory()] withIntermediateDirectories:YES attributes:nil error:nil];
        _pathToImages = [NSString stringWithFormat:@"%@/Documents/SuperOnline/images",NSHomeDirectory()];
    }
    return self;
}

-(void)setImageNamed:(NSString *)imageName toUIImageView:(UIImageView *)imageView andActivivyIndicator:(UIActivityIndicatorView *)activityIndicator {
    // carregar imagem do celular
    // se nao achar a imagem no cel, procuarar no servidor e baixar
    
    
    [activityIndicator startAnimating];
    activityIndicator.hidesWhenStopped = YES;
    
    //comeca asyncrono
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       
                       // pegar imagem do celular
                       UIImage *image = [self getImageNamed:imageName];
                       
                       if (!image) {
                           // se a imagem nao existir
                           NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.134.10/default/download/%@", imageName]];
                           NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                           
                           if (imageData) {
                               NSLog(@"imagem salva no iphone");
                               image = [UIImage imageWithData:imageData];
                               
                               [self saveImage:imageData withName:imageName];
                           }
                       }
                       
                       //This is your completion handler
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           //If self.image is atomic (not declared with nonatomic)
                           // you could have set it directly above
                           
                           if (image) {
                               //This needs to be set here now that the image is downloaded
                               // and you are back on the main thread
                               [imageView setImage: image];
                               
                           } else {
                               [imageView setImage:[UIImage imageNamed:@"imageNotFound.png"]];
                           }
                           [activityIndicator stopAnimating];
                       });
                   });

}

// resolver imagem
// linha daqui pra baixo
-(UIImage *)getImageNamed:(NSString *)imageName {
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_pathToImages,imageName]];
    
    return image;
}

-(void)saveImage:(NSData *)dataImage withName:(NSString*)name{
    [dataImage writeToFile:[NSString stringWithFormat:@"%@/%@",_pathToImages,name] atomically:YES];
}

@end
