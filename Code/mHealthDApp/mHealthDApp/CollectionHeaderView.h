//
//  CollectionHeaderView.h
//  MHealthApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>

@interface CollectionHeaderView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *diabetestype_label;
@property (strong, nonatomic) IBOutlet UILabel *statelabel;
@property (strong, nonatomic) IBOutlet UIImageView *timeline_image;
@property (strong, nonatomic) IBOutlet UIImageView *graph_image;

@end
