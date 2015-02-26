//
//  AppDelegate.h
//  cuelga
//
//  Created by Jorge Villa on 1/22/15.
//  Copyright (c) 2015 kineticsdk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setCallNotification;


@end

