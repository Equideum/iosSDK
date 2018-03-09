//
//  TestCollectionViewCell.m
//  TestDCS
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "TestCollectionViewCell.h"

@implementation TestCollectionViewCell
@synthesize lblTxt;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)navigationButtonDoubleTapped:(id)sender {
     UIButton *button = (UIButton *)sender;
    
    [self.delegate navigationButtonTappedWithTag:button.tag];
}

@end
