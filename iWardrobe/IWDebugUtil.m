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
#import "Look+Service.h"
#import "IWContextManager.h"

@implementation IWDebugUtil
+ (void)setupData
{
    [IWContextManager saveOnBackContext:^(NSManagedObjectContext *backgroundContext) {
        [Tag insertWithName:@"Convert" inContext:backgroundContext];
        [Tag insertWithName:@"Nike" inContext:backgroundContext];
        [Tag insertWithName:@"Summer" inContext:backgroundContext];
        
        UIImage *image1 = [UIImage imageNamed:@"1.jpg"];
        UIImage *image2 = [UIImage imageNamed:@"2.jpg"];
        UIImage *image3 = [UIImage imageNamed:@"3.jpg"];
        UIImage *image4 = [UIImage imageNamed:@"4.jpg"];
        UIImage *image5 = [UIImage imageNamed:@"5.jpg"];
        UIImage *image6 = [UIImage imageNamed:@"6.jpg"];
        Item *item1 = [Item insertItemWithImage:image1 inContext:backgroundContext];

        Item *item2 = [Item insertItemWithImage:image2 inContext:backgroundContext];

        Item *item3 = [Item insertItemWithImage:image3 inContext:backgroundContext];
        
        Look *look1 = [Look createLookWithImage:image4 imageMetaData:nil inContext:backgroundContext];
        look1.items = [NSSet setWithArray:@[item1, item2, item3]];
        
        Look *look2 = [Look createLookWithImage:image5 imageMetaData:nil inContext:backgroundContext];
        look2.items = [NSSet setWithArray:@[item1, item2, item3]];
        
        Look *look3 = [Look createLookWithImage:image6 imageMetaData:nil inContext:backgroundContext];
        look3.items = [NSSet setWithArray:@[item1, item2, item3]];
    }];
    
}
@end
