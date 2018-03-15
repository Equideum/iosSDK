//
//  DocCollectionViewCell.h
//  TestDCS
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>

@interface DocCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *docImg;
@property (weak, nonatomic) IBOutlet UILabel *docName;
@property (weak, nonatomic) IBOutlet UILabel *docType;

@end
