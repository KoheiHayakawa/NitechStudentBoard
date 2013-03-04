//
//  DetailViewController.m
//  NitechStudentBoard
//
//  Created by Kohei Hayakawa on 2012/12/18.
//  Copyright (c) 2012年 Kohei Hayakawa. All rights reserved.
//

#import "DetailViewController.h"
#import "Connection.h"
#import "Bookmark.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _webView.scalesPageToFit = YES;
}

- (void)addBookmark:(id)sender{

    Bookmark *bkmk = [[Bookmark alloc] init];
    [bkmk addBookmarkDataWithBody:[body substringFromIndex:1] AndTitle:[_detailTitle substringFromIndex:1]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"お知らせ" message:@"ブックマークに追加されました。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"確認", nil];
    [alert show];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if(_detailBody != nil){
        self.navigationItem.rightBarButtonItem = nil;
        body = _detailBody;
        self.title = [_detailBody substringToIndex:16];
    }
    else{
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookmark:)];
        self.navigationItem.rightBarButtonItem = addButton;
        Connection *cnt = [[Connection alloc] init];
        body = [cnt getHttpDataWithUrl:_detailUrl AndTitle:_detailTitle];
        self.title = _detailTitle;
    }
    
    NSString *html = [NSString stringWithFormat:@"<html><head><META HTTP-EQUIV=\"Content-type\" CONTENT=\"text/html; charset=utf-8\"><meta name=\"viewport\" content=\"width=1024\"/> %@ </body></html>", body];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"tmp.html"];
    [html writeToFile:dataPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@", dataPath);
    NSURL *url = [NSURL URLWithString:dataPath];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
