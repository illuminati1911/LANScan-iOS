//
//  HostnameResolver.h
//  TestApp
//
//  Created by Ville Välimaa on 21/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

#ifndef HostnameResolver_h
#define HostnameResolver_h

#import <Foundation/Foundation.h>

@interface HostnameResolver : NSObject

+ (NSString *)getHostFromIPAddress:(const char*)ipAddress;

@end

#endif /* HostnameResolver_h */
