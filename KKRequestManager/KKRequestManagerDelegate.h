//
//  KKRequestManagerDelegate.h
//  KKRequestManager
//
//  Created by Tolga Seremet on 8.10.2018.
//  Copyright © 2018 Tolga Seremet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KKRequestManager;

/**
 * @protocol KKRequestManagerDelegate
 * @brief The KKRequestManagerDelegate protocol.
 * This protocol is used as a delegate for KKRequest manager response actions.
 */

@protocol KKRequestManagerDelegate <NSObject>

/**
 * Successfully got a response from the endpoint.
 * @param requestManager KKRequestManager object returning the response.
 * @param responseData NSData object contains the response.
 * @param responseCode NSInteger HTTPResponse code form the endpoint.
 */
- (void)requestManager:(KKRequestManager *)requestManager
        didReceiveData:(NSData *)responseData
      withResponseCode:(NSInteger)responseCode;

/**
 * Failed to receive a response from the endpoint.
 * @param requestManager KKRequestManager object returning the response.
 * @param error NSError object contains the endpoint's error.
 */
- (void)requestManager:(KKRequestManager *)requestManager
  didFailToReceiveData:(NSError *)error;

@end
