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
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
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
    // perguntar o telefone
    YSTUser *u = [[YSTUser alloc]init];
    u.phone = _inputCell.text;
    NSError *error = nil;
    u = [[YSTConnection sharedConnection]login:u withError:error];
    if (u) {
        // usuario existe
        [YSTUser sharedUser].phone = u.phone;
        [YSTUser sharedUser].name = u.name;
        [YSTUser sharedUser].ID = u.ID;
        [[YSTUser sharedUser] save];
        
        [_appDelegate normalInitializateOfYouSet];
        
    } else {
        // usuario nao existe
        YSTRegisterNewViewController *registerVC = [[YSTRegisterNewViewController alloc]init];
        registerVC.phone = _inputCell.text;
        registerVC.login = self;
        [self.navigationController pushViewController:registerVC animated:YES];
    }
}

- (IBAction)choiceCountry:(id)sender {
    YSTChoiceCountryViewController *choiceCountry = [[YSTChoiceCountryViewController alloc]init];
    choiceCountry.loginVC = self;
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


@end
