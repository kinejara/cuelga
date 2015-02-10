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

#define CUELGAStoreNumbers [DNPStoreSettings arrayForKey:@"storeTeamsArray"]?([DNPStoreSettings arrayForKey:@"storeTeamsArray"]):(@[@""])

#define CUELGAStoreContacts [DNPStoreSettings arrayForKey:@"storeTeamsArray"]?([DNPStoreSettings arrayForKey:@"storeTeamsArray"]):(@[@"Selecciona un contacto presionando '+' "])

//#define CUELGAStoreNumbers [DNPStoreSettings dictionaryForKey:@"storeTeamsArray"]?([DNPStoreSettings dictionaryForKey:@"storeTeamsArray"]):(@{@"Selecciona un contacto presionando '+'":@""})

@interface CuelgaCommon : NSObject

@end
