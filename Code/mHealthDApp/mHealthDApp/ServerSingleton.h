//
//  ServerSingleton.h
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <Foundation/Foundation.h>

@interface ServerSingleton : NSObject
@property(nonatomic) time_t timeOffset;
+ (id) sharedServerSingleton;
- (void)checkTimeWithDate:(NSString *)serverTime;
- (time_t)time;
@end
