//
//  SelectFamilyMemberTableViewCell.h
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>

@interface SelectFamilyMemberTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *radioImage;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;


@end
