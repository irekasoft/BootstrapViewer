//
//  ViewController.m
//  BootstrapViewer
//
//  Created by Hijazi on 10/8/14.
//  Copyright (c) 2014 iReka Soft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    NSArray *array = @[@[@"asdf",@"asdf",@"ec://asfasdf"],
                       @[@"nbb",@"asdf",@"ec://asdfasdf232"],
                       @[@"sdds",@"asdf",@"ec://ire4"]];

    int count = 1;
    NSMutableString *mutString = [[NSMutableString alloc] init];
    for (NSArray *newArray in array) {
        [mutString appendFormat:@"<tr onclick=\"window.document.location='%@'\" ><th>%d</th><td>%@</td><td>%@</td><td></td></tr>",newArray[2],count++, newArray[0], newArray[1]];

    }
    
    NSString *item = @"<tr><th>1</th><td>Name</td><td>Otto</td><td>@mdo</td></tr>";
    
    NSLog(@"log %@",mutString);
    
    NSString *newString = [mutString addBackslashes:mutString];
    
    
    // user scripts
    NSString *myScriptSource = [NSString stringWithFormat:@"document.getElementById('insert').innerHTML = '%@';", newString];
    
    WKUserScript *myUserScript = [[WKUserScript alloc] initWithSource:myScriptSource injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addUserScript:myUserScript];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.navigationDelegate = self;
    
    [self.view addSubview:self.webView];

    
//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"table" ofType:@"html" inDirectory:@"bootstrap"]];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    self.wwwFolderName = @"bootstrap";
    
    if (self.indexFileName==nil) {
        self.indexFileName = @"index.html";
    }

    
    NSString *urlString = [self createFileUrlHelper:[self copyBundleWWWFolderToFolder:[self tmpFolderPath]]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.webView.scrollView addSubview:refreshControl];
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    // Reload my data
    NSString *fullURL = @"http://irekasoft.com/";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [refresh endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"url %@",navigationAction.request.URL);
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = (url) ? url.absoluteString : @"";
    
//    // iTunes: App Store link
//    if ([urlString isMatch:RX(@"\\/\\/itunes\\.apple\\.com\\/")]) {
//        [[UIApplication sharedApplication] openURL:url];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
//    // Protocol/URL-Scheme without http(s)
//    else if (![urlString isMatch:[@"^https?:\\/\\/." toRxIgnoreCase:YES]]) {
//        [[UIApplication sharedApplication] openURL:url];
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }

    //
//    
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController pushViewController:vc animated:YES];
    
    NSArray *parts = [navigationAction.request.URL.absoluteString componentsSeparatedByString:@"/"];
    NSString *filename = [parts lastObject];

    if (navigationAction.navigationType > -1) {
        
        
        NSLog(@"url %@",navigationAction.request.URL);
        NSURL *url = navigationAction.request.URL;
        NSString *urlString = (url) ? url.absoluteString : @"";
        
        ViewController *browserVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        browserVC.indexFileName = filename;
        
        
        [self.navigationController pushViewController:browserVC animated:YES];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        
        
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }
}
#pragma mark - helper

- (NSString*) createFileUrlHelper:(NSString*)folderPath
{
    NSString* path = [folderPath stringByAppendingPathComponent:self.indexFileName];
    NSURL* url = [NSURL fileURLWithPath:path];
    return url.absoluteString;
}

- (NSString*) tmpFolderPath
{
    return NSTemporaryDirectory();
}

- (NSString*) copyBundleWWWFolderToFolder:(NSString*)folderPath
{
    NSString* location = nil;
    BOOL copyOK = NO;
    
    // is the bundle www index.html there
    NSString* indexFileWWWBundlePath = [self.wwwBundleFolderPath stringByAppendingPathComponent:self.indexFileName];
    BOOL readable = [[NSFileManager defaultManager] isReadableFileAtPath:indexFileWWWBundlePath];
    NSLog(@"File %@ is readable: %@", indexFileWWWBundlePath, readable? @"YES" : @"NO");
    
    if (readable) {
        NSString* newFolderPath = [folderPath stringByAppendingPathComponent:@"www"];
        
        // create the folder, if needed
        [[NSFileManager defaultManager] createDirectoryAtPath:newFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        // copy
        NSError* error = nil;
        if ((copyOK = [self copyFrom:self.wwwBundleFolderPath to:newFolderPath error:&error])) {
            location = newFolderPath;
        }
        NSLog(@"Copy from %@ to %@ is ok: %@", folderPath, newFolderPath, copyOK? @"YES" : @"NO");
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            location = nil;
        }
    }
    
    return location;
}

- (NSString*)wwwBundleFolderPath
{
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* wwwFileBundlePath = [mainBundle pathForResource:self.indexFileName ofType:@"" inDirectory:self.wwwFolderName];
    return [wwwFileBundlePath stringByDeletingLastPathComponent];
}


- (BOOL)copyFrom:(NSString*)src to:(NSString*)dest error:(NSError* __autoreleasing*)error
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:src]) {
        NSString* errorString = [NSString stringWithFormat:@"%@ file does not exist.", src];
        if (error != NULL) {
            (*error) = [NSError errorWithDomain:@"TestDomainTODO"
                                           code:1
                                       userInfo:[NSDictionary dictionaryWithObject:errorString
                                                                            forKey:NSLocalizedDescriptionKey]];
        }
        return NO;
    }
    
    // generate unique filepath in temp directory
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    NSString* tempBackup = [[NSTemporaryDirectory() stringByAppendingPathComponent:(__bridge NSString*)uuidString] stringByAppendingPathExtension:@"bak"];
    CFRelease(uuidString);
    CFRelease(uuidRef);
    
    BOOL destExists = [fileManager fileExistsAtPath:dest];
    
    // backup the dest
    if (destExists && ![fileManager copyItemAtPath:dest toPath:tempBackup error:error]) {
        return NO;
    }
    
    // remove the dest
    if (destExists && ![fileManager removeItemAtPath:dest error:error]) {
        return NO;
    }
    
    // create path to dest
    if (!destExists && ![fileManager createDirectoryAtPath:[dest stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:error]) {
        return NO;
    }
    
    // copy src to dest
    if ([fileManager copyItemAtPath:src toPath:dest error:error]) {
        // success - cleanup - delete the backup to the dest
        if ([fileManager fileExistsAtPath:tempBackup]) {
            [fileManager removeItemAtPath:tempBackup error:error];
        }
        return YES;
    } else {
        // failure - we restore the temp backup file to dest
        [fileManager copyItemAtPath:tempBackup toPath:dest error:error];
        // cleanup - delete the backup to the dest
        if ([fileManager fileExistsAtPath:tempBackup]) {
            [fileManager removeItemAtPath:tempBackup error:error];
        }
        return NO;
    }
}
@end
