//
//  FirstViewController.h
//  MHealthApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "PermissionController.h"
//#import "APIhandler.h"
#import "mHealthApiHandler/mHealthApiHandler.h"

@interface FirstViewController : UIViewController<apiDelegate>

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
