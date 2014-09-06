//
//  UtilTests.m
//  iWardrobe
//
//  Created by Vito on 9/6/14.
//  Copyright (c) 2014 Vito. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IWStringGenerator.h"

@interface UtilTests : XCTestCase

@end

@implementation UtilTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGenerateUniqueID {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSDate *date = [formatter dateFromString:@"20140906124643333"];
    NSString *uniqueID = [IWStringGenerator uniqueIDWithDate:date];
    
    XCTAssertTrue([uniqueID isEqualToString:@"20140906124643333"], @"Should the same date id");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
