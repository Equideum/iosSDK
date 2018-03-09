//
//  HeaderView.h
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegate<NSObject>
@required
-(void)closeButtonTapped;
@end
@interface HeaderView : UIView
@property(weak,nonatomic) id <HeaderViewDelegate> delegate;
@end
