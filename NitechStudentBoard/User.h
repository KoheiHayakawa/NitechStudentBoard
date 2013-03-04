//
//  User.h
//  NitechStudentBoard
//
//  Created by Shotaro Fujie on 2012/12/20.
//  Copyright (c) 2012年 Shotaro Fujie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{
    
}

- (NSString *)load:(int)type;
- (void)save:(NSString *)data keyType:(int)type;

@end
