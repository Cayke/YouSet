//
//  YSTLoginViewController.m
//  YouSet
//
//  Created by Riheldo Melo Santos on 20/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTLoginViewController.h"
#import "YSTUser.h"
#import "YSTChoiceCountryViewController.h"
#import "YSTConnection.h"
#import "YSTRegisterNewViewController.h"
#import "YSTToDoStore.h"

@interface YSTLoginViewController ()
@property (nonatomic) BOOL canEdit;
@end

@implementation YSTLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Entrar", nil);
        self.canEdit =YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIColor *blueColor = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [ UIColor whiteColor]}];
    self.inputCell.delegate = self;
    self.inputCell.backgroundColor = [UIColor whiteColor];
    self.inputCell.layer.cornerRadius = 2;
    self.inputCell.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputCell.rightViewMode = UITextFieldViewModeUnlessEditing;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    paddingView.backgroundColor = [UIColor clearColor];
    self.inputCell.leftView = paddingView;
    self.inputCell.leftViewMode = UITextFieldViewModeAlways;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = blueColor;
    self.view.backgroundColor = blueColor;
    
    
    self.title = NSLocalizedString(@"YouSet", nil);
    [self.btnCadastrar setTitle:NSLocalizedString(@"Cadastrar", nil) forState:UIControlStateNormal ];
    [self.btnCountry setTitle:NSLocalizedString(@"País", nil) forState:UIControlStateNormal];
    self.btnCountry.titleLabel.text = NSLocalizedString(@"País", nil);
    self.inputCell.placeholder = NSLocalizedString(@"Telefone", nil);


    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_inputCell resignFirstResponder];
}

- (IBAction)cadastrar:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Call your function or whatever work that needs to be done
        
        //Code in this part is run on a background thread
        // perguntar o telefone
        YSTUser *u = [[YSTUser alloc]init];
        u.phone = _inputCell.text;
        NSError *error = nil;
        u = [[YSTConnection sharedConnection]login:u withError:&error];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            //Stop your activity indicator or anything else with the GUI
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //Code here is run on the main thread
            if (u) {
                // usuario existe
                [YSTUser sharedUser].phone = u.phone;
                [YSTUser sharedUser].name = u.name;
                [YSTUser sharedUser].ID = u.ID;
                [[YSTUser sharedUser] save];
                
                [_appDelegate normalInitializateOfYouSet];
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
            else {
                // usuario nao existe
                YSTRegisterNewViewController *registerVC = [[YSTRegisterNewViewController alloc]init];
                registerVC.phone = _inputCell.text;
                registerVC.login = self;
                [self.navigationController pushViewController:registerVC animated:YES];
            }

            
            
        });
        
    });
}

- (IBAction)choiceCountry:(id)sender {
    YSTChoiceCountryViewController *choiceCountry = [[YSTChoiceCountryViewController alloc]init];
    choiceCountry.loginVC = self;
    self.canEdit = NO;
    [self.navigationController pushViewController:choiceCountry animated:YES];
}

-(void)userHasBeenLogedIn{
    [self.appDelegate normalInitializateOfYouSet];
}

-(void)countryHasBeenChoosen:(NSDictionary *)country{
    [_btnCountry setTitle:[country objectForKey:@"pais"] forState:UIControlStateNormal];
    _country = country;
    _inputCell.text = [[country objectForKey:@"code"] stringByAppendingString:@" ("];
    [_inputCell becomeFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSString *code = [self.country objectForKey:@"code"];
    if (code) {
        if (!self.canEdit) {
            self.canEdit = YES;
            return NO;
        }
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _inputCell) {
        
        if(![string isEqualToString:@""]) {
            if ([textField.text length] == 0) {
                textField.text = [textField.text stringByAppendingString:@"+"];
                
            } else if([textField.text length] == 3){
                textField.text = [textField.text stringByAppendingString:@" ("];
                
            } else if ([textField.text length] == 7) {
                textField.text = [textField.text stringByAppendingString:@") "];
                
            } else if ([textField.text length] == 13) {
                textField.text = [textField.text stringByAppendingString:@"-"];
                
            }
        } else {
            return YES;
        }
        if ([textField.text length]>18) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.30 animations:^{
        self.view.frame = CGRectMake(0, -200, self.view.frame.size.width, self.view.frame.size.height);
    }];
    NSString *code = [self.country objectForKey:@"code"];
    self.inputCell.text = code;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.30 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    [textField resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{

}



@end
