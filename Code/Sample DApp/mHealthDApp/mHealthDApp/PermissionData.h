//
//  PermissionData.h
//  mHealthDAP
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <Foundation/Foundation.h>

@interface PermissionData : NSObject<NSCoding>
@property(nonatomic,strong)NSString *startDate;
@property(nonatomic,strong)NSString *endDate;
@property(nonatomic)BOOL checked;
@property(nonatomic)int index;
@property(nonatomic,strong)NSString *userType;
@property(nonatomic,strong)NSString *firstName;
@property(nonatomic,strong)NSString *LastName;
@property(nonatomic,strong)NSString *isWritePermissionDone;

-(id)init;
@end
