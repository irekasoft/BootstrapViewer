//
//  NSString+NSString_JavascriptEscape.h
//  BootstrapViewer
//
//  Created by Hijazi on 29/3/15.
//  Copyright (c) 2015 iReka Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_JavascriptEscape)

- (NSString *)stringEscapedForJavasacript;
-(NSString *)addBackslashes:(NSString *)string;
@end
