//
//  PermissionResourcesTableViewCell.h
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>

@interface PermissionResourcesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *optionalResourcesLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionsLabelTopConstraint;

@end
