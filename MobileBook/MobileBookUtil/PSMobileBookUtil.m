//
//  PSMobileBookUtil.m
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSMobileBookUtil.h"
#import <AddressBook/AddressBook.h>

@implementation PSMobileBookUtil
+ (NSMutableArray*)getAllMobileContacts
{
    //新建一个手机通讯录类
    ABAddressBookRef addressBookRef = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        //获取通讯录权限
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else
    {
        addressBookRef = ABAddressBookCreate();
    }
    if (!addressBookRef)
    {
        return nil;
    }
    // 通讯录中人数
    CFIndex peopleNumber = ABAddressBookGetPersonCount(addressBookRef);
    if (peopleNumber == 0)
    {
        return nil;
    }
    NSMutableArray * _allMobileContacts = NewMutableArray();
    
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    for (NSInteger i = 0; i < peopleNumber; i++)
    {
        
        // 手机用户模型
        PSMobileContactModel * mobileModel = NewClass(PSMobileContactModel);
        
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        CFTypeRef   firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef   lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString * nameString = (__bridge NSString *)firstName;
        NSString * lastNameString = (__bridge NSString *)lastName;
        
        if ((__bridge id)abFullName != nil)
        {
            nameString = (__bridge NSString *)abFullName;
        }
        else
        {
            if ((__bridge id)lastName != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        mobileModel.name = nameString;
        mobileModel.recordID = [NSString stringWithFormat:@"%d",(int)ABRecordGetRecordID(person)];
        
        ABPropertyID multiProperties[] =
        {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger  multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        
        
        for (NSInteger j = 0; j < multiPropertiesTotal; j++)
        {
            ABPropertyID   property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger  valuesCount = 0;
            
            if (valuesRef != nil)
            {
                valuesCount = ABMultiValueGetCount(valuesRef);
            }
            
            if (valuesCount == 0)
            {
                CFRelease(valuesRef);
                continue;
            }
            // 获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++)
            {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j)
                {
                    case 0:
                    {   // Phone number
                        NSString *temp = (__bridge NSString *)value;
                        if (!mobileModel.mobileArr)
                        {
                            mobileModel.mobileArr = NewMutableArray();
                        }
                        NSArray * tempArr = [NSArray arrayWithObjects:IsSafeString(temp), nil];
                        mobileModel.mobileArr = tempArr;
                        break;
                    }
                    case 1:
                        
                    {   // Email
                        NSString *temp = (__bridge NSString *)value;
                        
                        if (!mobileModel.emailArr)
                        {
                            mobileModel.emailArr = NewMutableArray();
                        }
                        NSArray * tempArr = [NSArray arrayWithObjects:IsSafeString(temp), nil];
                        mobileModel.emailArr = tempArr;
                        break;
                    }
                }
                CFRelease(value);
            }
            
            CFRelease(valuesRef);
        }
        
        // 将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [_allMobileContacts addObject:mobileModel];
        
        if (firstName) {
            CFRelease(firstName);
        }
        
        if (lastName) {
            CFRelease(lastName);
        }
        
        if (abFullName) {
            CFRelease(abFullName);
        }
        
    }
    return _allMobileContacts;
}


#pragma mark -线程-
void runBlockWithMain(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

void runBlockWithAsync(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void runBlock(dispatch_block_t asyncBlock, dispatch_block_t syncBlock)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        asyncBlock();
        dispatch_async(dispatch_get_main_queue(), syncBlock);
    });
}


@end
