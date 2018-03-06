//
//  PermissionSummaryViewController.h
//  mHealthDAP
//
//

#import <UIKit/UIKit.h>
#import "APIhandler.h"

@interface PermissionSummaryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,Delegation>


@property (nonatomic, strong) NSMutableArray *permissionsArray;
@property (nonatomic, strong) NSMutableArray *permissionsFamilyArray;
@property (nonatomic, strong) NSMutableArray *finalFamilyPermissionDataArray;


@end
