//
//  SelectMemberTableViewCell.m
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "SelectMemberTableViewCell.h"
#import "Constants.h"

@implementation SelectMemberTableViewCell

- (void)awakeFromNib {
    DebugLog(@"");
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    DebugLog(@"");
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
