//
//  TimelineViewController.h
//  MHealthApp
//
//

#import "ViewController.h"
#import "APIhandler.h"


@interface TimelineViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,Delegation>
@property (strong, nonatomic) IBOutlet UICollectionView *collection;

@end
