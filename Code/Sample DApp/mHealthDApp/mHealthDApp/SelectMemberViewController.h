//
//  SelectMemberViewController.h
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "ViewController.h"
//#import "APIhandler.h"
#import "mHealthApiHandler/mHealthApiHandler.h"

@interface SelectMemberViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,apiDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *userCollectionView;
@property (weak, nonatomic) IBOutlet UIView *viewFromToDate;
@property (weak, nonatomic) IBOutlet UILabel *lblFromText;
@property (weak, nonatomic) IBOutlet UILabel *lblFromDate;
@property (weak, nonatomic) IBOutlet UILabel *lblToText;
@property (weak, nonatomic) IBOutlet UILabel *lblToDate;
@property (strong, nonatomic) IBOutlet UIView *viewAppIcon;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingToViewAppIcon;
@end
