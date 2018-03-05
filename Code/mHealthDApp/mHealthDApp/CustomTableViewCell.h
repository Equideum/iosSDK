//
//  CustomTableViewCell.h
//  MHealthApp
//
//  Created by Sonam Agarwal on 11/10/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *checkBtn;

@property (strong, nonatomic) IBOutlet UILabel *cell_title;
@property (strong, nonatomic) IBOutlet UILabel *cell_subtitle;

@property (weak, nonatomic) IBOutlet UIView *viewOptionalLine;


@end
