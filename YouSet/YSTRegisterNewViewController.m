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
    
    //criar botao na navigation para add foto
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addPhoto)];
    
    _labelPhone.text = _phone;
    self.inputName.backgroundColor = [UIColor whiteColor];
    self.inputName.layer.cornerRadius = 2;
    self.inputName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputName.rightViewMode = UITextFieldViewModeUnlessEditing;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    paddingView.backgroundColor = [UIColor clearColor];
    self.inputName.leftView = paddingView;
    self.inputName.leftViewMode = UITextFieldViewModeAlways;
    [self.btnCadastrar setTitle:NSLocalizedString(@"Cadastrar", nil) forState:UIControlStateNormal ];
    self.labelTelefone.text = NSLocalizedString(@"Telefone", nil);
    self.labelNome.text = NSLocalizedString(@"Nome", nil);
    //self.labelPhone.text = NSLocalizedString(@"Telefone", nil);
    
    
    //criar o espaco para foto
    //x = 80, y = 80 , size = 160
    CGRect frame = CGRectMake(80, 80, 160, 160);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: frame];
    imageView.layer.cornerRadius = imageView.bounds.size.width/2;
    imageView.clipsToBounds = YES;
    imageView.layer.masksToBounds = YES;
    imageView.backgroundColor = [UIColor whiteColor];

    
    //colocar image view como property da classe
    _viewOfImage = imageView;
    
    [self.view addSubview:imageView];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Tirar Foto", nil),NSLocalizedString(@"Escolher Existente", nil), nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    if (buttonIndex == 0) // tirar foto
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Ops" message:@"Seu device nao suporta esta opcao" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alerta show];
        }
    }
    else if (buttonIndex == 1)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    //habilita edicaoUIips
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imagem = info[UIImagePickerControllerEditedImage];
    
    self.viewOfImage.image = imagem;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_inputName resignFirstResponder];
}

- (IBAction)registerNEwUser:(id)sender {
    [self registerUser];
}

-(void) registerUser
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Call your function or whatever work that needs to be done
        
        //Code in this part is run on a background thread
        YSTUser *newUser = [[YSTUser alloc]init];
        newUser.name = _inputName.text;
        newUser.phone = _phone;
        
        NSError *error = nil;
        
        newUser = [[YSTConnection sharedConnection]login:newUser withError:&error];
        [[YSTConnection sharedConnection]uploadPhoto:_viewOfImage.image ofUser:newUser withError:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            //Stop your activity indicator or anything else with the GUI
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //Code here is run on the main thread
            
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
                UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Erro",nil) message:NSLocalizedString(@"Parece que o campo nome está em branco, digite seu nome por favor", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar",nil) otherButtonTitles: nil];
                [alerta show];
            }
            
            
        });
        
    });
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self registerUser];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.30 animations:^{
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            self.view.frame = CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height);
        } else {
            self.view.frame = CGRectMake(0, -120, self.view.frame.size.width, self.view.frame.size.height);
        }
        
        
    }];
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
