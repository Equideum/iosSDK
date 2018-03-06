//
//  AddCSIViewController.h
//  mHealthDApp
//
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
