//
//  YSTPersonViewController.h
//  YouSet
//
//  Created by Cayke Prudente on 19/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTUser.h"
#import "YSTContact.h"

@interface YSTPersonViewController : UIViewController

@property (nonatomic) YSTContact *contact; //temporario
@property (nonatomic) YSTUser *person;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPhone;

@end
