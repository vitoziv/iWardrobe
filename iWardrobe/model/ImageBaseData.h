//
//  ImageBaseData.h
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ImageBaseData : NSManagedObject

@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSString *note;
@property (nonatomic, retain) NSDictionary *imageMetaData;
@property (nonatomic, retain) UIImage *tempImage;
@property (nonatomic, retain) NSDate *createDate;
@property (nonatomic, retain) NSDate *modifyDate;

@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *locations;

+ (instancetype)createWithEntityName:(NSString *)name image:(UIImage *)image imageMetaData:(NSDictionary *)metaData;

@end

@interface ImageBaseData (IWAccessory)

- (UIImage *)image;

@end
