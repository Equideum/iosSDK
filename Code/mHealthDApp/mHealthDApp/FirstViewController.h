//
//  FirstViewController.h
//  MHealthApp
//
//  Created by Sonam Agarwal on 11/13/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import "PermissionController.h"
#import "APIhandler.h"

@interface FirstViewController : UIViewController<Delegation>

typedef NS_ENUM(int,Usertype)
{
    UsertypePatient,
    UsertypeCareGiver,
    UsertypeBoth
    
};
@property(strong,nonatomic) NSDictionary *dic;
@property (strong, nonatomic) IBOutlet UIImageView *redcheck;
@property (strong, nonatomic) IBOutlet UIButton *patient_Btn;
@property (strong, nonatomic) IBOutlet UIButton *caregiver_Btn;
@property (strong, nonatomic) IBOutlet UIButton *bothButton;
- (IBAction)nextBtnCicked:(UIButton *)sender;
-(IBAction)patientButtonClicked:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *next;
@property (strong, nonatomic) IBOutlet UIImageView *redcheck2;
@property (strong, nonatomic) IBOutlet UIImageView *redcheck3;

-(IBAction)caregiverButtonClicked:(UIButton *)sender;

- (IBAction)bothButtonClicked:(id)sender;



@end
