//
//  YSTInviteViewController.m
//  YouSet
//
//  Created by Cayke Prudente on 22/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTInviteViewController.h"
#import "YSTPhone.h"

@interface YSTInviteViewController ()

@property (nonatomic) NSMutableArray *arrayPhoneNumbers ;

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
    _arrayPhoneNumbers = [[NSMutableArray alloc]init];
    
    self.title = [NSString stringWithFormat:@"%@", _contact.name];
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
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
    YSTPhone *phone = [_contact.phones objectAtIndex:indexPath.row];
    
    cell.textLabel.text = phone.phone;
    }
    else
    {
        cell.textLabel.text = @"Invite to YouSet";
        cell.textLabel.textColor = [UIColor greenColor];
    }
    
    
    return cell;

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
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Seu device nao suporta SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[number];
    NSString *message = [NSString stringWithFormat:@"Acabei de baixar um app chamado YouSet, sensacional hahaha. Baixe agora para usarmos juntos. Segue o link www.youset.com.br/download"];
    
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    for (YSTPhone *phone in _contact.phones) {
        [actionSheet addButtonWithTitle:phone.phone];
        [_arrayPhoneNumbers addObject:phone.phone];
    }
    [actionSheet addButtonWithTitle:@"Cancelar"];
    actionSheet.cancelButtonIndex = [_arrayPhoneNumbers count];
    [actionSheet showInView:self.view];
}

@end
