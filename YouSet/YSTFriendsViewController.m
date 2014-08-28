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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //botar activity
    [_carregando setColor:[UIColor blueColor]];
    [_carregando startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _carregando.hidesWhenStopped = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Call your function or whatever work that needs to be done
        //Code in this part is run on a background thread
        _amigos = [[YSTConnection sharedConnection] getFollowersFromDeviseUserWithError:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //Stop your activity indicator or anything else with the GUI
            //Code here is run on the main thread
            [_carregando stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (_amigos)
            {
                [_tableView reloadData];
            }
            else
            {
                UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Atencao" message:@"Voce ainda nao segue ninguem. Para seguir um amigo novo clique no botao + a cima" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alerta show];
            }
        });
    });
    
    // _amigos = [[YSTConnection sharedConnection] getFollowersFromDeviseUserWithError:nil];
    
    //  [_carregando stopAnimating];
    
    self.title = @"Amigos";
    
    UINib *nib = [UINib nibWithNibName:@"YSTFriendTableViewCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"YSTFriendTableViewCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
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
    [_carregando startAnimating];
    
    
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
    
    
    user.pendentTodos = 0; // ver isso aqui depois
    
    cell.user = user;
    
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
