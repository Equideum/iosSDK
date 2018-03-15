//
//  LogHeaderView.m
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "LogHeaderView.h"
#import "Constants.h"

@implementation LogHeaderView

- (IBAction)closeButtonTapped:(id)sender {
    DebugLog(@"");
    [self.delegate closeButtonTapped];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
