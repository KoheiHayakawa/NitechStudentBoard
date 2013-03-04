//
//  MasterViewController.h
//  NitechStudentBoard
//
//  Created by Kohei Hayakawa on 2012/12/18.
//  Copyright (c) 2012年 Kohei Hayakawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SBPullToRefreshHeaderView.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController{
    NSMutableArray *titles;
    NSMutableArray *urls;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

- (void)refreshData;
    
@end
