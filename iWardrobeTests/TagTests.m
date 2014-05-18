//
//  TagTests.m
//  iWardrobe
//
//  Created by Vito on 5/18/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Tag+Service.h"

@interface TagTests : XCTestCase

@end

@implementation TagTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInsertTag
{
    NSString *tagName = @"Test Tag";
    Tag *tag = [Tag tagWithName:tagName inContext:nil];
    
    XCTAssertEqual(tag.name, tagName, @"Tag name should be right!");
}

@end
