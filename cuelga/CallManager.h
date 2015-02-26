//
//  CallManager.h
//  cuelga
//
//  Created by Jorge on 2/10/15.
//  Copyright (c) 2015 kineticsdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface CallManager : NSObject

+ (instancetype)sharedInstance;

- (NSURL *)formatPhoneNumber:(Contact *)phoneNumber;

@end
