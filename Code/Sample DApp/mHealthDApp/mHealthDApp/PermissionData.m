//
//  PermissionData.m
//  mHealthDAP
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "PermissionData.h"

@implementation PermissionData
@synthesize startDate,endDate,checked,index,userType,firstName,LastName,isWritePermissionDone;

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:startDate forKey:@"startDate"];
    [encoder encodeObject:endDate  forKey:@"endDate"];
    [encoder encodeInt:index forKey:@"index"];
    [encoder encodeBool:checked forKey:@"checked"];
    [encoder encodeObject:userType forKey:@"userType"];
    [encoder encodeObject:firstName forKey:@"firstName"];
    [encoder encodeObject:LastName forKey:@"lastName"];
    [encoder encodeObject:isWritePermissionDone forKey:@"isWritePermissionDone"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        startDate = [decoder decodeObjectForKey:@"startDate"];
        endDate = [decoder decodeObjectForKey:@"endDate"];
        index = [decoder decodeIntForKey:@"index"];
       checked = [decoder decodeBoolForKey:@"checked"];
        userType = [decoder decodeObjectForKey:@"userType"];
        firstName = [decoder decodeObjectForKey:@"firstName"];
        LastName = [decoder decodeObjectForKey:@"lastName"];
        isWritePermissionDone = [decoder decodeObjectForKey:@"isWritePermissionDone"];


    }
    return self;
}
-(id)init{
    self = [super init];
    startDate=@"";
    endDate=@"";
    checked=NO;
    index= -1;
    userType=@"";
    firstName=@"";
    LastName=@"";
    isWritePermissionDone=@"no";
    
    return self;
}
@end
