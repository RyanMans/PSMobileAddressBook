//
//  PSBaseModel.m
//  MobileBook
//
//  Created by Ryan_Man on 16/6/23.
//  Copyright © 2016年 Ryan_Man. All rights reserved.
//

#import "PSBaseModel.h"
#import "YYModel.h"
@implementation PSBaseModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self checkModelProperty];

    }
    return self;
}

+ (instancetype)modelWithDictionary:(NSDictionary*)dict
{

    if (dict.count == 0 || !dict)  return [PSBaseModel new];;
    
    return [self yy_modelWithDictionary:dict];
}

+ (NSArray*)modelWithKeyValuesArrays:(NSArray*)arrays
{

    if (arrays.count == 0 || !arrays)  return @[];
    
    return [NSArray yy_modelArrayWithClass:self json:arrays];
}


- (NSDictionary*)dictionary
{
    
    return (NSDictionary*)[self yy_modelToJSONObject];
}

+ (NSArray*)keyValuesArrayWithObjectArray:(NSArray *)models
{
    if (models.count == 0 || !models)  return @[];
    
    NSMutableArray * temp = NewMutableArray();
    for (PSBaseModel * model in models)
    {
        NSDictionary * dict = [model dictionary];
        if (dict.count) {
            [temp addObject:dict];
        }
    }
    return temp.count ? temp : @[];
}


- (void)checkModelProperty
{
    //使用运行时 校验 模型属性
    
    unsigned int number;
    
    Ivar * vars = class_copyIvarList(NSClassFromString([[self class] description]), &number);
    
    NSString * varName = nil;
    NSString * varType = nil;
    
    for (int i = 0 ; i < number; i ++)
    {
        Ivar  temp = vars[i];
        
        varName = [NSString stringWithUTF8String:ivar_getName(temp)];
        
        varType = [NSString stringWithUTF8String:ivar_getTypeEncoding(temp)];
        
        id value = [self valueForKey:varName];
        
        if (!value)
        {
            if (IsSameString(varType, @"@\"NSNumber\""))
            {
                [self setValue:@0 forKey:varName];
            }
            else if (IsSameString(varType, @"@\"NSString\"") || IsSameString(varType, @"@\"NSMutableString\""))
            {
                [self setValue:@"" forKey:varName];
            }
            else if (IsSameString(varType, @"@\"NSArray\"") || IsSameString(varType, @"@\"NSMutableArray\""))
            {
                [self setValue:@[] forKey:varName];
            }
            else if (IsSameString(varType, @"@\"NSDictionary\"")  || IsSameString(varType, @"@\"NSMutableDictionary\""))
            {
                [self setValue:@{} forKey:varName];
            }
            else
            {
                NSLog(@"%@",varType);
                NSMutableString * type = [[NSMutableString alloc] initWithString:varType];
                
                NSRange  range = [type rangeOfString:@"@\""];
                if (range.location != NSNotFound)
                {
                    [type deleteCharactersInRange:range];
                }
                range = [type rangeOfString:@"\""];
                if (range.location !=NSNotFound)
                {
                    [type deleteCharactersInRange:range];
                }
                varType = type;
                id object =  [[NSClassFromString(varType) alloc] init];
                if (object && !IsKindOfClass(object, NSNull))
                {
                    if (IsKindOfClass(object, NSObject))
                    {
                        [self setValue:object forKey:varName];
                    }
                }
            }
        }
    }
    
    free(vars);
}

@end
