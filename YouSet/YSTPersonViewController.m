//
//  YSTPersonViewController.m
//  YouSet
//
//  Created by Cayke Prudente on 19/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTPersonViewController.h"

@interface YSTPersonViewController ()

@end

@implementation YSTPersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _contact.name;
    self.labelName.text = _contact.name;
    //self.labelPhone.text = _contact.phone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
