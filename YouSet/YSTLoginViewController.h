//
//  YSTLoginViewController.h
//  YouSet
//
//  Created by Riheldo Melo Santos on 20/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSTAppDelegate.h"

@interface YSTLoginViewController : UIViewController
<UITextFieldDelegate>

// text field onde o usuario vai digitar o celular
@property (weak, nonatomic) IBOutlet UITextField *inputCell;

// appDelegate para mudanca de tela
@property (weak, nonatomic) YSTAppDelegate *appDelegate;

// pais
@property (nonatomic) NSDictionary *country;
@property (weak, nonatomic) IBOutlet UIButton *btnCountry;

// botao para cadastrar
- (IBAction)cadastrar:(id)sender;
- (IBAction)choiceCountry:(id)sender;

-(void)countryHasBeenChoosen:(NSDictionary*)country;

@end
