//
//  YSTContactsViewController.m
//  YouSet
//
//  Created by Willian Pinho on 8/8/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTContactsViewController.h"
#import "YSTFriendToDosViewController.h"
#import "CPStub.h"
#import "YSTContact.h"
#import "YSTPhone.h"
#import "YSTInviteViewController.h"
#import "YSTConnection.h"
#import "YSTUserTableViewCell.h"
#import "YSTConnection.h"
#import "YSTNonUserTableViewCell.h"


@interface YSTContactsViewController ()

@property (nonatomic) NSArray *searchResultsUSERS;
@property (nonatomic) NSArray *searchResultsNonUSERS;

@end

@implementation YSTContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _allContacts = [[NSMutableArray alloc]init];
        _youSetContacts = [[NSMutableArray alloc]init];
        _nonYouSetContacts = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    
    //colocar a searchbar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [searchBar sizeToFit];
    [searchBar setDelegate:self];
    
    [self setSearchController:[[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                                contentsController:self]];
    [self.searchController setSearchResultsDataSource:self];
    [self.searchController setSearchResultsDelegate:self];
    [self.searchController setDelegate:self];
    
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    //tablebiew
    UINib *nib = [UINib nibWithNibName:@"YSTUserTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"YSTUserTableViewCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"YSTNonUserTableViewCell" bundle:nil];
    [_tableView registerNib:nib2 forCellReuseIdentifier:@"YSTNonUserTableViewCell"];
    
}



-(void) startContacts
{
    ABRecordRef source = ABAddressBookCopyDefaultSource(_addressBook);
    
    NSArray *allContacts = (__bridge NSArray *) ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(_addressBook, source, kABPersonSortByFirstName); // pegando em ordem alfabetica
    
    [self createUsableContacts:allContacts];
    
    //ver quais contatos tem youset (chamar o server passando allContacts
    // NSError *error;
    //[[YSTConnection sharedConnection]verifyUserOfYST:_allContacts withError:error];
    [self usersOfYoutSet];
}

-(void) createUsableContacts:(NSArray *) arrayAddressBook
{
    for (int i = 0; i<[arrayAddressBook count]; i++) {
        //criar contato usavel
        YSTContact *contact = [[YSTContact alloc]init];
        
        //passar pessoa para id person
        ABRecordRef person = (__bridge ABRecordRef)[arrayAddressBook objectAtIndex:i];
        
        //pegar nome da pessoa
        contact.name = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        //pegar telefones
        ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (int j = 0; j < ABMultiValueGetCount(phonesRef); j++) {
            CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, j);
            CFStringRef currentTypeValue = ABMultiValueCopyLabelAtIndex(phonesRef, j);
            
            [contact addPhone:(__bridge NSString *)(currentPhoneValue) withType:(__bridge NSString *)(currentTypeValue)];
        }
        
        [_allContacts addObject:contact];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [_searchResultsUSERS count] + [_searchResultsNonUSERS count];
    }
    else
    {
        if (section == 0)
        {
            return [_youSetContacts count];
        }
        else if(section == 1)
        {
            return [_nonYouSetContacts count];
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"temp"];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (indexPath.row < [_searchResultsUSERS count]) {
            YSTUserTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"YSTUserTableViewCell"];
            YSTContact *contact = [_searchResultsUSERS objectAtIndex:indexPath.row];
            cell.name = contact.name;
            [cell mount];
            return cell;
        }
        else
        {
            YSTNonUserTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"YSTNonUserTableViewCell"];
            YSTContact *contact = [_searchResultsNonUSERS objectAtIndex:indexPath.row - [_searchResultsUSERS count]];
            cell.name = contact.name;
            [cell mount];
            return cell;
        }
    }
    else
    {
        
        if (indexPath.section == 0)
        {
            YSTUserTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"YSTUserTableViewCell"];
            YSTContact *contact = [_youSetContacts objectAtIndex:indexPath.row];
            cell.name = contact.name;
            [cell mount];
            return cell;
        }
        else
        {
            YSTNonUserTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"YSTNonUserTableViewCell"];
            YSTContact *contact = [_nonYouSetContacts objectAtIndex:indexPath.row];
            cell.name = contact.name;
            [cell mount];
            return cell;
        }
    }
    
}

-(void)usersOfYoutSet
{
    NSError *error = nil;
    [[YSTConnection sharedConnection]verifyUserOfYST:_allContacts withError:error];
    for (int i = 0; i < [_allContacts count]; i++)
    {
        //pegar pessoa
        YSTContact *contact = [_allContacts objectAtIndex:i];
        BOOL isMember = NO;
        
        //pegar telefones
        for (int j=0; j < [contact.phones count]; j++)
        {
            YSTPhone *phone = [contact.phones objectAtIndex:j];
            NSString *numeroString = phone.phone;
            
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
    if(tableView != self.searchDisplayController.searchResultsTableView)
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
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (indexPath.row < [_searchResultsUSERS count]) {
            YSTFriendToDosViewController *personVC = [[YSTFriendToDosViewController alloc]init];
            personVC.user = [_searchResultsUSERS objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:personVC animated:YES];
        }
        else
        {
            YSTContact *contact = [_searchResultsNonUSERS objectAtIndex:indexPath.row - [_searchResultsUSERS count]];
            YSTInviteViewController *invite = [[YSTInviteViewController alloc]init];
            invite.contact = contact;
            [self.navigationController pushViewController:invite animated:YES];
        }
    }
    else
    {
        if (indexPath.section == 0) //se for youset abre a tela da pessoa
        {
            YSTFriendToDosViewController *personVC = [[YSTFriendToDosViewController alloc]init];
            personVC.user = [_youSetContacts objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:personVC animated:YES];
        }
        else if (indexPath.section == 1) //se nao for do youset abre tela com numeros da pessoa e se quer chamar pro app
        {
            //abrir nova tela com as info do contato clicado
            YSTContact *contact = [_nonYouSetContacts objectAtIndex:indexPath.row];
            YSTInviteViewController *invite = [[YSTInviteViewController alloc]init];
            invite.contact = contact;
            [self.navigationController pushViewController:invite animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", searchText];
    
    _searchResultsUSERS = [_youSetContacts filteredArrayUsingPredicate:resultPredicate];
    
    _searchResultsNonUSERS = [_nonYouSetContacts filteredArrayUsingPredicate:resultPredicate];
    
    [self.tableView reloadData];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    
    return YES;
}


@end
