//
//  AddCSIViewController.h
//  mHealthDApp
//
//  Created by bhavesh devnani on 26/12/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCSIViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *txtCSI;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtGender;
@property (strong, nonatomic) IBOutlet UIButton *btnback;
@property (strong, readwrite) NSString *strFromScreen;

@end
