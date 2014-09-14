//
//  ItemTests.m
//  iWardrobe
//
//  Created by Vito on 5/22/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IWContextManager.h"
#import "Item+Service.h"

@interface ItemTests : XCTestCase

@end

@implementation ItemTests

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

- (void)testInsertItem
{
    Item *newItem = [Item createItem];
    XCTAssertNotNil(newItem, @"Create a new item should not be nil");
}

- (void)testFetchItem
{
    NSArray *items = [Item allItems];
    XCTAssertTrue([items isKindOfClass:[NSArray class]], @"Fetch items should be a NSArray");
}

- (void)testDeleteItem
{
    Item *newItem = [Item createItem];
    XCTAssertNotNil(newItem, @"Create a new item should not be nil");
    
    [Item deleteItem:newItem];
    XCTAssertTrue(newItem.deleted, @"Item should be delete");
}

@end
