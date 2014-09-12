//
//  YSTRegisterNewViewController.m
//  YouSet
//
//  Created by Cayke on 27/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTRegisterNewViewController.h"
#import "YSTUser.h"
#import "YSTConnection.h"

@interface YSTRegisterNewViewController ()

@end

@implementation YSTRegisterNewViewController

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
    self.inputName.backgroundColor = [UIColor whiteColor];
    self.inputName.layer.cornerRadius = 2;
    self.inputName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputName.rightViewMode = UITextFieldViewModeUnlessEditing;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    paddingView.backgroundColor = [UIColor clearColor];
    self.inputName.leftView = paddingView;
    self.inputName.leftViewMode = UITextFieldViewModeAlways;
    
    self.labelPhone.text = NSLocalizedString(@"Telefone", nil);
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
    
    newUser = [[YSTConnection sharedConnection]login:newUser withError:&error];
    
    if (newUser) {
        [YSTUser sharedUser].ID = newUser.ID;
        [YSTUser sharedUser].phone = newUser.phone;
        [YSTUser sharedUser].name = newUser.name;
        [YSTUser sharedUser].photo = newUser.photo;
        [[YSTUser sharedUser] save];
        [_login.appDelegate normalInitializateOfYouSet];
    }
    else if (error)
    {
        //criar alerta
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:
                           NSLocalizedString(@"Erro de conexāo", nil)
                                                     message:NSLocalizedString(@"Nāo foi possível conectar ao servidor. Confira sua conexāo de internet.", nil) delegate:self
                                           cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [av show];
    }
    else
    {
        UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Erro" message:@"Tente novamente mais tarde" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles: nil];
        [alerta show];
    }
}
@end
