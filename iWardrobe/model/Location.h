//
//  Location.h
//  iWardrobe
//
//  Created by Vito on 5/18/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, Look;

@interface Location : NSManagedObject

@property (nonatomic, strong) NSNumber * x;
@property (nonatomic, strong) NSNumber * y;
@property (nonatomic, strong) Look *look;
@property (nonatomic, strong) Item *item;

@end
