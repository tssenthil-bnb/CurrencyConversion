//
//  RequestManager.m
//  CurrencyExchange
//
//  Created by Senthil Kumar T.S on 1/18/16.
//  Copyright © 2016 Senthil Kumar T.S. All rights reserved.
//

#import "RequestManager.h"
#import "CurrencyMacro.h"

@implementation RequestManager

// Initialize the class with delegate.
- (id)initWithURL:(NSURL *)url delegate:(id)delegate  {
    
    self = [super init];
    if (self) {
        
        _delegate = delegate;
        _request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:TIMEOUT_INTERVAL];
    }
    
    return self;
}

// Method to call when requesting data from server.
- (void)startRequest {
    
    [_request setHTTPMethod:@"GET"];
    [_request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [_request setHTTPShouldHandleCookies:YES];
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:TRUE];
}

// Method to call for cancelling the web request.
- (void)cancel {
    
    if (_connection) {
        
        [_connection cancel];
        _connection = nil;
        _request = nil;
        _data = nil;
    }
}

- (void)requestSucceeded {
    
    [_delegate requestSucceded:self];
}

- (void)requestFailed:(NSError*) error {
    
    [_delegate requestFailed:self withError:error];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self performSelectorOnMainThread:@selector(requestFailed:) withObject:error waitUntilDone:FALSE];
    _data = nil;
    _connection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *jsonString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *serverData = nil;
    
    @try {
        serverData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&error];
        if (![serverData isKindOfClass:[NSDictionary class]]) {
            error = [NSError errorWithDomain:@"JsonParseError" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Our server didnt understand your request.  Try again.", @"message", nil]];
            serverData = nil;
        }
    }
    @catch (NSException *exception) {
        error = [NSError errorWithDomain:@"JsonParseError" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Error processing server data", @"message", nil]];
    }
    
    if ([serverData objectForKey:@"error"]) {
        
        _message = [serverData objectForKey:@"error"];
        error = [NSError errorWithDomain:@"Error" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_message, @"message", nil]];
        [self performSelectorOnMainThread:@selector(requestFailed:) withObject:error waitUntilDone:FALSE];
    } else {
        
        _responseData = [serverData objectForKey:@"rates"];
        [self performSelectorOnMainThread:@selector(requestSucceeded) withObject:nil waitUntilDone:FALSE];
    }
    
    _data = nil;
    _connection = nil;
}

@end
