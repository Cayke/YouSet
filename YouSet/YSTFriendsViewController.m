//
//  YSTFriendsViewController.m
//  YouSet
//
//  Created by Cayke Prudente on 18/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTFriendsViewController.h"
#import "YSTContactsViewController.h"

@interface YSTFriendsViewController ()

@end

@implementation YSTFriendsViewController

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
    
    self.title = @"Amigos";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addContact
{
    YSTContactsViewController *contacts = [[YSTContactsViewController alloc]init];
    [self.navigationController pushViewController:contacts animated:YES];
    
}
@end
