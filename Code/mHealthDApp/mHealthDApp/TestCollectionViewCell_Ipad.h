//
//  TestCollectionViewCell_Ipad.h
//  AAII_Project
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>
@protocol TestCollectionViewCellIpadDelegate<NSObject>
-(void)navigationButtonTappedForIpadWithTag:(NSInteger)tag;

@end

@interface TestCollectionViewCell_Ipad : UICollectionViewCell
@property (nonatomic, weak) id<TestCollectionViewCellIpadDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *navigationButton;
@property(nonatomic,retain)IBOutlet UILabel *lblTxt;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@end
