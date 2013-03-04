//
//  BookmarkViewController.h
//  NitechStudentBoard
//
//  Created by Kohei Hayakawa on 2012/12/18.
//  Copyright (c) 2012年 Kohei Hayakawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface BookmarkViewController : UITableViewController{
    NSMutableArray *ary;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
