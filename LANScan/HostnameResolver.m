//
//  HostnameResolver.m
//  TestApp
//
//  Created by Ville Välimaa on 21/01/2017.
//  Copyright © 2017 Ville Välimaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostnameResolver.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <netdb.h>

@implementation HostnameResolver

+ (NSString *)getHostFromIPAddress:(const char*)ipAddress {
    NSString *hostName = nil;
    int error;
    struct addrinfo *results = NULL;
    
    error = getaddrinfo(ipAddress, NULL, NULL, &results);
    if (error != 0)
    {
        NSLog (@"Could not get any info for the address");
        return nil;
    }
    
    for (struct addrinfo *r = results; r; r = r->ai_next)
    {
        char hostname[NI_MAXHOST] = {0};
        error = getnameinfo(r->ai_addr, r->ai_addrlen, hostname, sizeof hostname, NULL, 0 , 0);
        if (error != 0)
        {
            continue;
        }
        else
        {
            NSLog (@"Found hostname: %s", hostname);
            hostName = [NSString stringWithFormat:@"%s", hostname];
            break;
        }
    }
    return hostName;
}

@end
