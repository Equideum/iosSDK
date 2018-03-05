//
//  CollectionHeaderView.h
//  MHealthApp
//
//  Created by Sonam Agarwal on 11/14/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionHeaderView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *diabetestype_label;
@property (strong, nonatomic) IBOutlet UILabel *statelabel;
@property (strong, nonatomic) IBOutlet UIImageView *timeline_image;
@property (strong, nonatomic) IBOutlet UIImageView *graph_image;

@end
