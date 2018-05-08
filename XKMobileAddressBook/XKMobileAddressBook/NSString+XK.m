//
//  NSString+XK.m
//  XKMobileAddressBook
//
//  Created by Allen、 LAS on 2018/5/8.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import "NSString+XK.h"
#import "PinYin4Objc.h"

@implementation NSString (XK)

- (NSString *)onlyNumbers
{
    if (nil == self) return nil;
    if (0 == self.length) return @"";
    
    unichar c = 0;
    NSMutableString *temp = [NSMutableString stringWithCapacity:self.length];
    for (NSUInteger a = 0; a < self.length; ++a)
    {
        c = [self characterAtIndex:a];
        if (c < '0') continue;
        if (c > '9') continue;
        [temp appendFormat:@"%C", c];
    }
    return temp;
}

//
- (NSString *)toPinyinEx:(BOOL)isAs{
    
    if (0 == self.length) return @"";

    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    outputFormat.toneType = ToneTypeWithoutTone;
    outputFormat.vCharType = VCharTypeWithV;
    outputFormat.caseType = (isAs ? CaseTypeUppercase : CaseTypeLowercase);
    
    if (isAs) {
        
        NSString *temp = [PinyinHelper toHanyuPinyinStringWithNSString:[self substringToIndex:1] withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        if (temp.length) return [temp substringToIndex:1].uppercaseString;
        return temp;
    }
    
    NSString *temp = [PinyinHelper toHanyuPinyinStringWithNSString:self withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    return temp;
}
@end
