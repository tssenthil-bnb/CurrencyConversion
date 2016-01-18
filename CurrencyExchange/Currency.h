//
//  Currency.h
//  CurrencyExchange
//
//  Created by Senthil Kumar T.S on 1/18/16.
//  Copyright © 2016 Senthil Kumar T.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property (nonatomic, readwrite) NSString *currencyCode;
@property (nonatomic, readwrite) NSString *currencyRate;

// Initialize the class with dictionary.
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
