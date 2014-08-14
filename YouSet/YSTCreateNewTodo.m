//
//  YSTCreateNewTodo.m
//  YouSet
//
//  Created by Riheldo Melo Santos on 12/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTCreateNewTodo.h"
#import "YSTEditableTableViewCell.h"

@interface YSTCreateNewTodo ()

@end

@implementation YSTCreateNewTodo

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
    
    
    
    self.createNewTodoTableView.delegate = self;
    self.createNewTodoTableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"YSTEditableTableViewCell" bundle:nil];
    [self.createNewTodoTableView registerNib:nib forCellReuseIdentifier:@"YSTEditableTableViewCell"];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelToDo)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    cancelButton.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(createToDo)];
    self.navigationItem.rightBarButtonItem = createButton;
    createButton.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelToDo{
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createToDo{
    NSLog(@"create");
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString static *cellIdentifier = @"YSTEditableTableViewCell";
    YSTEditableTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return cell;
}


@end
