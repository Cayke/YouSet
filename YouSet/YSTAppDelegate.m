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
    // R: 74
    // G: 144
    // B: 226
    //
    // COR VERDE
    // R: 184
    // G: 233
    // B: 134
    //divisao padrao para encontrar o valor das cores rgb
    CGFloat divided = 255.0;
    
    //cores para fazer o azul
    CGFloat red = 74.0/divided;
    CGFloat green = 144.0/divided;
    CGFloat blue = 226.0/divided;
    UIColor *blueColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    // colorir navigations
    [[UINavigationBar appearance] setBarStyle: UIBarStyleBlack];
    [[UINavigationBar appearance] setBarTintColor: blueColor];
    
    // colorir tabbar
    [[UITabBar appearance] setBarStyle: UIBarStyleBlack];
    [[UITabBar appearance] setBarTintColor: blueColor];
    
    // cores para fazer o verde
    red = 184.0/divided;
    green = 233.0/divided;
    blue = 134.0/divided;
    UIColor *greenColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    [[UITabBar appearance]setSelectedImageTintColor:greenColor];
    
}

-(void)normalInitializateOfYouSet {
    // Override point for customization after application launch.
    YSTMeViewController *mvc = [[YSTMeViewController alloc]init];
    YSTGroupsViewController *gvc = [[YSTGroupsViewController alloc]init];
    YSTFriendsViewController *fvc = [[YSTFriendsViewController alloc]init];
    
    // criar navigations
    UINavigationController *navMe = [[UINavigationController alloc]initWithRootViewController:mvc];
    UINavigationController *navGroups = [[UINavigationController alloc]initWithRootViewController:gvc];
    UINavigationController *navFriends = [[UINavigationController alloc]initWithRootViewController:fvc];
    
    
    UITabBarController *tbc = [[UITabBarController alloc]init];
    tbc.viewControllers = [NSArray  arrayWithObjects:navMe, navGroups, navFriends, nil];
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
}

@end
