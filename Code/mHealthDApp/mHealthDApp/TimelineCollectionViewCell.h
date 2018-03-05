//
//  TimelineCollectionViewCell.h
//  MHealthApp
//
//  Created by Sonam Agarwal on 11/15/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *mg_label;
@property (strong, nonatomic) IBOutlet UIImageView *timelineImage;
@property (strong, nonatomic) IBOutlet UILabel *level_label;
@property (strong, nonatomic) IBOutlet UILabel *percentage_label;
@property (strong, nonatomic) IBOutlet UIImageView *exercise_image;
@property (strong, nonatomic) IBOutlet UIImageView *diet_image;
@property (strong, nonatomic) IBOutlet UIImageView *medicineimage;
@property (strong, nonatomic) IBOutlet UILabel *exercise_label;
@property (strong, nonatomic) IBOutlet UILabel *diet_label;
@property (strong, nonatomic) IBOutlet UILabel *medicine_label;
@property (strong, nonatomic) IBOutlet UILabel *note_label;
@property (strong, nonatomic) IBOutlet UILabel *date_label;
@property (strong, nonatomic) IBOutlet UILabel *month_label;

@end
