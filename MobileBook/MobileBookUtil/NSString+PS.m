//
//  NSString+PS.m
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "NSString+PS.h"
#import "PinYin4Objc.h"
@implementation NSString (PS)

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

- (NSString *)toPinyinEx:(BOOL)isShort
{
    if (0 == self.length) return @"";
    
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    outputFormat.toneType = ToneTypeWithoutTone;
    outputFormat.vCharType = VCharTypeWithV;
    outputFormat.caseType = (isShort ? CaseTypeUppercase : CaseTypeLowercase);
    
    if (isShort)
    {
        NSString *temp = [PinyinHelper toHanyuPinyinStringWithNSString:[self substringToIndex:1] withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        if (temp.length) return [temp substringToIndex:1].uppercaseString;
        return temp;
    }
    
    NSString *temp = [PinyinHelper toHanyuPinyinStringWithNSString:self withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    return temp;
}
@end
