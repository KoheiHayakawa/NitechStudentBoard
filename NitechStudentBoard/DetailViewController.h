//
//  DetailViewController.h
//  NitechStudentBoard
//
//  Created by Kohei Hayakawa on 2012/12/18.
//  Copyright (c) 2012年 Kohei Hayakawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+PinchZoom.h"

@interface DetailViewController : UIViewController{
    NSString *body;
}

@property (strong, nonatomic) NSString *detailUrl;
@property (strong, nonatomic) NSString *detailTitle;
@property (strong, nonatomic) NSString *detailBody;

//@property (weak, nonatomic) IBOutlet UITextView *detailScrollField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
