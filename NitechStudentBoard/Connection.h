//
//  Connection.h
//  NitechStudentBoard
//
//  Created by Kohei Hayakawa on 2012/12/18.
//  Copyright (c) 2012年 Kohei Hayakawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Connection : NSObject{
    NSMutableData *dlData;
    BOOL synchronousOperationComplete;
    NSURLConnection *conn;
}

@property (nonatomic, strong) NSMutableArray* titles;
@property (nonatomic, strong) NSMutableArray* urls;

- (void)initDataOfTitlesAndUrls;
- (NSString*)getSessionId;
- (NSString*)getHttpDataWithUrl:(NSString*) urls AndTitle:(NSString*) title;
    
@end
