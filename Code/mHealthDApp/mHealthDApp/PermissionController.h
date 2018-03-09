//
//  ViewController.h
//  MHealthApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import "APIhandler.h"

@interface PermissionController : UIViewController<UITableViewDelegate,UITableViewDataSource,Delegation>
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *acceptBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *viewForButtons;

@property (nonatomic) BOOL isFromViewGrantedPermission;

@property (nonatomic, strong) NSMutableArray *permissionsArray;
@property (nonatomic, strong) NSMutableArray *permissionsFamilyArray;
@property(strong,nonatomic) NSDictionary *dic;
@end

