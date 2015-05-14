//
//  SecondVC.h
//  BootstrapViewer
//
//  Created by Hijazi on 14/5/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "RegExCategories.h"
#import "NSString_JavascriptEscape.h"


@interface SecondVC : UIViewController<WKNavigationDelegate>

@property (strong) NSString *wwwFolderName;
@property (strong) NSString *indexFileName;

@property (strong, nonatomic) WKWebView *webView;

@end
