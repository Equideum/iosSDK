//
//  CollectionHeaderView.h
//  MHealthApp
//
//

#import <UIKit/UIKit.h>

@interface CollectionHeaderView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *diabetestype_label;
@property (strong, nonatomic) IBOutlet UILabel *statelabel;
@property (strong, nonatomic) IBOutlet UIImageView *timeline_image;
@property (strong, nonatomic) IBOutlet UIImageView *graph_image;

@end
