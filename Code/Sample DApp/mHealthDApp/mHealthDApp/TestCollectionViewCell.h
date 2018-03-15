//
//  TestCollectionViewCell.h
//  TestDCS
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>

@protocol TestCollectionViewCellDelegate<NSObject>
-(void)navigationButtonTappedWithTag:(NSInteger)tag;

@end

@interface TestCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) id<TestCollectionViewCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *navigationButton;
@property(nonatomic,retain)IBOutlet UILabel *lblTxt;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@end
