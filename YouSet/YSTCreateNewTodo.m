//
//  YSTCreateNewTodo.m
//  YouSet
//
//  Created by Riheldo Melo Santos on 12/08/14.
//  Copyright (c) 2014 YouSet. All rights reserved.
//

#import "YSTCreateNewTodo.h"
#import "YSTEditableTableViewCell.h"
#import "YSTToDoStore.h"
#import "YSTPickDateTableViewCell.h"


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface YSTCreateNewTodo ()
@property (assign) NSInteger pickerCellRowHeight;

@end

@implementation YSTCreateNewTodo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.sectionOfRequiredFields = [NSArray arrayWithObjects:@"Todo",@"Assignee",@"Date Schedule", nil];
        self.sectionOfOptionalFields = [NSArray arrayWithObjects:@"Date Created",@"Privacy",@"Status", nil];
        self.arrayOfSections = [NSArray arrayWithObjects:self.sectionOfRequiredFields, self.sectionOfOptionalFields, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelToDo)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    cancelButton.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(createToDo)];
    self.navigationItem.rightBarButtonItem = createButton;
    createButton.tintColor = [UIColor whiteColor];
    
    UINib *nib = [UINib nibWithNibName:@"YSTEditableTableViewCell" bundle:nil];
    [self.toDoTableView registerNib:nib forCellReuseIdentifier:@"YSTEditableTableViewCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"YSTPickDateTableViewCell" bundle:nil];
    [self.toDoTableView registerNib:nib2 forCellReuseIdentifier:@"YSTPickDateTableViewCell"];
    
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
    YSTToDo *newToDo = [[YSTToDo alloc]init];
    YSTToDoStore *tStore = [YSTToDoStore sharedToDoStore];
    [tStore createTodo:newToDo];
    NSLog(@"created");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.arrayOfSections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Required Fields";
    } else {
        return @"Optional Fields";
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfSections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.arrayOfSections[indexPath.section];
    NSString *item = array[indexPath.row];
    NSString  *cellIdentifier1 = @"YSTEditableTableViewCell";
    NSString  *cellIdentifier2 = @"YSTPickDateTableViewCell";

    UITableViewCell  *genericCell = [[UITableViewCell alloc]init];

    
    if (indexPath.section == 0) {
        YSTEditableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        if ([item isEqualToString:@"Todo"]) {
            cell.contentTF.placeholder = @"Content";
            
        } else if ([item isEqualToString:@"Assignee"]){
            cell.contentTF.placeholder = @"Assignee";
        } else if ([item isEqualToString:@"Date Schedule"]) {
            YSTPickDateTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
            return cell2;
     
            
        }
        
        return cell;
    }

    genericCell.textLabel.text = item;
    
    return genericCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.arrayOfSections[indexPath.section];
    NSString *item = array[indexPath.row];
    if ([item isEqualToString:@"Date Schedule"]) {
        return 162;
    }
    
    return 44;
}

- (void) getDate {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
}





@end
