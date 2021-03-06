//
//  ViewController.h
//  BootstrapViewer
//
//  Created by Hijazi on 10/8/14.
//  Copyright (c) 2014 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "RegExCategories.h"
#import "NSString_JavascriptEscape.h"


@interface ViewController : UIViewController <WKNavigationDelegate>

@property (strong) NSString *wwwFolderName;
@property (strong) NSString *indexFileName;

@property (strong, nonatomic) WKWebView *webView;


@end
