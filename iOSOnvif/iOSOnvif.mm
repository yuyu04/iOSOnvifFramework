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

- (NSString*)chanagedHostPath:(NSString*)path {
    NSURL *nsUrl = [NSURL URLWithString:path];
    NSURL *cameraNsUrl = [NSURL URLWithString:cameraUrl];
    
    if (nsUrl == nil || cameraNsUrl == nil)
        return nil;
    
    NSString *changedPath = [NSString stringWithFormat:@"%@://%@:%@%@", nsUrl.scheme, cameraNsUrl.host, nsUrl.port, nsUrl.path];
    if (nsUrl.query != nil) {
        changedPath = [changedPath stringByAppendingFormat:@"?%@", nsUrl.query];
    }
    
    return changedPath;
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
    
    NSString *changedPath = [self chanagedHostPath:[NSString stringWithUTF8String:mediaUrl.c_str()]];
    OnvifClientMedia media(onvifDevice);
    _trt__GetProfilesResponse profiles;
    value = media.GetProfiles(profiles, changedPath.UTF8String);
    if (value != SOAP_OK) {
        return nil;
    }
    
    _trt__GetStreamUriResponse streamUrl;
    value = media.GetStreamUrl(profiles.Profiles[profiles.Profiles.size()-1]->token.c_str(), streamUrl, changedPath.UTF8String);
    if (value != SOAP_OK) {
        return nil;
    }
    
    NSString *changedRTSPPath = [self chanagedHostPath:[NSString stringWithUTF8String:streamUrl.MediaUri->Uri.c_str()]];
    if ([changedRTSPPath isEqualToString:@""]) {
        return nil;
    }
    
    return [NSURL URLWithString:changedRTSPPath];
    
    /*for (int i = 0; i < profiles.Profiles.size(); i++)
    {
        _trt__GetStreamUriResponse streamUrl;
        value = media.GetStreamUrl(profiles.Profiles[i]->token.c_str(), streamUrl, changedPath.UTF8String);
        if (value != SOAP_OK) {
            continue;
        }
        
        NSString *changedRTSPPath = [self chanagedHostPath:[NSString stringWithUTF8String:streamUrl.MediaUri->Uri.c_str()]];
    
        if (![changedRTSPPath isEqualToString:@""]) {
            return [NSURL URLWithString:changedRTSPPath];
        }
    }*/
}

@end
