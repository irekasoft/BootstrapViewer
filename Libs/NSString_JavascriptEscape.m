//
//  NSString+NSString_JavascriptEscape.m
//  BootstrapViewer
//
//  Created by Hijazi on 29/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import "NSString_JavascriptEscape.h"

@implementation NSString (NSString_JavascriptEscape)

- (NSString *)stringEscapedForJavasacript {
    // valid JSON object need to be an array or dictionary
    NSArray* arrayForEncoding = @[self];
    NSString* jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arrayForEncoding options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    NSString* escapedString = [jsonString substringWithRange:NSMakeRange(2, jsonString.length - 4)];
    return escapedString;
}
-(NSString *)addBackslashes:(NSString *)string {
    /*
     
     Escape characters so we can pass a string via stringByEvaluatingJavaScriptFromString
     
     */
    
    // Escape the characters
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    string = [string stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    string = [string stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    return string;
}
@end
