//
//  iOSOnvif.h
//  iOSOnvif
//
//  Created by InkaMacAir on 2017. 3. 25..
//  Copyright © 2017년 sungju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iOSOnvif : NSObject {
    NSString *cameraUrl;
    NSString *user;
    NSString *pass;
}

- (id)initWithCameraPath:(NSString*)cameraPath userId:(NSString*)userId password:(NSString*)password;

- (NSURL*)getStreamUrl;

@end
