//
//  ViewController.h
//  MHealthApp
//
//  Created by Sonam Agarwal on 11/10/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

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

