//
//  Bookmark.m
//  NitechStudentBoard
//
//  Created by Kohei Hayakawa on 2012/12/19.
//  Copyright (c) 2012年 Kohei Hayakawa. All rights reserved.
//

#import "Bookmark.h"

@implementation Bookmark

- (NSMutableArray*)getBookmarkData{

    NSMutableArray *ary;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:BOOKMARK_DATA];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager fileExistsAtPath:dataPath];
    if(success) {
        ary = [NSMutableArray arrayWithContentsOfFile:dataPath];
        
    }
    else{
        ary = [NSMutableArray array];
    }
    return ary;
}


- (void)addBookmarkDataWithBody:(NSString*)body AndTitle:(NSString*)title{
    
    NSMutableArray *ary = [NSMutableArray array];
    ary = [self getBookmarkData];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:title forKey:@"title"];
    [dic setObject:body forKey:@"body"];
    
    //[ary addObject:dic];
    [ary insertObject:dic atIndex:0];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:BOOKMARK_DATA];
    [ary writeToFile:dataPath atomically:YES];
}


- (void)saveArrayDataToFile:(NSMutableArray*)ary{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:BOOKMARK_DATA];
    [ary writeToFile:dataPath atomically:YES];
}

@end
