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
                // First time access has been granted
                [_carregando setColor:[UIColor blueColor]];
                [_carregando startAnimating];
                _carregando.hidesWhenStopped = YES;
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //Call your function or whatever work that needs to be done
                    //Code in this part is run on a background thread
                    [self startContacts];
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        //Stop your activity indicator or anything else with the GUI
                        //Code here is run on the main thread
                        [_carregando stopAnimating];
                        [_tableView reloadData];
                    });
                });

            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Atenção", nil) message:NSLocalizedString(@"O aplicativo precisa da permissão. Não funcionará corretamente. Libere nos ajustes.", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alerta show];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access
        [_carregando setColor:[UIColor blueColor]];
        [_carregando startAnimating];
        _carregando.hidesWhenStopped = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Call your function or whatever work that needs to be done
            //Code in this part is run on a background thread
            [self startContacts];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //Stop your activity indicator or anything else with the GUI
                //Code here is run on the main thread
                [_carregando stopAnimating];
                [_tableView reloadData];
            });
        });
        
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Atenção",nil) message:NSLocalizedString(@"O aplicativo precisa de permissão. Libere nos ajustes", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    searchBar.placeholder = NSLocalizedString(@"Procurar", nil);
    
    //tablebiew
    UINib *nib = [UINib nibWithNibName:@"YSTUserTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"YSTUserTableViewCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"YSTNonUserTableViewCell" bundle:nil];
    [_tableView registerNib:nib2 forCellReuseIdentifier:@"YSTNonUserTableViewCell"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    
}


-(void) startContacts
{
    ABRecordRef source = ABAddressBookCopyDefaultSource(_addressBook);
    
    NSArray *allContacts = (__bridge NSArray *) ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(_addressBook, source, kABPersonSortByFirstName); // pegando em ordem alfabetica
    
    [self createUsableContacts:allContacts];
    
    //ver quais contatos tem youset (chamar o server passando allContacts
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
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        if (indexPath.row < [_searchResultsUSERS count])
        {
            YSTUserTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"YSTUserTableViewCell"];
            YSTUser *user = [_searchResultsUSERS objectAtIndex:indexPath.row];
            cell.user = user;
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
            YSTUser *user = [_youSetContacts objectAtIndex:indexPath.row];
            cell.user = user;
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
    NSArray *array = [[YSTConnection sharedConnection]verifyUserOfYST:_allContacts withError:&error];
    _youSetContacts = [[NSMutableArray alloc]initWithArray:array];
    _nonYouSetContacts = [[NSMutableArray alloc]initWithArray:_allContacts];
    
//    if (error) {
//        //criar alerta
//        NSString *errorMsg;
//        
//        if ([[error domain] isEqualToString:NSURLErrorDomain]) {
//            switch ([error code]) {
//                case NSURLErrorCannotFindHost:
//                    errorMsg = NSLocalizedString(@"Cannot find specified host. Retype URL.", nil);
//                    break;
//                case NSURLErrorCannotConnectToHost:
//                    errorMsg = NSLocalizedString(@"Cannot connect to specified host. Server may be down.", nil);
//                    break;
//                case NSURLErrorNotConnectedToInternet:
//                    errorMsg = NSLocalizedString(@"Cannot connect to the internet. Service may not be available.", nil);
//                    break;
//                default:
//                    errorMsg = [error localizedDescription];
//                    break;
//            }
//        } else {
//            errorMsg = [error localizedDescription];
//        }
//        
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:
//                           NSLocalizedString(@"Erro de conexao", nil)
//                                                     message:errorMsg delegate:self
//                                           cancelButtonTitle:@"Cancelar" otherButtonTitles:nil];
//        [av show];
//
//    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView != self.searchDisplayController.searchResultsTableView)
    {
        NSString *sectionName;
        switch (section)
        {
            case 0:
                sectionName = NSLocalizedString(@"YouSet", nil);
                break;
            case 1:
                sectionName = NSLocalizedString(@"Contatos", nil);
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
            personVC.friendsVC = self.friendsVC;
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
            personVC.friendsVC = self.friendsVC;
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
