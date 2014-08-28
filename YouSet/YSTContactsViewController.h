//
//  YSTContactsViewController.h
//  YouSet
//
//  Created by Willian Pinho on 8/8/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "YSTFriendsViewController.h"


@interface YSTContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *carregando;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) YSTFriendsViewController *friendsVC;

@property(nonatomic) ABAddressBookRef addressBook;
@property(nonatomic) NSMutableArray *allContacts; //todos os contatos
@property(nonatomic) NSMutableArray *youSetContacts; //contato que possuem o YouSet
@property(nonatomic) NSMutableArray *nonYouSetContacts; //contatos que NAO possuem YS
//@property (nonatomic) BOOL haveAccess;

-(void) usersOfYoutSet;


@end
