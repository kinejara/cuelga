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

#define CUELGAStoreNumbers [DNPStoreSettings arrayForKey:@"storeNumbers"]?([DNPStoreSettings arrayForKey:@"storeNumbers"]):(@[@""])
#define CUELGAStoreContacts [DNPStoreSettings arrayForKey:@"storeNames"]?([DNPStoreSettings arrayForKey:@"storeNames"]):(@[@"Selecciona un contacto presionando '+' "])

#define CUELGAStoreMinutes [DNPStoreSettings integerForKey:@"storeMinutes"]?([DNPStoreSettings integerForKey:@"storeMinutes"]):(5)
#define CUELGAStoreSound [DNPStoreSettings stringForKey:@"storeSound"]?([DNPStoreSettings stringForKey:@"storeSound"]):@"Default2.mp3"


#define CUELGAStoreFirstTime [DNPStoreSettings boolForKey:@"storePreviousLaunch"]

#define ALERT_WITH_ACTIONS(aTitle, aMessage, aController, actions, style) \
UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:style]; \
for (UIAlertAction *action in actions) { \
[alertController addAction:action]; \
} \
[aController presentViewController:alertController animated:YES completion:nil]; \


//#define CUELGAStoreNumbers [DNPStoreSettings dictionaryForKey:@"storeTeamsArray"]?([DNPStoreSettings dictionaryForKey:@"storeTeamsArray"]):(@{@"Selecciona un contacto presionando '+'":@""})

@interface CuelgaCommon : NSObject

@end
