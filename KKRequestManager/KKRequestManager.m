//
//  KKRequestManager.m
//  KKRequestManager
//
//  Created by Tolga Seremet on 8.10.2018.
//  Copyright © 2018 Tolga Seremet. All rights reserved.
//

#import "KKRequestManager.h"

@interface KKRequestManager () <NSURLConnectionDelegate> @end

@implementation KKRequestManager {
    KKRequestManagerHTTPMethod _method;
    NSDictionary *_parameters;
    NSURLConnection *_connection;
    NSMutableData *_responseData;
    NSInteger _responseCode;
    __weak id<KKRequestManagerDelegate> _delegate;
}

#pragma mark - NSObject

+ (instancetype)requestManagerWithDelegate:(id<KKRequestManagerDelegate>)delegate {
    return [[[self class] alloc] initWithDelegate:delegate];
}

- (instancetype)initWithDelegate:(id<KKRequestManagerDelegate>)delegate {
    if (!(self = [super init]))
        return nil;
    _delegate = delegate;
    _method = KKRequestManagerHTTPMethodGet;
    return self;
}

#pragma mark - Setters

- (void)setHTTPMethod:(KKRequestManagerHTTPMethod)method {
    _method = method;
}

- (void)setPostParameters:(NSDictionary *)parameters {
    _parameters = parameters;
}

#pragma mark - Load

- (void)loadRequestForURL:(NSString *)urlString {
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    if (_method == KKRequestManagerHTTPMethodPost) {
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        request.HTTPBody = [KKRequestManager jsonDataWithDictionary:_parameters];
    }

    // Create url connection and fire request.
    _connection = [[NSURLConnection alloc]
                   initWithRequest:request
                   delegate:self
                   startImmediately:NO];

    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSDefaultRunLoopMode];
    [_connection start];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created.
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    _responseCode = [httpResponse statusCode];
        _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared.
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)[cachedResponse response];

    // Look up the cache policy used in our request.
    if([connection currentRequest].cachePolicy == NSURLRequestUseProtocolCachePolicy) {
        NSDictionary *headers = [httpResponse allHeaderFields];
        NSString *cacheControl = [headers valueForKey:@"Cache-Control"];
        NSString *expires = [headers valueForKey:@"Expires"];
        if((cacheControl == nil) && (expires == nil)) {
            return nil; // don't cache this.
        }
    }
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // return to delegate.
    [_delegate requestManager:self didReceiveData:[NSData dataWithData:_responseData] withResponseCode:_responseCode];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
        [_delegate requestManager:self didFailToReceiveData:error];
}

#pragma mark - Utilities

+ (NSData *)jsonDataWithDictionary:(NSDictionary *)dictionary {

    NSError *error;
    NSData *data =  [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error) {
        return nil;
    }

    return data;
}

+ (NSData *)jsonDataWithArray:(NSArray *)array {

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    }

    return jsonData;
}

@end
