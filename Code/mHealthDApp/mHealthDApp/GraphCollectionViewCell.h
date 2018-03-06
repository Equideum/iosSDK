//
//  GraphCollectionViewCell.h
//  MHealthApp
//
//

#import <UIKit/UIKit.h>

@interface GraphCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *dot_image;
@property (strong, nonatomic) IBOutlet UILabel *date_label;
@property (strong, nonatomic) IBOutlet UILabel *detection_label;
@property (strong, nonatomic) IBOutlet UILabel *exercise_label;

@end
