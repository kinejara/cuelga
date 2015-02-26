//
//  NSString+PNGValidation.m
//  pangeapayments
//
//  Created by Jorge on 2/19/15.
//  Copyright (c) 2015 gopangea. All rights reserved.
//

#import "NSString+PNGValidation.h"

@implementation NSString (PNGValidation)

+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber
{
    NSError *error;
    NSDataDetector *matchdetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber
                                                                    error:&error];
    
    return [matchdetector numberOfMatchesInString:phoneNumber options:0 range:NSMakeRange(0, [phoneNumber length])];
}

@end
