//
//  KKRequestManager.h
//  KKRequestManager
//
//  Created by Tolga Seremet on 8.10.2018.
//  Copyright © 2018 Tolga Seremet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKRequestManagerDelegate.h"

@interface KKRequestManager : NSObject

/** HTTPMethod of Request Manager, default is KKRequestManagerHTTPMethodGet */
typedef NS_ENUM(NSInteger, KKRequestManagerHTTPMethod){
    KKRequestManagerHTTPMethodGet = 0,
    KKRequestManagerHTTPMethodPost
};

/**
 * Create an instance of KKRequestManager to make a request to an endpoint URL.
 * Example usage:
 * @code
 * [KKRequestManagerDelegate requestManagerWithDelegate:self];
 * @endcode
 * @param delegate An object conforms to <KKRequestManagerDelegate> protocol.
 * @return An instance of KKRequestManagerDelegate.
 */
+ (instancetype)requestManagerWithDelegate:(id<KKRequestManagerDelegate>)delegate;

/**
 * Set HTTP method, default method is Get.
 * Example usage:
 * @code
 * [_requestManager setHTTPMethod:KKRequestManagerHTTPMethodPost];
 * @endcode
 * @param method KKRequestManagerHTTPMethod http method.
 */
- (void)setHTTPMethod:(KKRequestManagerHTTPMethod)method;

/**
 * Set post parameters to be sent in post request's body.
 * Example usage:
 * @code
 * [_requestManager setPostParameters:@{@"age":@25}];
 * @endcode
 * @param parameters NSDictionary contains parameter key-value pairs.
 */
- (void)setPostParameters:(NSDictionary *)parameters;

/**
 * Start asynchronous load request.
 * Example usage:
 * @code
 * [_requestManager loadRequestForURL:@"http://myurl"];
 * @endcode
 * @param urlString NSString contains endpoint url.
 */
- (void)loadRequestForURL:(NSString *)urlString;
@end

