//
//  CurrentRequestTests.m
//  CurrencyExchange
//
//  Created by Senthil Kumar T.S on 1/19/16.
//  Copyright © 2016 Senthil Kumar T.S. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Currency.h"

@interface CurrentRequestTests : XCTestCase

@end

@implementation CurrentRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testCurrencyData {
    
    Currency *usdCurrency = [[Currency alloc] initWithDictionary: @{@"Code" : @"USD",
                                                                 @"Rate" : @"1.95"}];
    
    XCTAssertNotNil(usdCurrency.currencyRate);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
