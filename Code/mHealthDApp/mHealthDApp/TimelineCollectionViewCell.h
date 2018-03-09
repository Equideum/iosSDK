//
//  TimelineCollectionViewCell.h
//  MHealthApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>

@interface TimelineCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *mg_label;
@property (strong, nonatomic) IBOutlet UIImageView *timelineImage;
@property (strong, nonatomic) IBOutlet UILabel *level_label;
@property (strong, nonatomic) IBOutlet UILabel *percentage_label;
@property (strong, nonatomic) IBOutlet UIImageView *exercise_image;
@property (strong, nonatomic) IBOutlet UIImageView *diet_image;
@property (strong, nonatomic) IBOutlet UIImageView *medicineimage;
@property (strong, nonatomic) IBOutlet UILabel *exercise_label;
@property (strong, nonatomic) IBOutlet UILabel *diet_label;
@property (strong, nonatomic) IBOutlet UILabel *medicine_label;
@property (strong, nonatomic) IBOutlet UILabel *note_label;
@property (strong, nonatomic) IBOutlet UILabel *date_label;
@property (strong, nonatomic) IBOutlet UILabel *month_label;

@end
