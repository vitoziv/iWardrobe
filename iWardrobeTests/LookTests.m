//
//  LookTests.m
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IWContextManager.h"
#import "Look+IW_Service.h"

@interface LookTests : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation LookTests

- (void)setUp {
    [super setUp];
    self.context = [[IWContextManager sharedInstance] managedObjectContext];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInsert {
    UIImage *image = [UIImage imageNamed:@"test"];
    NSDictionary *metaData = @{@"city": @"xiamen"};
    Look *look = [Look saveLookWithImage:image imageMetaData:metaData inContext:self.context];
    XCTAssertTrue(look.tempImage == image && look.imageMetaData == metaData, @"Should save to look");
}

- (void)testFetchAll {
    NSArray *looks = [Look allLooksInContext:self.context];
    XCTAssertNotNil(looks, @"Featch looks should not be nil");
}

@end
