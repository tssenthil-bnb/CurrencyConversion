//
//  RequestManagerDelegate.h
//  CurrencyExchange
//
//  Created by Senthil Kumar T.S on 1/18/16.
//  Copyright © 2016 Senthil Kumar T.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RequestManager;
@protocol RequestManagerDelegate <NSObject>

- (void)requestSucceded:(RequestManager *)requestHandler;
- (void)requestFailed:(RequestManager *)requestHandler withError:(NSError *)error;

@end
