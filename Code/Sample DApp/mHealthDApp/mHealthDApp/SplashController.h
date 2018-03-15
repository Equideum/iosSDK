//
//  SplashController.h
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>
//#import "APIhandler.h"
#import "mHealthApiHandler/mHealthApiHandler.h"


@interface SplashController : UIViewController<apiDelegate>
@property(strong,nonatomic) NSDictionary *dic;
@end
