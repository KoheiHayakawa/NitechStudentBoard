//
//  User.m
//  NitechStudentBoard
//
//  Created by Shotaro Fujie on 2012/12/20.
//  Copyright (c) 2012年 Shotaro Fujie. All rights reserved.
//

#import "User.h"

@implementation User

- (NSString *)load:(int)type {
    
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    switch (type) {
        case 1:
            return [userData stringForKey:@"KEY_ID"];
        case 2:
            return [userData stringForKey:@"KEY_PW"];
        default:
            return nil;
    }
}

- (void)save:(NSString *)data keyType:(int)type {
    
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    switch (type) {
        case 1:
            [userData setObject:data forKey:@"KEY_ID"];
            break;
        case 2:
            [userData setObject:data forKey:@"KEY_PW"];
            break;
        default:
            break;
    }
    [userData synchronize];
}

@end
