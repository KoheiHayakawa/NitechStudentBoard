//
//  Connection.m
//  NitechStudentBoard
//
//  Created by Kohei Hayakawa on 2012/12/18.
//  Copyright (c) 2012年 Kohei Hayakawa. All rights reserved.
//

#import "Connection.h"

#import "SettingViewController.h"

@implementation Connection

@synthesize titles = _titles;
@synthesize urls = _urls;


- (void)initDataOfTitlesAndUrls{
    
    if(self.titles == NULL){
        self.titles = [[NSMutableArray alloc] init];
    }
    if(self.urls == NULL){
        self.urls = [[NSMutableArray alloc] init];
    }
    
    NSString *sessionId = [self getSessionId];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://rpxkeijiban.ict.nitech.ac.jp/keijibanM/app;jsessionid=%@?uri=keijibanM&next_uri=&event_code=&no_read=true&on_flag=false&reference_flag=true&order=info.bulletin_start_date&order_kind=desc&info_length=0&check_reference_flag=true&reload=%%8D%%C4%%95%%5C%%8E%%A6",sessionId]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [conn start];
    
    synchronousOperationComplete = NO;
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (!synchronousOperationComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    NSString* resultString = [[NSString alloc] initWithData:dlData encoding:NSShiftJISStringEncoding];

    NSArray *contents = [resultString componentsSeparatedByString:@"<td bgcolor=\"#FFFFFF\">"];
    
    for(int i = 1; i < contents.count; i++){
        NSString *string = [contents objectAtIndex:i];
        string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        string = [string stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
        //string = [string stringByReplacingOccurrencesOfString:@"◎" withString:@""];
        //string = [string stringByReplacingOccurrencesOfString:@"●" withString:@""];
        
        NSError *error   = nil;
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"(.+?)\">(.+?)</td>" options:0 error:&error];
        
        if (error != nil) {
            NSLog(@"%@", error);
        } else {
            NSTextCheckingResult *match = [regexp firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
            [self.titles addObject:[string substringWithRange:[match rangeAtIndex:2]]];
            [self.urls addObject:[string substringWithRange:[match rangeAtIndex:1]]];
        }
    }
}


- (NSString*)getSessionId{
    
    User *usr = [[User alloc] init];
    NSString *uid = [usr load:1];
    NSString *pw = [usr load:2];
    
    NSString *data = [NSString stringWithFormat:@"uri=user_login&next_uri=&event_code=&user_id=%@&password=%@&login=OC", uid, pw];    
    NSURL* url = [NSURL URLWithString:@"https://rpxkeijiban.ict.nitech.ac.jp/keijibanM/app"];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[data dataUsingEncoding:NSShiftJISStringEncoding]];
    
    NSURLResponse *resp;
    NSError *err;
    NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
    NSString* resultString = [[NSString alloc] initWithData:result encoding:NSShiftJISStringEncoding];

    NSString *sessionId;
    NSString *string = resultString;
    NSError *error   = nil;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"<form action=\"/keijibanM/app;jsessionid=(.+)\" method=\"POST\">" options:0 error:&error];
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSTextCheckingResult *match = [regexp firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
        sessionId = [string substringWithRange:[match rangeAtIndex:1]];
    }
    NSLog(@"sessionid: %@",sessionId);
    
    return sessionId;
}


- (NSString*)getHttpDataWithUrl:(NSString*) urls AndTitle:(NSString*) title{

    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://rpxkeijiban.ict.nitech.ac.jp%@",urls]];
    
    //NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [conn start];
    
    synchronousOperationComplete = NO;
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (!synchronousOperationComplete && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    NSString* resultString = [[NSString alloc] initWithData:dlData encoding:NSShiftJISStringEncoding];
    
    //NSURLResponse *resp;
    //NSError *err;
    //NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
    //NSString* resultString = [[NSString alloc] initWithData:result encoding:NSShiftJISStringEncoding];
    NSString *string = resultString;
    
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    NSError *error   = nil;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"<br>-->(.+)</td>" options:0 error:&error];
    
    NSString *page;
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSTextCheckingResult *match = [regexp firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
        page = [string substringWithRange:[match rangeAtIndex:1]];
        //page = [page stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        //page = [page stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        //page = [page stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        //NSLog(@"log: %@", page);
    }
    return [NSString stringWithFormat:@"%@<br><br>%@", title, page];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    dlData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [dlData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    synchronousOperationComplete = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"データ取得失敗" message:@"通信環境または設定をご確認ください。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    synchronousOperationComplete = YES;
}



@end
