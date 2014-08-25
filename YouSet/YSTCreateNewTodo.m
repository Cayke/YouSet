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
#import "YSTSwitchTableViewCell.h"


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface YSTCreateNewTodo ()
@property (assign) NSInteger pickerCellRowHeight;
@property (nonatomic, weak) UISwitch *switchPrivacy;

@end

@implementation YSTCreateNewTodo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.sectionOfRequiredFields = [NSArray arrayWithObjects:@"Todo",@"Date Schedule", nil];
        self.sectionOfOptionalFields = [NSArray arrayWithObjects:@"Privacy",nil];
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
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    UINib *nib = [UINib nibWithNibName:@"YSTEditableTableViewCell" bundle:nil];
    [self.toDoTableView registerNib:nib forCellReuseIdentifier:@"YSTEditableTableViewCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"YSTPickDateTableViewCell" bundle:nil];
    [self.toDoTableView registerNib:nib2 forCellReuseIdentifier:@"YSTPickDateTableViewCell"];
    
    UINib *nib3 = [UINib nibWithNibName:@"YSTSwitchTableViewCell" bundle:nil];
    [self.toDoTableView registerNib:nib3 forCellReuseIdentifier:@"YSTSwitchTableViewCell"];
    
    self.auxTodo = [[YSTToDo alloc]init];
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
    YSTAssignee *a = [[YSTAssignee alloc]init];
    a.status = 0;
    a.idUser = [YSTUser sharedUser].ID;
    [self.auxTodo includeAssign:a];
    
    NSDate *date = [[NSDate alloc]init];
    self.auxTodo.dateCreated = date;
    
    if (self.switchPrivacy.isOn) {
        self.auxTodo.isPublic = 1;
    } else {
        self.auxTodo.isPublic = 0;
    }
    
//    NSIndexPath *i = [[NSIndexPath alloc] initWithIndex:2];
//    
//    YSTSwitchTableViewCell *cell = (YSTSwitchTableViewCell *)[self.toDoTableView cellForRowAtIndexPath:i];
//    
//    //cell.switchOfCell....
    
    [[YSTToDoStore sharedToDoStore]createTodo:self.auxTodo];
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
    NSInteger numbersOfRows = [self.arrayOfSections[section] count];
    
    return numbersOfRows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *array = self.arrayOfSections[indexPath.section];
    NSString *item = array[indexPath.row];
    NSString  *cellIdentifier1 = @"YSTEditableTableViewCell";
    NSString  *cellIdentifier2 = @"YSTPickDateTableViewCell";
    NSString  *cellIdentifier3 = @"YSTSwitchTableViewCell";

    if (array == self.sectionOfRequiredFields) {
            if ([item isEqualToString:@"Todo"]) {
                YSTEditableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
                cell.contentTF.placeholder = @"Content";
                cell.auxTodo = self.auxTodo;
                return cell;
            } else if ([item isEqualToString:@"Date Schedule"]) {
                YSTPickDateTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
                return cell2;
            }

    } else if (array == self.sectionOfOptionalFields){
        
        if ([item isEqualToString:@"Privacy"]) {
            YSTSwitchTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
            self.switchPrivacy = cell3.switchOfCell;
            return cell3;
        }
    }
        
    
    UITableViewCell  *genericCell = [[UITableViewCell alloc]init];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}




@end
