//
//  YSTRegisterNewViewController.h
//  YouSet
//
//  Created by Cayke on 27/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTLoginViewController.h"

@interface YSTRegisterNewViewController : UIViewController

@property (weak, nonatomic) YSTLoginViewController *login;

@property (nonatomic) NSString *phone;

@property (weak, nonatomic) IBOutlet UILabel *labelPhone;
@property (weak, nonatomic) IBOutlet UITextField *inputName;


- (IBAction)registerNEwUser:(id)sender;

@end
