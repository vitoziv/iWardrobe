//
//  IWDebugUtil.m
//  iWardrobe
//
//  Created by Vito on 9/25/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import "IWDebugUtil.h"
#import "Tag+Service.h"
#import "Item+Service.h"
#import "Look+IW_Service.h"
#import "IWContextManager.h"

@implementation IWDebugUtil
+ (void)setupData
{
    [Tag insertWithName:@"Convert" inContext:[IWContextManager sharedContext]];
    [Tag insertWithName:@"Nike" inContext:[IWContextManager sharedContext]];
    [Tag insertWithName:@"Summer" inContext:[IWContextManager sharedContext]];
    
    UIImage *image1 = [UIImage imageNamed:@"1.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"2.jpg"];
    UIImage *image3 = [UIImage imageNamed:@"3.jpg"];
    UIImage *image4 = [UIImage imageNamed:@"4.jpg"];
    UIImage *image5 = [UIImage imageNamed:@"5.jpg"];
    UIImage *image6 = [UIImage imageNamed:@"6.jpg"];
    Item *item1 = [Item createItemWithImage:image1 imageMetaData:nil];
    item1.name = @"New Balance Men's MR10 Minimus Road Running Shoe";
    item1.note = @"New Balance, is dedicated to helping athletes achieve their goals. It's been their mission for more than a century. It's why they don't spend money on celebrity endorsements. They spend it on research and development. It's why they don't design products to fit an image. They design them to fit. New Balance is driven to make the finest shoes for the same reason athletes lace them up: to achieve the very best.";
    item1.brand = @"New Balance";
    item1.price = [[NSDecimalNumber alloc] initWithString:@"78.56"];
    item1.currencyLocale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
    
    Item *item2 = [Item createItemWithImage:image2 imageMetaData:nil];
    item2.name = @"New Balance Men's MR10 Minimus Road Running Shoe";
    item2.note = @"New Balance, is dedicated to helping athletes achieve their goals. It's been their mission for more than a century. It's why they don't spend money on celebrity endorsements. They spend it on research and development. It's why they don't design products to fit an image. They design them to fit. New Balance is driven to make the finest shoes for the same reason athletes lace them up: to achieve the very best.";
    item2.brand = @"New Balance";
    item2.price = [[NSDecimalNumber alloc] initWithString:@"78.23"];
    item2.currencyLocale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    Item *item3 = [Item createItemWithImage:image3 imageMetaData:nil];
    item3.name = @"New Balance Men's MR10 Minimus Road Running Shoe";
    item3.note = @"New Balance, is dedicated to helping athletes achieve their goals. It's been their mission for more than a century. It's why they don't spend money on celebrity endorsements. They spend it on research and development. It's why they don't design products to fit an image. They design them to fit. New Balance is driven to make the finest shoes for the same reason athletes lace them up: to achieve the very best.";
    item3.brand = @"New Balance";
    item3.price = [[NSDecimalNumber alloc] initWithString:@"78.39"];
    item3.currencyLocale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    
    Look *look1 = [Look createLookWithImage:image4 imageMetaData:nil inContext:nil];
    look1.name = @"Beautees Big Girls' All You Need Is Love Top";
    look1.note = @"See our full selection, shop by category, discover related brands, and more.";
    look1.items = [NSSet setWithArray:@[item1, item2, item3]];
    
    Look *look2 = [Look createLookWithImage:image5 imageMetaData:nil inContext:nil];
    look2.name = @"Beautees Big Girls' All You Need Is Love Top";
    look2.note = @"See our full selection, shop by category, discover related brands, and more.";
    look2.items = [NSSet setWithArray:@[item1, item2, item3]];
    
    Look *look3 = [Look createLookWithImage:image6 imageMetaData:nil inContext:nil];
    look3.name = @"Beautees Big Girls' All You Need Is Love Top";
    look3.note = @"See our full selection, shop by category, discover related brands, and more.";
    look3.items = [NSSet setWithArray:@[item1, item2, item3]];
}
@end
