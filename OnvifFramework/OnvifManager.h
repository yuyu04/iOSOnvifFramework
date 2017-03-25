//
//  OnvifManager.h
//  OnvifFramework
//
//  Created by InkaMacAir on 2017. 3. 25..
//  Copyright © 2017년 sungju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnvifManager : NSObject

- (NSURL)getStreamUri:(NSString*)cameraUrl;

@end
