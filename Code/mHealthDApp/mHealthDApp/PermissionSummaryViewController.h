//
//  PermissionSummaryViewController.h
//  mHealthDAP
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>
#import "APIhandler.h"

@interface PermissionSummaryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,Delegation>


@property (nonatomic, strong) NSMutableArray *permissionsArray;
@property (nonatomic, strong) NSMutableArray *permissionsFamilyArray;
@property (nonatomic, strong) NSMutableArray *finalFamilyPermissionDataArray;


@end
