//
//  YSTInviteViewController.h
//  YouSet
//
//  Created by Cayke Prudente on 22/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "YSTContact.h"

@interface YSTInviteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) YSTContact *contact;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@end
