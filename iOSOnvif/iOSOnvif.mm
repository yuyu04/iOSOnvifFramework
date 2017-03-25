//
//  iOSONVIF.m
//  iOSONVIF
//
//  Created by InkaMacAir on 2017. 3. 25..
//  Copyright © 2017년 sungju. All rights reserved.
//

#import "iOSONVIF.h"
#import "onvifclient.hpp"

@implementation iOSOnvif : NSObject

- (id)initWithCameraPath:(NSString*)cameraPath userId:(NSString*)userId password:(NSString*)password {
    self = [super init];
    if(self != nil){
        cameraUrl = cameraPath;
        user = userId;
        pass = password;
    }
    
    return self;
}

- (NSURL*)getStreamUrl {
    std::string url = cameraUrl.UTF8String;
    std::string userId = self->user.UTF8String;
    std::string password =  self->pass.UTF8String;
    OnvifClientDevice onvifDevice(url, userId, password);
    _tds__GetCapabilitiesResponse capabilitiesResponse;
    
    onvifDevice.GetCapabilities();
    
    std::string mediaUrl;
    int value = onvifDevice.GetMediaUrl(mediaUrl);
    
    NSURL *nsUrl = [NSURL URLWithString:[NSString stringWithUTF8String:mediaUrl.c_str()]];
    NSURL *cameraNsUrl = [NSURL URLWithString:cameraUrl];
    
    NSString *changedPath = [NSString stringWithFormat:@"%@://%@:%@%@", nsUrl.scheme, cameraNsUrl.host, cameraNsUrl.port, nsUrl.path];
    
    OnvifClientMedia media(onvifDevice);
    _trt__GetProfilesResponse profiles;
    value = media.GetProfiles(profiles, changedPath.UTF8String);
    if (value != SOAP_OK) {
        return nil;
    }
    
    for (int i = 0; i < profiles.Profiles.size(); i++)
    {
        _trt__GetStreamUriResponse streamUrl;
        value = media.GetStreamUrl(profiles.Profiles[i]->token.c_str(), streamUrl, changedPath.UTF8String);
        if (value != SOAP_OK) {
            continue;
        }
        
        NSURL *returnUrl = [NSURL URLWithString:[NSString stringWithUTF8String:streamUrl.MediaUri->Uri.c_str()]];
        if (returnUrl != nil) {
            return returnUrl;
        }
    }
    
    return nil;
}

@end
