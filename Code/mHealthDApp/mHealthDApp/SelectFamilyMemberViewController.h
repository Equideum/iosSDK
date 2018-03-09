//
//  SelectFamilyMemberViewController.h
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "APIhandler.h"
#import "TestCollectionViewCell.h"
#import "TestCollectionViewCell_Ipad.h"

@interface SelectFamilyMemberViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,HeaderViewDelegate,Delegation,TestCollectionViewCellDelegate,TestCollectionViewCellIpadDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *userCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionOne;

@end
