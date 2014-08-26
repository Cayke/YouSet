//
//  YSTRegisterViewController.m
//  YouSet
//
//  Created by Riheldo Melo Santos on 26/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTRegisterViewController.h"
#import "YSTConnection.h"
#import "YSTUser.h"

@interface YSTRegisterViewController ()

@end

@implementation YSTRegisterViewController

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
    
    _labelPhone.text = _phone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_inputName resignFirstResponder];
}

- (IBAction)registerNEwUser:(id)sender {
    YSTUser *newUser = [[YSTUser alloc]init];
    newUser.name = _inputName.text;
    newUser.phone = _phone;
    
    NSError *error = nil;
    
    newUser = [[YSTConnection sharedConnection]login:newUser withError:error];
    
    if (newUser) {
        [YSTUser sharedUser].phone = newUser.phone;
        [YSTUser sharedUser].name = newUser.name;
        [[YSTUser sharedUser] save];
        [_login.appDelegate normalInitializateOfYouSet];
    }
}
@end
