//
//  ImageBaseData.h
//  iWardrobe
//
//  Created by Vito on 9/13/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ImageBaseData : NSManagedObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) UIImage *tempImage;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifyDate;

@property (nonatomic, strong) NSOrderedSet *infos;
@property (nonatomic, strong) NSOrderedSet *tags;

+ (instancetype)insertWithimage:(UIImage *)image inContext:(NSManagedObjectContext *)context;

@end

@interface ImageBaseData (IWAccessory)

- (UIImage *)image;

@end
