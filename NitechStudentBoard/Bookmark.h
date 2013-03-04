//
//  Bookmark.h
//  NitechStudentBoard
//
//  Created by Kohei Hayakawa on 2012/12/19.
//  Copyright (c) 2012年 Kohei Hayakawa. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BOOKMARK_DATA @"bookmark.plist"

@interface Bookmark : NSObject

- (NSMutableArray*)getBookmarkData;
- (void)addBookmarkDataWithBody:(NSString*)body AndTitle:(NSString*)title;
- (void)saveArrayDataToFile:(NSMutableArray*)ary;


@end
