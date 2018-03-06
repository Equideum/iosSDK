//
//  PermissionResourcesTableViewCell.h
//  mHealthDApp
//
//

#import <UIKit/UIKit.h>

@interface PermissionResourcesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *optionalResourcesLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conditionsLabelTopConstraint;

@end
