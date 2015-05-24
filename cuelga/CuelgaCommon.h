//
//  CuelgaCommon.h
//  cuelga
//
//  Created by Jorge Villa on 1/22/15.
//  Copyright (c) 2015 kineticsdk. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DNPGroupID @"com.cuelga.kine"
#define DNPStoreSettings [[NSUserDefaults alloc] initWithSuiteName:DNPGroupID]
//Contacts.instructions

#define CUELGAStoreNumbers [DNPStoreSettings arrayForKey:@"storeNumbers"]?([DNPStoreSettings arrayForKey:@"storeNumbers"]):(@[@""])
#define CUELGAStoreContacts [DNPStoreSettings arrayForKey:@"storeNames"]?([DNPStoreSettings arrayForKey:@"storeNames"]):(@[NSLocalizedString(@"Contacts.instructions", @"")])

#define CUELGAStoreMinutes [DNPStoreSettings integerForKey:@"storeMinutes"]?([DNPStoreSettings integerForKey:@"storeMinutes"]):(5)
#define CUELGAStoreSound [DNPStoreSettings stringForKey:@"storeSound"]?([DNPStoreSettings stringForKey:@"storeSound"]):@"Default.aiff"

//#define CUELGAStoreRuntimes [DNPStoreSettings integerForKey:@"runTimes"]?([DNPStoreSettings integerForKey:@"runTimes"]):(0)

#define CUELGAStoreFirstTime [DNPStoreSettings boolForKey:@"storePreviousLaunch"]

#define ALERT_WITH_ACTIONS(aTitle, aMessage, aController, actions, style) \
UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:style]; \
for (UIAlertAction *action in actions) { \
[alertController addAction:action]; \
} \
[aController presentViewController:alertController animated:YES completion:nil]; \

#define appstoreURL @"https://itunes.apple.com/us/app/hang-up-a-call/id604715697?mt=8";


//#define CUELGAStoreNumbers [DNPStoreSettings dictionaryForKey:@"storeTeamsArray"]?([DNPStoreSettings dictionaryForKey:@"storeTeamsArray"]):(@{@"Selecciona un contacto presionando '+'":@""})

@interface CuelgaCommon : NSObject

@end
