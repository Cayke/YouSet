//
//  YSTAppDelegate.m
//  YouSet
//
//  Created by Willian Pinho on 8/7/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTAppDelegate.h"
#import "YSTMeViewController.h"
#import "YSTGroupsViewController.h"
#import "YSTContactsViewController.h"
#import "YSTFriendsViewController.h"
#import "YSTLoginViewController.h"
#import "YSTUser.h"
#import "YSTToDoStore.h"

@implementation YSTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // inicializar programa
    [self setStyles];
    if ([YSTUser sharedUser].logedin) {
        [self normalInitializateOfYouSet];
    } else {
        [self loginScreen];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)loginScreen{
    // login view controller
    YSTLoginViewController *login = [[YSTLoginViewController alloc]init];
    login.appDelegate = self;
    UINavigationController *navLogin = [[UINavigationController alloc]initWithRootViewController:login];
    
    [self.window setRootViewController:navLogin];
    
}

-(void)setStyles{
    // COR AZUL
    // R: 0
    // G: 122
    // B: 255
    //
    // COR VERDE
    // R: 184
    // G: 233
    // B: 134
    //divisao padrao para encontrar o valor das cores rgb
    CGFloat divided = 255.0;
    
    //cores para fazer o azul
    CGFloat red = 0.0/divided;
    CGFloat green = 122.0/divided;
    CGFloat blue = 255.0/divided;
    UIColor *blueColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    // colorir navigations
    [[UINavigationBar appearance] setBarStyle: UIBarStyleBlack];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [ UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor: blueColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // colorir tabbar
    //  [[UITabBar appearance] setBarStyle: UIBarStyleBlack];
    //   [[UITabBar appearance] setBarTintColor: blueColor];
    [[UITabBar appearance] setTintColor:blueColor];
    
}

-(void)normalInitializateOfYouSet {
    [[YSTToDoStore sharedToDoStore]reloadTodos];
    // Override point for customization after application launch.
    YSTMeViewController *mvc = [[YSTMeViewController alloc]init];
    //    YSTGroupsViewController *gvc = [[YSTGroupsViewController alloc]init];
    YSTFriendsViewController *fvc = [[YSTFriendsViewController alloc]init];
    
    // criar navigations
    UINavigationController *navMe = [[UINavigationController alloc]initWithRootViewController:mvc];
    //    UINavigationController *navGroups = [[UINavigationController alloc]initWithRootViewController:gvc];
    UINavigationController *navFriends = [[UINavigationController alloc]initWithRootViewController:fvc];
    
    
    UITabBarController *tbc = [[UITabBarController alloc]init];
    tbc.viewControllers = @[navMe, navFriends];
    
    // cores para fazer o verde
//    CGFloat divided = 255.0;
//    CGFloat red = 255.0/divided;
//    CGFloat green = 255.0/divided;
//    CGFloat blue = 255.0/divided;
//    UIColor *greenColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    NSString *userNoFill = @"user_nofill.png";
    UIImageView *userNoFillView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    userNoFillView.image = [UIImage imageNamed:userNoFill];
    NSString *imageUser = @"user.png";
    UIImageView *imageUserView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageUserView.image = [UIImage imageNamed:imageUser];
    navMe.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Eu" image:userNoFillView.image selectedImage:imageUserView.image];
    
    
    NSString *contactsFilled = @"contactsFilled.png";
    UIImageView *contactsFilledView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    contactsFilledView.image = [UIImage imageNamed:contactsFilled];
    
    NSString *contactsUnFilled = @"contactsUnFilled.png";
    UIImageView *contactsUnFilledView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    contactsUnFilledView.image = [UIImage imageNamed:contactsUnFilled];
    
    NSString *imageFriends = @"friends.png";
    UIImageView *imageViewFriends = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15.0, 15.0)];
    imageViewFriends.image = [UIImage imageNamed:imageFriends];
    
    navFriends.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Amigos" image:contactsUnFilledView.image selectedImage:contactsFilledView.image];
    
    //    for(UITabBarItem *item in nav.tabBar.items) {
    //        item.image = [[item.selectedImage imageWithColor:unselectedColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    }
    
    self.window.rootViewController = tbc;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // salvar todos
    [[YSTToDoStore sharedToDoStore]saveTodos];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // salvar todos
    [[YSTToDoStore sharedToDoStore]saveTodos];
}

@end
