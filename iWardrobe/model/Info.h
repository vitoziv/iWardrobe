//
//  Info.h
//  iWardrobe
//
//  Created by Vito on 11/30/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Look;

@interface Info : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) Item *whichItem;
@property (nonatomic, retain) Look *whichLook;

@end
