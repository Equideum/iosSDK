//
//  HeaderView.m
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "HeaderView.h"

@implementation HeaderView

- (IBAction)closeButtonTapped:(id)sender {
    [self.delegate closeButtonTapped];
}

@end
