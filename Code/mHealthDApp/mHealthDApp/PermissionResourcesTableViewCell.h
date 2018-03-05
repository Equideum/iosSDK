//
//  PermissionResourcesTableViewCell.h
//  mHealthDApp
//
//  Created by bhavesh devnani on 06/12/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermissionResourcesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *optionalResourcesLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionsLabelTopConstraint;

@end
