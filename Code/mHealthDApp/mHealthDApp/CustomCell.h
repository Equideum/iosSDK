//
//  CustomCell.h
//  DoctorList
//
//  Created by Bhavesh Ashok Devnani on 11/13/17.
//  Copyright © 2017 Bhavesh Ashok Devnani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UILabel *fromAndToLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@end
