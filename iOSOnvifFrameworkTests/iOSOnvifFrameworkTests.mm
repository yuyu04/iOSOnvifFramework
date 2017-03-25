//
//  iOSOnvifFrameworkTests.m
//  iOSOnvifFrameworkTests
//
//  Created by InkaMacAir on 2017. 3. 25..
//  Copyright © 2017년 sungju. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "iOSOnvifFramework.h"

@interface iOSOnvifFrameworkTests : XCTestCase

@end

@implementation iOSOnvifFrameworkTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetStreamUri {
    iOSOnvif *onvif = [[iOSOnvif alloc] initWithCameraPath:@"http://blaubit.co.kr:8899/onvif/device_service" userId:@"blaubit" password:@"1234"];
    
    NSURL *url = [onvif getStreamUrl];
    XCTAssert(url == nil);
}

@end
