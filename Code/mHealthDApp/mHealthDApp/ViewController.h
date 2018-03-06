//
//  ViewController.h
//  mHealthDAP
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UILabel *label;
@property(strong,nonatomic) NSDictionary *dic;
@end

