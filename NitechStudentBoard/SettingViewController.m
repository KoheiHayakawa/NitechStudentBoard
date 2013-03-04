//
//  SettingViewController.m
//  NitechStudentBoard
//
//  Created by Shotaro Fujie on 2012/12/18.
//  Copyright (c) 2012年 Shotaro Fujie. All rights reserved.
//

#import "SettingViewController.h"


#import "MasterViewController.h"

@interface SettingViewController () {
}

@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //userData = [NSUserDefaults standardUserDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];        
        
        User *usr = [[User alloc] init];
        
        switch ([indexPath indexAtPosition:1]) {
            case (0):
                accountField = [[UITextField alloc] initWithFrame:CGRectMake(130.0, 12.0, 200.0, 50.0)];
                [cell addSubview:accountField];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [accountField setEnabled:YES];
                accountField.returnKeyType = UIReturnKeyNext;
                accountField.delegate = (id)self;
                cell.textLabel.text = @"基盤ID";
                accountField.text = [usr load:1];
                break;
            case (1):
                passwordField = [[UITextField alloc] initWithFrame:CGRectMake(130.0, 12.0, 200.0, 50.0)];
                [cell addSubview:passwordField];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [passwordField setEnabled:YES];
                [passwordField setSecureTextEntry:YES];
                passwordField.returnKeyType = UIReturnKeyDone;
                passwordField.delegate = (id)self;
                cell.textLabel.text = @"パスワード";
                passwordField.text = [usr load:2];
                
                break;
        }
    }

    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    User *usr = [[User alloc] init];
    [usr save:accountField.text keyType:1];
    [usr save:passwordField.text keyType:2];
    
    if (textField == accountField) {
        [passwordField becomeFirstResponder];
    } else {
        [passwordField resignFirstResponder];
        
        NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
        [userData setObject:@"1" forKey:@"flag"];
        [userData synchronize];
        
        UITabBarController *controller = self.tabBarController;
        controller.selectedViewController = [controller.viewControllers objectAtIndex: 0];
         
    }
    return YES;
}


@end
