//
//  GraphCollectionViewCell.h
//  MHealthApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>

@interface GraphCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *dot_image;
@property (strong, nonatomic) IBOutlet UILabel *date_label;
@property (strong, nonatomic) IBOutlet UILabel *detection_label;
@property (strong, nonatomic) IBOutlet UILabel *exercise_label;

@end
