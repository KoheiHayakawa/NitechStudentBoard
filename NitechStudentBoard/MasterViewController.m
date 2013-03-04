//
//  MasterViewController.m
//  NitechStudentBoard
//
//  Created by Kohei Hayakawa on 2012/12/18.
//  Copyright (c) 2012年 Kohei Hayakawa. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Connection.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController
{
@private
    SBPullToRefreshHeaderView *mRefreshHeaderView;
    BOOL mIsReloading;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"掲示板";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    


	// Do any additional setup after loading the view, typically from a nib.
    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(pushedRefreshButton:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    [self rightItemButtonWithRefresh];
    
    Connection *cnt = [[Connection alloc] init];
    [cnt initDataOfTitlesAndUrls];
    titles = [[NSMutableArray alloc] init];
    titles = cnt.titles;
    urls = [[NSMutableArray alloc] init];
    urls = cnt.urls;
    
    if(titles.count == 0){
        UITabBarController *controller = self.tabBarController;
        controller.selectedViewController = [controller.viewControllers objectAtIndex: 2];
    }
    
    if (mRefreshHeaderView == nil)
    {
        mRefreshHeaderView = [[SBPullToRefreshHeaderView alloc] initOnScrollView:self.tableView withDelegate:(id)self];
        
        // setup messages ...
        [mRefreshHeaderView setMessage:NSLocalizedString(@"画面を引き下げて...",@"")
                              forState:kSBRefreshHeaderIsNormal];
        [mRefreshHeaderView setMessage:NSLocalizedString(@"指を離して更新...",@"")
                              forState:kSBRefreshHeaderIsPulled];
        [mRefreshHeaderView setMessage:NSLocalizedString(@"読み込み中...",@"")
                              forState:kSBRefreshHeaderIsLoading];
    }
}

- (void)reloadTableViewDataSource{
    
    mIsReloading = YES;
}

- (void)doneLoadingTableViewData{

    [self refreshData];
    mIsReloading = NO;
    [mRefreshHeaderView resetView:YES];
}

- (void)didTriggerRefresh:(SBPullToRefreshHeaderView *)headerView{
    
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData)
               withObject:nil
               afterDelay:0.0];
}

- (BOOL)isRefreshStillProcessing:(SBPullToRefreshHeaderView *)headerView{
    
    return mIsReloading;
}



-(void)rightItemButtonWithRefresh{
    
    UIBarButtonItem *rightItemButtonWithRefresh = [[UIBarButtonItem alloc]
                                                   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                   target:self
                                                   action:@selector(refreshBtnEvent:)
                                                   ];
    
    [self setToolbarItems:[NSArray arrayWithObjects:rightItemButtonWithRefresh, nil] animated:YES];
    self.navigationItem.rightBarButtonItem = rightItemButtonWithRefresh;
}

-(void)rightItemButtonWithActivityIndicator{
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityIndicator startAnimating];
    
    UIBarButtonItem *activityButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    [self setToolbarItems:[NSArray arrayWithObjects:activityButtonItem, nil] animated:YES];
    self.navigationItem.rightBarButtonItem = activityButtonItem;
    
    [self refreshData];
    
    [self performSelector:@selector(activityIndicatorBtnEvent:) withObject:nil afterDelay:0];
}

- (void) refreshBtnEvent:(id)sender{
    
    [self rightItemButtonWithActivityIndicator];
}

- (void) activityIndicatorBtnEvent:(id)sender{
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]init];
    [activityIndicator stopAnimating];
    
    [self rightItemButtonWithRefresh];
}

-(void)viewWillAppear:(BOOL)animated{

    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSString *flag = [userData stringForKey:@"flag"];
    if(![flag compare:@"1"]){
        [self refreshData];
        [userData setObject:@"0" forKey:@"flag"];
        [userData synchronize];
    }

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshData{
    
    NSLog(@"refresh");
    Connection *cnt = [[Connection alloc] init];
    [cnt initDataOfTitlesAndUrls];
    urls = cnt.urls;
    
    if(cnt.titles.count > titles.count){
        int n = cnt.titles.count - titles.count;
        for(int i = 0; i < n; i++){
            NSLog(@"%@",[cnt.titles objectAtIndex:cnt.titles.count - i - 1]);
            [titles insertObject:[cnt.titles objectAtIndex:cnt.titles.count-i-1] atIndex:0];
            [urls insertObject:[cnt.urls objectAtIndex:cnt.urls.count-i-1] atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    titles = cnt.titles;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titles.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }

    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
     
    self.detailViewController.detailUrl = [urls objectAtIndex:indexPath.row];
    self.detailViewController.detailTitle = [titles objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
