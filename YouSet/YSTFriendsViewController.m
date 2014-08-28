//
//  YSTFriendsViewController.m
//  YouSet
//
//  Created by Cayke Prudente on 18/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTFriendsViewController.h"
#import "YSTContactsViewController.h"
#import "YSTUser.h"
#import "YSTFriendTableViewCell.h"
#import "YSTFriendToDosViewController.h"
#import "YSTConnection.h"

@interface YSTFriendsViewController ()

@end

@implementation YSTFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _reloadFriendsInfo = NO;
        
//        _amigos = [[NSMutableArray alloc]init];
        //mudar para pegar amigos certo kkk
//        YSTUser *user = [[YSTUser alloc]init];
//        user.name = @"will";
//        user.ID = 1;
//        [_amigos addObject:user];
//        YSTUser *user2 = [[YSTUser alloc]init];
//        user2.name = @"Cayke";
//        user2.ID = 1;
//        [_amigos addObject:user2];
//        YSTUser *user3 = [[YSTUser alloc]init];
//        user3.name = @"Hiheldo";
//        user3.ID = 1;
//        [_amigos addObject:user3];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _amigos = [[YSTConnection sharedConnection] getFollowersFromDeviseUserWithError:nil];
    
    self.title = @"Amigos";
    
    UINib *nib = [UINib nibWithNibName:@"YSTFriendTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"YSTFriendTableViewCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    
    //ver se tem amigos ou esta vazio
    if (_amigos == nil) {
        UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Atencao" message:@"Voce ainda nao segue ninguem. Para seguir um amigo novo clique no botao + a cima" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alerta show];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if (_reloadFriendsInfo == YES) {
        [self reloadFriends];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) reloadFriends
{
     _amigos = [[YSTConnection sharedConnection] getFollowersFromDeviseUserWithError:nil];
    
    [_tableView reloadData];
    
    _reloadFriendsInfo = NO;
}

-(void) addContact
{

    YSTContactsViewController *contacts = [[YSTContactsViewController alloc]init];
    contacts.friendsVC = self;
    [self.navigationController pushViewController:contacts animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSTFriendTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"YSTFriendTableViewCell"];
    
    YSTUser *user = [_amigos objectAtIndex:indexPath.row];
    
    cell.nome = user.name;
    cell.numeroPendente = 0; // ver isso aqui depois

    [cell mount];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSTFriendToDosViewController * friend = [[YSTFriendToDosViewController alloc]init];
    friend.friendsVC = self;
    friend.user = [_amigos objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:friend animated:YES];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_amigos count];
}
@end
