//
//  TimeLineHeader.h
//  MHealthApp
//
//  Created by Sonam Agarwal on 11/15/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineHeader : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UIImageView *graph_image;
@property (strong, nonatomic) IBOutlet UILabel *diabetestype_label;
@property (strong, nonatomic) IBOutlet UILabel *state_label;

@end
