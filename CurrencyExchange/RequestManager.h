//
//  RequestManager.h
//  CurrencyExchange
//
//  Created by Senthil Kumar T.S on 1/18/16.
//  Copyright © 2016 Senthil Kumar T.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManagerDelegate.h"

@interface RequestManager : NSObject {
    
    // the data returned by the server.
    id _responseData;
    // Response message.
    NSString *_message;
    
    // Response data.
    NSMutableData *_data;
    
    // Connection object.
    NSURLConnection *_connection;
    
    // Request object.
    NSMutableURLRequest *_request;
    // Request handler delegate.
    id<RequestManagerDelegate> _delegate;
}

// the data returned by the server.
@property (nonatomic, readonly) id responseData;

// Connection object.
@property (nonatomic, strong) NSURLConnection *connection;

// Request handler delegate.
@property (nonatomic, strong) id<RequestManagerDelegate> delegate;

// Initialize the class with delegate.
- (id)initWithURL:(NSURL *)url delegate:(id)delegate;

// Method to call when requesting data from server.
- (void)startRequest;

// Method to call for cancelling the web request.
- (void)cancel;

@end
