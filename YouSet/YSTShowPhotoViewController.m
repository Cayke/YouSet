//
//  YSTShowPhotoViewController.m
//  YouSet
//
//  Created by Cayke Prudente on 26/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTShowPhotoViewController.h"

@interface YSTShowPhotoViewController ()

@end

@implementation YSTShowPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imageView.image = _photo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
