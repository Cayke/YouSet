//
//  YSTLoginViewController.m
//  YouSet
//
//  Created by Riheldo Melo Santos on 20/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTLoginViewController.h"
#import "YSTUser.h"

@interface YSTLoginViewController ()

@end

@implementation YSTLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Login";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cadastrar:(id)sender {
    [YSTUser sharedUser].logedin = true;
    [self userHasBeenLogedIn];
}

-(void)userHasBeenLogedIn{
    [self.appDelegate normalInitializateOfYouSet];
}

@end
