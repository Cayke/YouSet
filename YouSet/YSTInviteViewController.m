//
//  YSTInviteViewController.m
//  YouSet
//
//  Created by Cayke Prudente on 22/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTInviteViewController.h"
#import "YSTPhone.h"
#import "YSTInviteTableViewCell.h"

@interface YSTInviteViewController ()

@end

@implementation YSTInviteViewController

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
    self.title = [NSString stringWithFormat:@"%@", _contact.name];
    
    UINib *nib = [UINib nibWithNibName:@"YSTInviteTableViewCell" bundle:nil];
    
    [_tableView registerNib:nib forCellReuseIdentifier:@"YSTInviteTableViewCell"];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return [_contact.phones count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
            YSTInviteTableViewCell *YSTCell = [_tableView dequeueReusableCellWithIdentifier:@"YSTInviteTableViewCell" forIndexPath:indexPath];
    YSTPhone *phone = [_contact.phones objectAtIndex:indexPath.row];
        
        YSTCell.type = phone.type;
        YSTCell.phone = phone.phone;
        [YSTCell mount];
        return YSTCell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hue"];
        cell.textLabel.text = NSLocalizedString(@"     Convidar para o YouSet", nil);
        
        // COR VERDE
        // R: 184
        // G: 233
        // B: 134
        //divisao padrao para encontrar o valor das cores rgb
        CGFloat divided = 255.0;
        
        //cores para fazer o verde
        CGFloat red = 38.0/divided;
        CGFloat green = 146.0/divided;
        CGFloat blue = 42.0/divided;
        UIColor *greenYST = [UIColor colorWithRed:red green:green blue:blue alpha:10.0];
        cell.textLabel.textColor = greenYST;
        
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        return cell;
        
    }
}

-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Nao foi possivel enviar SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSMS:(NSString*)number {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erro", nil) message:NSLocalizedString(@"Seu dispositivo nao suporta SMS!", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[number];
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Acabei de baixar um app chamado YouSet, sensacional hahaha. Baixe agora para usarmos juntos. Segue o link www.youset.com.br/download", nil)];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self showNormalActionSheet];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) showNormalActionSheet{
    int contador = 0;
    
     _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (YSTPhone *phone in _contact.phones) {
        [_actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@:%@", phone.type, phone.phone]];
        contador++;
    }
    
    [_actionSheet addButtonWithTitle:NSLocalizedString(@"Cancelar", nil)];
    _actionSheet.cancelButtonIndex = contador;
    [_actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [_actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else
    {
    YSTPhone *phone = [_contact.phones objectAtIndex:buttonIndex];
    NSString *number = phone.phone;
    
    [self showSMS:number];
    }
}

@end
