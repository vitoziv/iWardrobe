//
//  TagTests.m
//  iWardrobe
//
//  Created by Vito on 5/18/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IWContextManager.h"
#import "Tag+Service.h"

static NSString *const kInsertTagName = @"Insert Test Tag";
static NSString *const kFetchTagName = @"Fetch Test Tag";
static NSString *const kTagForDeleteName = @"Test delete tag";

@interface TagTests : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation TagTests

- (void)setUp
{
    [super setUp];
    self.context = [[IWContextManager sharedInstance] managedObjectContext];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInsertTag
{
    Tag *tag = [Tag insertWithName:kInsertTagName inContext:self.context];
    XCTAssertEqual(tag.name, kInsertTagName, @"Tag name should be right!");
}

- (void)testFetchTag
{
    [Tag insertWithName:kFetchTagName inContext:self.context];
    
    Tag *fetchTag = [Tag tagWithName:kFetchTagName inContext:self.context];
    XCTAssertTrue([fetchTag.name isEqualToString:kFetchTagName], @"Fetch tag should have the same name");
}

- (void)testTagList
{
    NSArray *tags = [Tag tagListInContext:self.context];
    XCTAssertNotNil(tags, @"Tag list should not be nil, if no objects fetched, it should be a empty array");
}

- (void)testDeleteTag
{
    Tag *tag = [Tag insertWithName:kTagForDeleteName inContext:self.context];
    [Tag deleteTag:tag inContext:self.context];
    
    Tag *tagAfterDelete = [Tag tagWithName:kTagForDeleteName inContext:self.context];
    XCTAssertNil(tagAfterDelete, @"Tag should be nil, because it was deleted!");
}

@end
