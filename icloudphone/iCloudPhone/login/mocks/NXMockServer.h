//
//  NXMockServer.h
//  social
//
//  Created by nsc on 13-11-8.
//  Copyright (c) 2013年 itelland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface NXMockServer : NSObject
+(NXMockServer*)sharedServer;
-(AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
