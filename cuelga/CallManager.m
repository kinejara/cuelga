//
//  CallManager.m
//  cuelga
//
//  Created by Jorge on 2/10/15.
//  Copyright (c) 2015 kineticsdk. All rights reserved.
//

#import "CallManager.h"

@implementation CallManager

+ (instancetype)sharedInstance {
    static CallManager *sharedInstance;
    
    if (!sharedInstance) {
        sharedInstance = [[CallManager alloc] init];
    }
    
    return sharedInstance;
}

- (NSURL *)formatPhoneNumber:(Contact *)contact {
    
    NSString *cleanedString = [[contact.phoneNumber componentsSeparatedByCharactersInSet:
                                [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
    NSString *phoneString = [NSString stringWithFormat:@"tel://%@",cleanedString];
    
    NSURL *phoneUrl = [NSURL URLWithString:phoneString];
    
    return phoneUrl;
}

- (void)timeOfNotification {
    
    
}

@end
