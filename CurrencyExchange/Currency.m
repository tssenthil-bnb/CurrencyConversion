//
//  Currency.m
//  CurrencyExchange
//
//  Created by Senthil Kumar T.S on 1/18/16.
//  Copyright © 2016 Senthil Kumar T.S. All rights reserved.
//

#import "Currency.h"

@implementation Currency

// Initialize the class with dictionary.
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        
        @try {
            
            self.currencyCode = [dictionary objectForKey:@"Code"];
            self.currencyRate = [dictionary objectForKey:@"Rate"];
        }
        @catch (NSException *exception) {
            
            NSLog(@"Null pointer exception");
        }
    }
    
    return self;
}

@end
