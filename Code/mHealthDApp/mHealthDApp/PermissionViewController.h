//
//  PermissionViewController.h
//  FBlocksCSA
//
//  Created by dhaval tannarana on 30/01/18.
//  Copyright © 2018 bhavesh devnani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermissionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIView *viewDoctorImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgDoctor;
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocDesignation;

@property (weak, nonatomic) IBOutlet UIImageView *imgCal;
@property (weak, nonatomic) IBOutlet UIImageView *imgCal2;
@property (weak, nonatomic) IBOutlet UIImageView *imgAppIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;

@property (weak, nonatomic) IBOutlet UIButton *btnDetails;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
@property (weak, nonatomic) IBOutlet UIImageView *imgCal1;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIImageView *imgMessage;

@property (nonatomic) BOOL isFromSecondScreen;

- (IBAction)btnDetailsClicked:(UIButton *)sender;
- (IBAction)btnRejectClicked:(UIButton *)sender;
- (IBAction)btnAcceptClicked:(UIButton *)sender;


@end
