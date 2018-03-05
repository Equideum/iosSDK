//
//  PermissionSummaryViewController.h
//  mHealthDAP
//
//  Created by bhavesh devnani on 16/11/17.
//  Copyright © 2017 bhavesh devnani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIhandler.h"

@interface PermissionSummaryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,Delegation>


@property (nonatomic, strong) NSMutableArray *permissionsArray;
@property (nonatomic, strong) NSMutableArray *permissionsFamilyArray;
@property (nonatomic, strong) NSMutableArray *finalFamilyPermissionDataArray;


@end
