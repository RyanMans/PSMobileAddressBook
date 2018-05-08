//
//  XKMobileAddressBook.m
//  XKMobileAddressBook
//
//  Created by Allen、 LAS on 2018/5/8.
//  Copyright © 2018年 重楼. All rights reserved.
//

#import "XKMobileAddressBook.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "XKMobileContactModel.h"

@implementation XKMobileAddressBook

//手机通讯录
+ (NSArray*)xk_MobileAddressBook{
    
    ABAddressBookRef  bookRef = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        
        bookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else{
        bookRef = ABAddressBookCreate();
    }

    if (!bookRef) return nil;
    
    CFIndex personCount = ABAddressBookGetPersonCount(bookRef);

    if (personCount == 0) return nil;
    
    NSMutableArray * allDataSource  = [NSMutableArray array];
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(bookRef);
    
    for (int index = 0; index < personCount; index ++ ) {
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, index);

        CFTypeRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        CFTypeRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);

        CFStringRef compositeName = ABRecordCopyCompositeName(person);

        NSString * firstNameDescri = (__bridge NSString *)firstName;
        
        NSString * lastNameDescri  = (__bridge NSString *)lastName;

        if ((__bridge id)compositeName != nil) firstNameDescri = (__bridge NSString *)compositeName;
        else{
            
            if ((__bridge id)lastName != nil) firstNameDescri = [NSString stringWithFormat:@"%@ %@", firstNameDescri, lastNameDescri];;
        }
        
        //通讯录对象
        XKMobileContactModel * tempModel = [XKMobileContactModel new];
        tempModel.name = firstNameDescri;
        tempModel.recordID = [NSString stringWithFormat:@"%d",(int)ABRecordGetRecordID(person)];

        ABPropertyID propertyID[] = {kABPersonPhoneProperty,kABPersonEmailProperty};
        
        NSInteger  propertyCount = sizeof(propertyID) / sizeof(ABPropertyID);

        for (int subIndex = 0; subIndex < propertyCount; subIndex ++) {
            
            ABPropertyID  property = propertyID[subIndex];
            
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            
            NSInteger  valuesCount = 0;

            if (valuesRef) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0)
            {
                CFRelease(valuesRef);
                continue;
            }
            
            //获取手机好吗、邮箱地址
            for (int mIndex = 0; mIndex < valuesCount; mIndex ++) {
                
                CFTypeRef valueAtIndex = ABMultiValueCopyValueAtIndex(valuesRef, mIndex);
                
                NSString * valueStr = (__bridge NSString *)valueAtIndex;
                
                if (subIndex == 0) {   //手机号码
                    
                    if (!tempModel.mobileNumberArrs)tempModel.mobileNumberArrs = [NSMutableArray array];
                    
                    tempModel.mobileNumberArrs = (valueStr != nil && valueStr.length != 0)? @[valueStr]:@[@""];
                }
                else if (subIndex == 1) {  //邮箱地址
                    
                    if (!tempModel.emailArrs)tempModel.emailArrs = [NSMutableArray array];

                    tempModel.emailArrs = (valueStr != nil && valueStr.length != 0)? @[valueStr]:@[@""];
                }
                
                CFRelease(valueAtIndex);
            }
            
            CFRelease(valuesRef);
        }
        
         // 将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
         [allDataSource addObject:tempModel];
        
        if (firstName) CFRelease(firstName);
        
        if (lastName) CFRelease(lastName);

        if (compositeName) CFRelease(compositeName);
    }
    
    return allDataSource;
}

@end
