//
//  CurrencyRequest.m
//  CurrencyExchange
//
//  Created by Senthil Kumar T.S on 1/18/16.
//  Copyright © 2016 Senthil Kumar T.S. All rights reserved.
//

#import "CurrencyRequest.h"
#import "RequestManager.h"
#import "CurrencyMacro.h"
#import "Currency.h"

@implementation CurrencyRequest 

// Initialize this class with delegate.
- (id)initWithDelegate:(id<CurrencyRequestDelegate>)delegate andCurrencyCode:(NSString *)currencyCode {
    
    self = [super init];
    
    if (self) {
        
        _delegate = delegate;
        _currencyCode = currencyCode;
        _currencies = [NSMutableArray array];
    }
    
    return self;
}

// Method to invoke fixer webservice.
- (void)startRequest {
    
    RequestManager *request = [[RequestManager alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IP_URL_BASE, _currencyCode]] delegate:self];
    [request startRequest];
}

// Method that encapsulates Currency data.
- (void)populateInfo:(NSDictionary *)rates {
    
    for (NSString *code in rates.allKeys) {
        
        Currency *currency =  [[Currency alloc] initWithDictionary: @{@"Code" : code,
                                                                      @"Rate" : [rates objectForKey:code]}];
        [_currencies addObject:currency];
    }
}

#pragma mark RequestHandlerDelegate

- (void)requestSucceded:(RequestManager *)requestHandler {
    
    [self populateInfo:requestHandler.responseData];
    [_delegate currencyRequestSucceded:self];
}

- (void)requestFailed:(RequestManager *)requestHandler withError:(NSError *)error {
    
    [self.delegate currencyRequestFailed:self withError:[error.userInfo objectForKey:@"message"]];
}

@end
