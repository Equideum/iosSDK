//
//  ViewGrantPermissionsViewController.h
//  mHealthDAP
//

//

#import <UIKit/UIKit.h>
#import "APIhandler.h"

@interface ViewGrantPermissionsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,Delegation>

@property (nonatomic, strong) NSMutableArray *permissionsArray;
@property (nonatomic, strong) NSMutableArray *permissionsFamilyArray;
@property(nonatomic,strong) NSMutableArray *filteredDoctorArray;
@property(nonatomic,strong)NSMutableArray *filteredFamilyArray;
@property(nonatomic,strong) NSMutableArray *filteredDoctorImgArray;
@property(nonatomic,strong) NSMutableArray *filteredFamilyImgArray;
@property(nonatomic,strong) NSMutableArray *filteredFamilyPermissionArray;
@property(nonatomic,strong) NSMutableArray *filteredDoctorPermissionArray;
@property BOOL isFiltered;
@property BOOL isFamilyFiltered;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *view1;








@end
