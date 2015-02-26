//
//  PNGPhoneNumberFormatter.m
//  pangeapayments
//
//  Created by Jorge on 2/19/15.
//  Copyright (c) 2015 gopangea. All rights reserved.
//

#import "PNGPhoneNumberFormatter.h"

@implementation PNGPhoneNumberFormatter


- (NSString *)stringForObjectValue:(id)anObject
{
    if (![anObject isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSMutableString *text = [NSMutableString stringWithString:[[anObject componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];
    
    [text insertString:@"(" atIndex:0];
    
    if (text.length > 3)
        [text insertString:@") " atIndex:4];
    
    if (text.length > 8)
        [text insertString:@"-" atIndex:9];
    
    if (text.length > 12) {
        text = [NSMutableString stringWithString:[text substringToIndex:13]];
    }
    
    return text;
}

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString  **)error
{
    BOOL returnValue = NO;
    
    if (obj) {
        *obj = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        returnValue = YES;
    }
    
    return returnValue;

}

@end
