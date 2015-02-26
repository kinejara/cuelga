//
//  AppDelegate.m
//  cuelga
//
//  Created by Jorge Villa on 1/22/15.
//  Copyright (c) 2015 kineticsdk. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic, strong) CTCallCenter *callCenter;
@property (nonatomic) BOOL isOnCall;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self styling];
    [self askForPushNotifications];
    [self callHandler];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[self setNotificationWithDate:[self nextNotificationDate]];
    
    // Declare the start of a background task
    // If you do not do this then the mainRunLoop will stop
    // firing when the application enters the background
   
    UIBackgroundTaskIdentifier bgTask = 0;
    
    NSLog(@"=== DID ENTER BACKGROUND ===");
    bgTask = [[UIApplication  sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"End of tolerate time. Application should be suspended now if we do not ask more 'tolerance'");
        // [self askToRunMoreBackgroundTask]; This code seems to be unnecessary. I'll verify it.
    }];
    
    if (bgTask == UIBackgroundTaskInvalid) {
        NSLog(@"This application does not support background mode");
    } else {
        //if application supports background mode, we'll see this log.
        NSLog(@"Application will continue to run in background");
    }
     
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)styling {
    
    UIColor *green = [UIColor colorWithRed:0 / 255.0f green:171 / 255.0f blue:199 / 255.0f alpha:1.0f];
    
    [[UINavigationBar appearance] setBarTintColor:green];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Roboto-Regular" size:22.0f],
                                                            }];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:green];
}

- (void)askForPushNotifications {
    //[[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:
                                                                         UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
}

- (void)setCallNotification {
    
    NSInteger minutesFromSettings = CUELGAStoreMinutes;
    
    [NSTimer scheduledTimerWithTimeInterval:minutesFromSettings*60-12
                                     target:self
                                   selector:@selector(showNotification)
                                   userInfo:nil
                                    repeats:NO
     ];
}

- (void)callHandler {
    
    __weak typeof(self)weakSealf = self;
    
    self.callCenter = [[CTCallCenter alloc] init];
    
    [self.callCenter setCallEventHandler:^(CTCall *call) {
        
        if ([call.callState isEqualToString: CTCallStateConnected]) {
            NSLog(@"Connected");
            weakSealf.isOnCall = YES;
        }
        else if ([call.callState isEqualToString: CTCallStateDialing]) {
            NSLog(@"Dialing");
        }
        else if ([call.callState isEqualToString: CTCallStateDisconnected]) {
            NSLog(@"Disconnected");
            weakSealf.isOnCall = NO;
            
        } else if ([call.callState isEqualToString: CTCallStateIncoming]) {
            NSLog(@"Incomming");
        }
    }];
}

- (void)showNotification {
    // we substract -12
    if (self.isOnCall) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeInterval:1  sinceDate:[NSDate date]];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        //TODO: translate this alertBody
        localNotification.alertBody = @"Cuelga !!!";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = 0;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}

@end
