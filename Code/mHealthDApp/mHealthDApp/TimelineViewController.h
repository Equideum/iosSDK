//
//  TimelineViewController.h
//  MHealthApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "ViewController.h"
#import "APIhandler.h"


@interface TimelineViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,Delegation>
@property (strong, nonatomic) IBOutlet UICollectionView *collection;

@end
