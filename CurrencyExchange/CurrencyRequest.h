//
//  CurrencyRequest.h
//  CurrencyExchange
//
//  Created by Senthil Kumar T.S on 1/18/16.
//  Copyright © 2016 Senthil Kumar T.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CurrencyRequest;
@protocol CurrencyRequestDelegate <NSObject>

- (void)currencyRequestSucceded:(CurrencyRequest *)currencyRequest;
- (void)currencyRequestFailed:(CurrencyRequest *)currencyRequest withError:(NSString *)error;

@end
@interface CurrencyRequest : NSObject

// Holds the currency code.
@property (nonatomic, readonly) NSString *currencyCode;

// Holds all the currency modal.
@property (nonatomic, retain) NSMutableArray *currencies;

// Delegate of this class.
@property (nonatomic, weak) id<CurrencyRequestDelegate> delegate;

// Initialize this class with delegate.
- (id)initWithDelegate:(id<CurrencyRequestDelegate>)delegate andCurrencyCode:(NSString *)currencyCode;

// Method to invoke fixer webservice.
- (void)startRequest;

@end
