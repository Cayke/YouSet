//
//  YSTContactsViewController.m
//  YouSet
//
//  Created by Willian Pinho on 8/8/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTContactsViewController.h"
#import "CPStub.h"

@interface YSTContactsViewController ()

@end

@implementation YSTContactsViewController

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
    
    // Custom initialization
    //_haveAccess = NO;
    _youSetContacts = [[NSMutableArray alloc]init];
    _nonYouSetContacts = [[NSMutableArray alloc]init];
    
    // Request authorization to Address Book
    _addressBook = ABAddressBookCreateWithOptions(nil, nil);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self startContacts];
                [_tableView reloadData];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Atenção" message:@"O aplicativo precisa da permissao. Nao funcionara corretamente. Libere nos ajustes." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alerta show];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self startContacts];
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Atenção" message:@"O aplicativo precisa de permissao. Libere nos ajustes" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alerta show];
    }
    
}



-(void) startContacts
{
    ABRecordRef source = ABAddressBookCopyDefaultSource(_addressBook);
    
    _allContacts = (__bridge NSArray *) ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(_addressBook, source, kABPersonSortByFirstName); // pegando em ordem alfabetica
    
    
    //ver quais contatos tem youset
    [self usersOfYoutSet];
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
    if (section == 0) {
        return [_youSetContacts count];
    }
    else if(section == 1) {
        return [_nonYouSetContacts count];
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"temp"];
    
    if (indexPath.section == 0)
    {
        //passar pessoa para id person
        ABRecordRef person = (__bridge ABRecordRef)([_youSetContacts objectAtIndex:indexPath.row]);
        
        cell.textLabel.text = (__bridge NSString *) ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        //        //pegar telefones
        //        ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
        //
        //        for (int i=0; i < ABMultiValueGetCount(phonesRef); i++)
        //        {
        //            CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        //            NSString *numeroString = (__bridge NSString *)(currentPhoneValue);
        //
        //
        //               NSLog(@"%@", numeroString);
        //           }
    }
    else
    {
        //passar pessoa para id person
        ABRecordRef person = (__bridge ABRecordRef)([_nonYouSetContacts objectAtIndex:indexPath.row]);
        
        cell.textLabel.text = (__bridge NSString *) ABRecordCopyValue(person, kABPersonFirstNameProperty);
    }
    
    return cell;
}

-(void)usersOfYoutSet
{
    for (int i = 0; i < [_allContacts count]; i++)
    {
        //pegar pessoa
        ABRecordRef person = (__bridge ABRecordRef)[_allContacts objectAtIndex:i];
        BOOL isMember = NO;
        
        //pegar telefones
        ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (int j=0; j < ABMultiValueGetCount(phonesRef); j++)
        {
            CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, j);
            NSString *numeroString = (__bridge NSString *)(currentPhoneValue);
            
            //usar predicado para transformar numero para apenas numeros
            NSString *numeros = [[numeroString componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"1234567890"]invertedSet]] componentsJoinedByString:@""];
            
            //perguntar para server se e usuario YouSet
            BOOL isUSer = [CPStub isYouSetUser:numeros];
            
            //se for poe contato no arrayUsuarios e sai do for
            if (isUSer) {
                [_youSetContacts addObject:[_allContacts objectAtIndex:i]];
                isMember = YES;
                break;
            }
            
            
        }
        if (!isMember)
        {
            //por no arrayNotUser
            [_nonYouSetContacts addObject:[_allContacts objectAtIndex:i]];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    {
        NSString *sectionName;
        switch (section)
        {
            case 0:
                sectionName = @"YouSet";
                break;
            case 1:
                sectionName = @"Contacts";
                break;
            default:
                sectionName = @"";
                break;
        }
        return sectionName;
    }
}

@end
