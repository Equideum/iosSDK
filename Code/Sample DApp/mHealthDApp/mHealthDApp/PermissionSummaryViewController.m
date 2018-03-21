//
//  PermissionSummaryViewController.m
//  mHealthDAP
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "PermissionSummaryViewController.h"
#import "CustomCell.h"
#import "PermissionData.h"
#import "ViewController.h"
#import "UICKeyChainStore.h"
//#import "APIhandler.h"
#import "Constants.h"
#import "mHealthDApp-Swift.h"
#import "PermissionController.h"
#import "ServerSingleton.h"
#import "DejalActivityView.h"
#import "PermissionResourcesDetailsViewController.h"

@interface PermissionSummaryViewController ()
{
    NSArray *imgArray;
    NSArray *imgFamilyArray;
    NSArray *titleArray;
    NSArray *titleFamilyArray;
    NSArray *csiArray;
    NSMutableArray *csiFamilyArray;
    //APIhandler *h;
    mHealthApiHandler *apiHandler;
    SecKeyAlgorithm algorithm;
    NSString * derKeyString;
    SecKeyRef privateKey;
    NSDictionary *modelDictionary;
    NSString * urlEncodedString;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
//    NSString *endpoint;
    NSDictionary *request_dic;
    NSDictionary *authCodeDictionary;
    
    //changes made as per new UI - Akshay
    int intPermissionsArray;
    NSArray *dicData;
    NSMutableArray *combinedPermissionArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *doctorFamilyTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *doctorFamilySegmentedControl;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UIButton *rejectButton;

@property (strong, nonatomic) IBOutlet UIView *viewForBtn;
@property (strong, nonatomic) IBOutlet UILabel *optionalResourcesLabel;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *shadowLabelTopConstraint;
@property(nonatomic) NSString *endpoint;
@property(strong,nonatomic) NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UIView *activityContainerView;
@property (nonatomic) BOOL isSecondCall;
@property (nonatomic) BOOL isAccessCall;
@property (nonatomic,readwrite) BOOL isFhirResourceConsumption;

@property (strong, nonatomic) IBOutlet UIImageView *imgDoc;
@property (strong, nonatomic) IBOutlet UILabel *lblDocName;
@property (strong, nonatomic) IBOutlet UILabel *lblFromDate;
@property (strong, nonatomic) IBOutlet UILabel *lblToDate;
@property (strong, nonatomic) IBOutlet UILabel *lblFromText;
@property (strong, nonatomic) IBOutlet UILabel *lblToText;
@property (strong, nonatomic) IBOutlet UILabel *lblDocSpeciality;
@property (strong, nonatomic) IBOutlet UIView *viewAppIcon;
@property (weak, nonatomic) IBOutlet UIView *viewDoctorImage;
@property (weak, nonatomic) IBOutlet UIView *viewFromToDate;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leadingToViewAppIcon;


@end

@implementation PermissionSummaryViewController
@synthesize imgDoc;
@synthesize lblDocName;
@synthesize lblFromDate;
@synthesize lblToDate;
@synthesize lblDocSpeciality;
@synthesize viewAppIcon;
@synthesize viewDoctorImage;
@synthesize viewFromToDate;
@synthesize finalFamilyPermissionDataArray;
@synthesize isFhirResourceConsumption;
@synthesize lblFromText;
@synthesize lblToText;

- (IBAction)btnDetailsClicked:(id)sender {
    //PermissionResourcesDetailsViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PermissionResourcesDetailsViewController *newView = [storyboard instantiateViewControllerWithIdentifier:@"PermissionResourcesDetailsViewController"];
    newView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:newView animated:YES completion:nil];
}

- (IBAction)btnRejectClicked:(id)sender
{
    DebugLog(@"");
    PermissionData *permData;
    intPermissionsArray++;
    if(intPermissionsArray < combinedPermissionArray.count)
    {
        permData = combinedPermissionArray[intPermissionsArray];
        NSString *strData = [finalFamilyPermissionDataArray objectAtIndex:permData.index];
        NSArray *arrData =[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
        if ([[arrData objectAtIndex:4] isEqualToString:@"NA"])
        {
            if([[arrData objectAtIndex:2] isEqualToString:@"Female"])
            {
                imgDoc.image=[UIImage imageNamed:@"femaledefault.png"];
                
            }
            else
            {
                imgDoc.image=[UIImage imageNamed:@"maledefault.png"];
            }
            
        }
        else
        {
            imgDoc.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrData objectAtIndex:4]]];
        }
        
        //imgDoc.image = [UIImage imageNamed:imgArray[permData.index]];
        //lblDocName.text= titleArray[permData.index];
        lblDocName.text= [NSString stringWithFormat:@"%@ %@",arrData[0],arrData[1]];
        lblFromDate.text= permData.startDate;
        lblToDate.text= permData.endDate;
    }
    if (intPermissionsArray == combinedPermissionArray.count)
    {
        _isSecondCall = NO;
        //[self loadDashboard];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self CreatePrivateKey];
           [self performSelector:@selector(authCall) withObject:nil];
        });

    }

}
- (IBAction)editDoctorAndFamilyTapped:(id)sender
{
    DebugLog(@"");
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editPermissionResourcesTapped:(id)sender {
    DebugLog(@"");
    for (UIViewController *viewController in [self.navigationController viewControllers]) {
        if([viewController isKindOfClass:[PermissionController class]])
        {
            [self.navigationController popToViewController:viewController animated:YES];
            break;
        }
    }
}
-(void)assignDataOnUI
{
    DebugLog(@"");
    PermissionData *permData;
    if(intPermissionsArray < combinedPermissionArray.count)
    {
        permData = combinedPermissionArray[intPermissionsArray];
        if([permData.userType isEqualToString:PROVIDER])
        {
            imgDoc.image = [UIImage imageNamed:imgArray[permData.index]];
            lblDocName.text= titleArray[permData.index];
                     lblFromDate.text= permData.startDate;
            lblToDate.text= permData.endDate;
        }
        else
        {
            NSString *strData = [finalFamilyPermissionDataArray objectAtIndex:permData.index];
            NSArray *arrData =[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
            if ([[arrData objectAtIndex:4] isEqualToString:@"NA"])
            {
                if([[arrData objectAtIndex:2] isEqualToString:@"Female"])
                {
                    imgDoc.image=[UIImage imageNamed:@"femaledefault.png"];
                    
                }
                else
                {
                    imgDoc.image=[UIImage imageNamed:@"maledefault.png"];
                }

            }
            else
            {
                    imgDoc.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrData objectAtIndex:4]]];
            }
            
            //imgDoc.image = [UIImage imageNamed:imgFamilyArray[permData.index]];
            lblDocName.text= [NSString stringWithFormat:@"%@ %@",arrData[0],arrData[1]];
            //lblDocName.text = [NSString stringWithFormat:@"%@ %@",finalFamilyPermissionDataArray[0],finalFamilyPermissionDataArray[1]];
            lblFromDate.text= permData.startDate;
            lblToDate.text= permData.endDate;
        }
        //intPermissionsArray++;
    }
    else
    {
            /*UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                           message:@"Doctor Data finished"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  }];

            [alert addAction:firstAction];
            [self presentViewController:alert animated:YES completion:nil];*/
        [self loadDashboard];
        
    }
    
}

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    _isAccessCall = YES;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

    dicData = @[@{@"title": @"Condition", @"subtitle": @"This resource represents your condition of an illness i.e. if the illness is in active or deactive state."}, @{@"title": @"Device", @"subtitle": @"This resource will have information about tests done from various medical devices/instruments."}, @{@"title": @"Observations", @"subtitle": @"This resource will have detail information and observation about various test results"}, @{@"title": @"Optional Resource", @"subtitle": @"Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor."}];

    
    _acceptButton.layer.cornerRadius=5.0;
    _rejectButton.layer.cornerRadius=5.0;
    UIFont *font = [UIFont fontWithName:@"Avenir Next" size:19.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [_doctorFamilySegmentedControl setTitleTextAttributes:attributes
                                     forState:UIControlStateNormal];
    [_doctorFamilySegmentedControl setTitle:[NSString stringWithFormat:@"Providers - (0%lu)",(unsigned long)[_permissionsArray count]] forSegmentAtIndex:0];
    [_doctorFamilySegmentedControl setTitle:[NSString stringWithFormat:@"Caregivers - (0%lu)",(unsigned long)[_permissionsFamilyArray count]] forSegmentAtIndex:1];
    
    NSLog(@"%@",finalFamilyPermissionDataArray);
    combinedPermissionArray =[[NSMutableArray alloc] initWithArray:_permissionsArray];
    [combinedPermissionArray addObjectsFromArray:_permissionsFamilyArray];
    
    if (imgArray == nil)
    {
        imgArray=[[NSArray alloc]initWithObjects:@"Doc1",@"Doc2",@"Doc3",@"Doc5",@"Doc6",@"Doc7",@"Doc8", nil];
    }
    if (imgFamilyArray == nil)
    {
        imgFamilyArray=[[NSArray alloc]initWithObjects:@"Mother",@"Father",@"Brother",@"Sister", nil];
    }
    if (titleArray == nil)
    {
        titleArray=[[NSArray alloc]initWithObjects:@"Dr. Cardiac H. Cathy",@"Dr. Radio S. Rachel",@"Dr. Endo D. Eric",@"Dr. Primary F. Paul",@"Dr. Abdiel A. Jacobs",@"Dr. Ortho B. Otto",@"Dr. George D. Beller", nil];
    }
    if (titleFamilyArray == nil)
    {
       titleFamilyArray=[[NSArray alloc]initWithObjects:@"Worried Wendy",@"Hefty H. Harvey",@"Tricky X. Troy",@"Sports T. Susan", nil];
    }
    if (csiArray == nil)
    {
        csiArray=[[NSArray alloc]initWithObjects:@"2cf13cf4-3780-4f2a-9310-23abd3d1596a",
                  @"590730dc-7741-40f0-a6e7-e5f556547fee",
                  @"e78c858f-338a-4ccc-8168-31cd238a6792",
                  @"2cb79c54-7739-426a-bb3b-521badf46f4d",
                  @"28b02abe-80bc-4372-8ae3-728bf047c0e1",
                  @"4ac4023a-841c-49d7-a6a6-159d153ebf94",
                  @"73c41876-4f53-4968-9d14-eb56af4cc515", nil];
    }
    if (csiFamilyArray == nil)
    {
        csiFamilyArray = (NSMutableArray *)[[NSUserDefaults standardUserDefaults]valueForKey:@"csiFamilyArray"];
    }
    self.navigationController.navigationBar.topItem.title = @"";
    //set nav bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:15/255.00f green:105/255.00f blue:145/255.00f alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    _viewForBtn.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    _viewForBtn.layer.shadowOffset=CGSizeMake(0.0f, 0.0f);
    _viewForBtn.layer.shadowRadius=4.5f;
    _viewForBtn.layer.shadowOpacity=0.9f;
    _viewForBtn.layer.masksToBounds=NO;
    UIEdgeInsets shadowInset=UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath=[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_viewForBtn.bounds, shadowInset)];
    _viewForBtn.layer.shadowPath=shadowPath.CGPath;
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"checkBtn"])
    {
        _optionalResourcesLabel.hidden = NO;
        _label.hidden=NO;
    }
    else
    {
        _optionalResourcesLabel.hidden = YES;
         _label.hidden=YES;
        _shadowLabelTopConstraint.constant=20;
    }
    // Do any additional setup after loading the view.
    CGRect applicationFrame=[[UIScreen mainScreen] bounds];
    if(applicationFrame.size.height <= 480)
    {
        _leadingToViewAppIcon.constant = 3;
    }
    
    
    // code for Appicon View

    self.viewAppIcon.layer.cornerRadius = 10;
    self.viewAppIcon.clipsToBounds = YES;
    
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = 1.0 / -100;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        perspectiveTransform.m34 = 1.0 / -600;
    }
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        self.viewAppIcon.layer.transform =  CATransform3DRotate(perspectiveTransform, (20 * M_PI / 180), 0.0f, 1.5f, 0.0f);
    } else {
        self.viewAppIcon.layer.transform =  CATransform3DRotate(perspectiveTransform, (7 * M_PI / 180), 0.0f, 1.5f, 0.0f);
    }
    
    // Code for FromTo date view

    self.viewFromToDate.layer.transform = CATransform3DRotate(perspectiveTransform, (40 * M_PI / 180), 10.0f, 0.0f, 0.0f);
    self.viewFromToDate.transform = CGAffineTransformMakeRotation(M_PI/40);
    
    self.viewFromToDate.layer.cornerRadius = 5; // this value vary as per your desire
    self.viewFromToDate.clipsToBounds = YES;
    self.viewFromToDate.backgroundColor=[UIColor clearColor];
    
    
    // code for DoctoreImageView
    
    self.viewDoctorImage.layer.transform = CATransform3DRotate(perspectiveTransform, (4 * M_PI / 180), 0.0f, -0.1f, 0.0f);
    self.viewDoctorImage.layer.cornerRadius = 5; // this value vary as per your desire
    self.viewDoctorImage.clipsToBounds = YES;
    
    UIEdgeInsets contentInsets1 = UIEdgeInsetsMake(0, -self.viewDoctorImage.frame.size.width - 60, 25, self.viewDoctorImage.frame.size.width + 80);
    
    CGRect viewFrame1 = self.viewDoctorImage.frame;
    
    //viewFrame1.origin.y=  viewFrame1.origin.y;
    
    CGRect shadowPathExcludingTop1 = UIEdgeInsetsInsetRect(viewFrame1, contentInsets1);
    
    self.viewDoctorImage.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPathExcludingTop1].CGPath;
    self.viewDoctorImage.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.viewDoctorImage.layer.shadowOffset = CGSizeMake(0.0,0.0f);
    self.viewDoctorImage.layer.shadowOpacity = 0.3f;
    self.viewDoctorImage.layer.masksToBounds = NO;
    
    imgDoc.clipsToBounds=YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        lblFromDate.font=[UIFont systemFontOfSize:15.0];
        lblFromText.font=[UIFont systemFontOfSize:15.0];
        lblToDate.font=[UIFont systemFontOfSize:15.0];
        lblToText.font=[UIFont systemFontOfSize:15.0];
    }
    
    [self assignDataOnUI];
}

- (void)didReceiveMemoryWarning {
    DebugLog(@"");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  /*  if(_doctorFamilySegmentedControl.selectedSegmentIndex == 0)
    {
        return  [_permissionsArray count];
    }
    else
    {
        return  [_permissionsFamilyArray count];
    }*/
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"checkBtn"])
    {
        return 4;
    }
        return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 71;
    return 92.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* NSString *cellIdentifier=@"Cell";
    CustomCell *cell=(CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    PermissionData *permData;
    if(_doctorFamilySegmentedControl.selectedSegmentIndex == 0)
    {
        permData = _permissionsArray[indexPath.row];
        cell.image.image = [UIImage imageNamed:imgArray[permData.index]];
        cell.title.text = titleArray[permData.index];
        if([cell.title.text isEqualToString:@"Dr. Cardiac H. Cathy"])
        {
            cell.subtitle.text = @"Cardiologist, (MBBS)";
        }
        else if ([cell.title.text isEqualToString:@"Dr. Primary F. Paul"])
        {
            cell.subtitle.text = @"PCP, (MBBS)";
        }
        else if ([cell.title.text isEqualToString:@"Dr. George D. Beller"])
        {
            cell.subtitle.text = @"Dermatologist, (MBBS)";
        }
        else if ([cell.title.text isEqualToString:@"Dr. Radio S. Rachel"])
        {
            cell.subtitle.text = @"Anesthetic, (MBBS)";
        }
        else
        {
            cell.subtitle.text = @"Endocrinologist, (MBBS)";
        }
    }
    else
    {
        permData = _permissionsFamilyArray[indexPath.row];
        cell.subtitle.text = @"";
        cell.image.image = [UIImage imageNamed:imgFamilyArray[permData.index]];
        cell.title.text = titleFamilyArray[permData.index];
    }
    
    
//    cell.checkImage.image = permData.checked?[UIImage imageNamed:@"Check"]:[UIImage imageNamed:@"uncheck"];
    NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
    //Create mutable string from original one
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
    
    //Fing range of the string you want to change colour
    //If you need to change colour in more that one place just repeat it
    NSRange range = [myString rangeOfString:permData.startDate];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1] range:range];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0f] range:range];
    NSRange range1 = [myString rangeOfString:permData.endDate];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1] range:range1];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0f] range:range1];
    
    //Add it to the label - notice its not text property but it's attributeText
    cell.fromAndToLabel.attributedText = attString;
  */
    
    UIImage *imageForCell;
    NSString *cellIdentifier=@"Cell";
    CustomTableViewCell *cell=(CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(indexPath.row==3)
    {
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"checkBtn"])
        {
            imageForCell  =[UIImage imageNamed:@"default_check"];
            [cell.checkBtn setImage:imageForCell forState:UIControlStateNormal];
            cell.checkBtn.tintColor=[UIColor colorWithRed:15/255.00f green:105/255.00f blue:145/255.00f alpha:1];
        }
        else
        {
            imageForCell  =[UIImage imageNamed:@"radio_uncheck"];
            [cell.checkBtn setImage:imageForCell forState:UIControlStateNormal];
            cell.checkBtn.tintColor=[UIColor colorWithRed:15/255.00f green:105/255.00f blue:145/255.00f alpha:1];
        }
        cell.checkBtn.userInteractionEnabled=YES;
    }
    else
    {
        imageForCell =[UIImage imageNamed:@"default_check"];
        [cell.checkBtn setImage:imageForCell forState:UIControlStateNormal];
        cell.checkBtn.userInteractionEnabled=NO;
    }
    cell.cell_title.text = [[dicData objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.cell_subtitle.text = [[dicData objectAtIndex:indexPath.row] objectForKey:@"subtitle"];
    
    [cell.checkBtn addTarget:self action:@selector(checkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if(indexPath.row!=2)
    {
        cell.separatorInset=UIEdgeInsetsMake(0, 10000, 0, 0);
        
    }
    return cell;
    
}

- (IBAction)checkBtnClicked:(UIButton *)btn {
    DebugLog(@"");
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"checkBtn"])
    {
        [btn setImage:[UIImage imageNamed:@"default_check"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"checkBtn"];}
    else{
        [btn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"checkBtn"];
    }
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    DebugLog(@"");
    [self.doctorFamilyTableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)acceptButtonTapped:(id)sender {
    DebugLog(@"");
    //[self assignDataOnUI];
   
   /* NSMutableString * permissionString = [[NSMutableString alloc]init];
    NSMutableString * permissionFamilyString = [[NSMutableString alloc]init];
    for (PermissionData *permData in _permissionsArray) {
        [permissionString appendString:[NSString stringWithFormat: @"|%@,%@,%@,%@",titleArray[permData.index],permData.startDate,permData.endDate,csiArray[permData.index]]];
    }
    for (PermissionData *permData in _permissionsFamilyArray) {
        [permissionFamilyString appendString:[NSString stringWithFormat: @"|%@,%@,%@,%@",titleFamilyArray[permData.index],permData.startDate,permData.endDate,csiFamilyArray[permData.index]]];
    }
    NSString * finalString = [NSString stringWithFormat:@"%@&&%@",permissionString,permissionFamilyString];
    [UICKeyChainStore setString:finalString forKey:@"dSharedPermissions" service:@"MyService"];
    [self writePermissions:@""];*/
    
    // code for individual call of write permission
    
    
    NSMutableString * permissionString = [[NSMutableString alloc]init];
    NSMutableString * permissionFamilyString = [[NSMutableString alloc]init];
    
    PermissionData *permData =[combinedPermissionArray objectAtIndex:intPermissionsArray];
    
    if([permData.userType isEqualToString:PROVIDER])
    {
        [permissionString appendString:[NSString stringWithFormat: @"|%@,%@,%@,%@",titleArray[permData.index],permData.startDate,permData.endDate,csiArray[permData.index]]];
    }
    else
    {
        NSString *strData = [finalFamilyPermissionDataArray objectAtIndex:permData.index];
        NSArray *arrData =[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
        [permissionString appendString:[NSString stringWithFormat: @"|%@,%@,%@,%@",[NSString stringWithFormat:@"%@ %@",arrData[0],arrData[1]],permData.startDate,permData.endDate,arrData[3]]];
    }
    [self writePermissions:permissionString];

}

//- (void)appWillEnterForeground:(NSNotification *)notification {
//    NSLog(@"will enter foreground notification");
//
//    if([UICKeyChainStore stringForKey:@"dpermissionshared" service:@"MyService"] == nil)
//    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message"
//                                                                       message:@"You need to go to CSA for granting permissions."
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
//                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                              }];
//
//        [alert addAction:firstAction];
//        [self presentViewController:alert animated:YES completion:nil];
//
//    }
//    else
//    {
//
//
//
//    }
//}

-(void)generateKeys
{
    DebugLog(@"");
    // Private Key Attributes Dictionary
    NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];
    // Public Key Attributes Dictionary
    NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc] init];
    // Key Pair Attributes Dictionary
    NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];
    
    // Application Tags for Public & private
    NSData *publicTag = [@"EC" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *privateTag = [@"EC" dataUsingEncoding:NSUTF8StringEncoding];
    
    SecKeyRef publicKey = NULL;
    privateKey = NULL;
    // Type of Algorithm for key generation
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeEC
                    forKey:(__bridge id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithInt:256]
                    forKey:(__bridge id)kSecAttrKeySizeInBits];
    
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [privateKeyAttr setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
    [publicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
    
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    
    // Keys Generation
    OSStatus err = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey);
    NSLog(@"%d", (int)err);
    NSLog(@"public key is %@:",publicKey);
    
    // Algorithm for keys Generation
    algorithm = kSecKeyAlgorithmECDSASignatureMessageX962SHA256;
    // SecKeyRef to NSData conversion provided by Apple code - Storing Keys as data (Data - 65 Bytes,converted string will be 88)
    CFErrorRef error = NULL;
    NSData* keyDataAPI = (NSData*)CFBridgingRelease(  // ARC takes ownership
                                                    SecKeyCopyExternalRepresentation(publicKey, &error)
                                                    );
    if (!keyDataAPI) {
        NSError *err = CFBridgingRelease(error);  // ARC takes ownership
        // Handle the error. . .
    }
    CryptoExportImportManager * exportImportManager = [[CryptoExportImportManager alloc]init];
    NSData * exportableDERKey = [exportImportManager exportPublicKeyToDER:keyDataAPI keyType:(NSString*)kSecAttrKeyTypeEC keySize:256];
    derKeyString = [exportableDERKey base64EncodedStringWithOptions:0];
    NSString * exportablePEMKey = [exportImportManager exportPublicKeyToPEM:exportableDERKey keyType:(NSString*)kSecAttrKeyTypeEC  keySize:256];
    
}


-(void)loadDashboard
{
    DebugLog(@"");
    [self performSegueWithIdentifier:@"DashboardSegue" sender:self];
}

-(void)handleData :(NSData*)data errr:(NSError*)error
{
    DebugLog(@"");
    if(error)
    {
        [self hideBusyActivityView];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:error.localizedDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                              }];
        
        [alert addAction:firstAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        //        [NSException raise:@"Exception downloading data " format:@"%@",error.localizedDescription];
#if ISDEBUG
        
#if ISENDSCREEN
        NSLog(@"in end screen debug mode");
        NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
        NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
        [array2 addObject:[NSString stringWithFormat:@"error: %@",error.localizedDescription]];
        [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
        dispatch_async(dispatch_get_main_queue(), ^{
        //    [_debugView setHidden:true];
            //    [_debugContainerView setHidden:true];
        });
        
#else
        dispatch_async(dispatch_get_main_queue(), ^{
            [_debugView setHidden:true];
            [_responseView setHidden:false];
            //[_debugContainerView setHidden:false];
            [_responseLabel setText:[NSString stringWithFormat:@"error: %@",error.localizedDescription]];
        });
#endif
#else
        NSLog(@"not in debug mode");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_debugView setHidden:true];
            //    [_debugContainerView setHidden:true];
        });
#endif
        return;
    }
    NSError *jsonError;
    _dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    NSString * accessTokenString;
    if(_isAccessCall)
    {
        accessTokenString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    //    if(!_isThirdCall)
    //    {
    //        _guidDictionary = _dic;
    //    }
#if ISDEBUG
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray1"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@",_dic]];
//    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray1"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if(_isSecondCall)
    {
        if(_isAccessCall)
        {
            if(isFhirResourceConsumption)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"%@",_dic);
                    [self hideBusyActivityView];
                    [self loadDashboard];
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //        [_debugView setHidden:true];
                    [activityIndicator stopAnimating];
                    //[self performSelector:@selector(loadDashboard) withObject:nil];
                    [self hideBusyActivityView];
                    intPermissionsArray++;
                    if (intPermissionsArray == combinedPermissionArray.count)
                    {
                        //[self loadDashboard];
                        [self fetchFHIRResourceConsumption:accessTokenString];
                    }
                    else
                        [self performSelector:@selector(assignDataOnUI) withObject:nil afterDelay:0.01];
                    //[_debugContainerView setHidden:true];
                });
            }
        }
        else
        {
            authCodeDictionary = _dic;
            dispatch_async(dispatch_get_main_queue(), ^{
                //        [_debugView setHidden:true];
                //[activityIndicator stopAnimating];
                //[self hideBusyActivityView];
                
                [self performSelector:@selector(accessCall) withObject:nil afterDelay:0.01];
                //[_debugContainerView setHidden:true];
            });
        }
    }
    
    if(!_isSecondCall)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(authCall) withObject:nil];
        });
    }
    
#else
    dispatch_async(dispatch_get_main_queue(), ^{
        [_debugView setHidden:true];
        [_responseView setHidden:false];
        // [_debugContainerView setHidden:false];
        [_responseLabel setText:[NSString stringWithFormat:@"response dictionary: %@",_dic]];
    });
    
#endif
#else
    NSLog(@"not in debug mode");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_debugView setHidden:true];
        [activityIndicator stopAnimating];
        [self performSelector:@selector(loadDashboard) withObject:nil];
        //[_debugContainerView setHidden:true];
    });
    
    
#endif
    if(jsonError)
    {
        //        [NSException raise:@"Exception in parsing JSON data" format:@"%@",jsonError.localizedDescription];
    }
    
    
    
    //    _resultsArray=[[NSArray alloc]initWithArray:[dic objectForKey:@"companies"]];
    
    
}
-(void)CreatePrivateKey
{
    DebugLog(@"");
    NSData * privateKeyData = [[NSUserDefaults standardUserDefaults]valueForKey:@"PrivateKey"];
    NSDictionary* options = @{(id)kSecAttrKeyType: (id)kSecAttrKeyTypeEC,
                              (id)kSecAttrKeyClass: (id)kSecAttrKeyClassPrivate,
                              (id)kSecAttrKeySizeInBits: @256,
                              };
    CFErrorRef error = NULL;
    privateKey = SecKeyCreateWithData((__bridge CFDataRef)privateKeyData,
                                      (__bridge CFDictionaryRef)options,
                                      &error);
    if (!privateKey) {
        NSError *err = CFBridgingRelease(error);  // ARC takes ownership
        // Handle the error. . .
    } else {
        
    }
    
}

-(NSData*)createSignature:(NSData*)data2sign withKey:(SecKeyRef)privateKey
{
    DebugLog(@"");
    // Algorithm for keys Generation
    algorithm = kSecKeyAlgorithmECDSASignatureMessageX962SHA256;

    BOOL canSign = SecKeyIsAlgorithmSupported(privateKey,
                                              kSecKeyOperationTypeSign,
                                              algorithm);
    
    
    NSLog(@"Can You sign: %@",canSign ? @"YES" : @"NO");
    
    NSData* signature = nil;
    if (canSign) {
        CFErrorRef error = NULL;
        signature = (NSData*)CFBridgingRelease(       // ARC takes ownership
                                               SecKeyCreateSignature(privateKey,
                                                                     algorithm,
                                                                     (__bridge CFDataRef)data2sign,
                                                                     &error));
        if (!signature) {
            NSError *err = CFBridgingRelease(error);  // ARC takes ownership
            NSLog(@"%@", err);
            // Handle the error. . .
        }
    }
    
    return signature;
}

-(void) writePermissions:(NSString*)dataString
{
    DebugLog(@"");
    
    if(intPermissionsArray == combinedPermissionArray.count-1)
    {
        _isSecondCall=NO;
    }
    else
    {
        _isSecondCall= YES;
    }
    
   // APIhandler *h=[[APIhandler alloc]init];
   // h.delegate = self;
    mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc] init];
    apiHandler.delegate = self;
    
    _endpoint=@"writePermission";
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    time_t currentTime = [[ServerSingleton sharedServerSingleton]time];
    
    NSString *currentDate  = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    NSString *deviceId = [[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"];
    NSString *guid = [[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"];
    NSString *nonce = [self genRandStringLength:36];
    
//    [self generateKeys];
   
    NSMutableString * startDate = [[NSMutableString alloc]init];
    NSMutableString * endDate = [[NSMutableString alloc]init];
    NSMutableArray * permissionCsiGuids = [[NSMutableArray alloc]init];
    //NSString * fullString = [UICKeyChainStore stringForKey:@"dSharedPermissions" service:@"MyService"]; //Commeneted as we need to send indiviudal calls - Akshay
    
        NSString * fullString = dataString;

        NSArray *arrayOfStrings = [fullString componentsSeparatedByString:@"&&"];
    
        NSString * doctorsString = arrayOfStrings[0];
        NSArray *arrayOfDoctorsString = [doctorsString componentsSeparatedByString:@"|"];
    
       // NSString * familyString = arrayOfStrings[1]; //Commeneted as we need to send indiviudal calls - Akshay
       // NSArray *arrayOfFamilyString = [familyString componentsSeparatedByString:@"|"]; //Commeneted as we need to send indiviudal calls - Akshay
    
       if([arrayOfDoctorsString count] > 1) {
            NSArray * elements = [(NSString *)arrayOfDoctorsString [1] componentsSeparatedByString:@","];
            [startDate appendString:elements[1]];
            [endDate appendString:elements[2]];
        }
        else
        {
            //Commeneted as we need to send indiviudal calls - Akshay
            //NSArray * elements = [(NSString *)arrayOfFamilyString [1] componentsSeparatedByString:@","];
            //[startDate appendString:elements[1]];
            //[endDate appendString:elements[2]];
        }
    
        for (int i=1; i< [arrayOfDoctorsString count]; i++) {
            NSArray * elements = [(NSString *)arrayOfDoctorsString [i] componentsSeparatedByString:@","];
            [permissionCsiGuids addObject:elements[3]];
        }
    NSString *strPermissionId= permissionCsiGuids[0];
    
    //Commeneted as we need to send indiviudal calls - Akshay
        /*for (int i=1; i< [arrayOfFamilyString count]; i++) {
            NSArray * elements = [(NSString *)arrayOfFamilyString [i] componentsSeparatedByString:@","];
            [permissionCsiGuids addObject:elements[3]];
        }*/
    
//    [permissionCsiGuids addObject:fullString];
    NSLog(@"current Date :%@ ",currentDate);
    NSLog(@"device id:%@",deviceId);
    NSLog(@"%@",guid);
    NSLog(@"%@", nonce);
    NSDateFormatter *dateformatter1 = [[NSDateFormatter alloc] init];
    [dateformatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateformatter1.dateFormat = @"dd/MM/yy";
    NSDate *startDateInDate = [dateformatter1 dateFromString:startDate];
    NSDate *endDateInDate = [dateformatter1 dateFromString:endDate];
    
    NSString *startDateInRequiredFormat = [dateformatter stringFromDate:startDateInDate];
//    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//    [dateComponents setMonth:1];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    NSString *endDateInRequiredFormat = [dateformatter stringFromDate:endDateInDate];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:@"ETH"];
    [array addObject:@"SOC"];
    NSDictionary * heartScope = [[NSDictionary alloc]initWithObjectsAndKeys:@"write",@"accessType",@"V",@"confidentialityScope",@"patient",@"permissionType",@"Patient",@"resourceScope",array,@"sensitivityScope", nil];
    
   // NSDictionary * permission = [[NSDictionary alloc]initWithObjectsAndKeys:endDateInRequiredFormat,@"endTime",heartScope,@"heartScope",permissionCsiGuids,@"permissionedCsiGuids",startDateInRequiredFormat,@"startTime",currentDate,@"timeStamp", nil];
    
    NSDictionary * permission = [[NSDictionary alloc]initWithObjectsAndKeys:endDateInRequiredFormat,@"endTime",heartScope,@"heartScope",strPermissionId,@"permissionedCsiGuid",startDateInRequiredFormat,@"startTime",currentDate,@"timeStamp", nil];
    
    NSString *payload=[NSString stringWithFormat:@"%@%@%@%@%@"
                      // %@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@"
                       ,@"|",endDateInRequiredFormat,@"|",startDateInRequiredFormat,@"|"];
                       //,fullString,@"|",@"patient",@"|",@"V",@"|",[array objectAtIndex:0],@"|",[array objectAtIndex:1],@"|",@"Patient",@"|",guid,@"|",currentDate,@"|",nonce,@"|"];
    NSLog(@"%@", payload);
    NSMutableString * payloadMutableString = [NSMutableString stringWithFormat:@"%@", payload];
    for (NSString * string in permissionCsiGuids) {
        [payloadMutableString appendString:[NSString stringWithFormat:@"%@|",string]];
    }
    [payloadMutableString appendString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"patient",@"|",@"V",@"|",[array objectAtIndex:0],@"|",[array objectAtIndex:1],@"|",@"Patient",@"|",guid,@"|",currentDate,@"|",nonce,@"|"]];
    NSData * dataForSignature = [payloadMutableString dataUsingEncoding:NSUTF8StringEncoding];
    
    [self CreatePrivateKey];
    
//    NSData * privateKeyData = [[NSUserDefaults standardUserDefaults]valueForKey:@"PrivateKey"];
//    NSDictionary* options = @{(id)kSecAttrKeyType: (id)kSecAttrKeyTypeEC,
//                              (id)kSecAttrKeyClass: (id)kSecAttrKeyClassPrivate,
//                              (id)kSecAttrKeySizeInBits: @256,
//                              };
//    CFErrorRef error = NULL;
//    privateKey = SecKeyCreateWithData((__bridge CFDataRef)privateKeyData,
//                                      (__bridge CFDictionaryRef)options,
//                                      &error);
//    if (!privateKey) {
//        NSError *err = CFBridgingRelease(error);  // ARC takes ownership
//        // Handle the error. . .
//    } else {
//
//    }
    // Creation of Signature
    NSData *signature=[self createSignature:dataForSignature withKey:privateKey];
    NSString *signatureString = [signature base64EncodedStringWithOptions:0];
    request_dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"ecdsa",@"cipher",currentDate,@"dateTime",guid,@"csiGuid",nonce,@"nonce",permission,@"permission",signatureString,@"signature" ,nil];
    //picker
    
    //#if ISDEBUG
    //
    //#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray1"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@%@%@",Permission_Base_URL,_endpoint,request_dic]];
//    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [debugView setHidden:true];
    //[h createSessionforPermissionEndPoint:_endpoint withModelDictionary:request_dic];
   
    [apiHandler createSessionforPermissionEndPoint:_endpoint withModelDictionary:request_dic];

    _activityContainerView.hidden = false;
    
    [activityIndicator startAnimating];
    [self showBusyActivityView];

    
    //#else
    //    [debugView setHidden:false];
    //    debugView.contentSize = CGSizeMake(398, 512);
    //    [activityContainerView setHidden:false];
    //    // [_debugContainerView setHidden:false];
    //    [_requestLabel setText:[NSString stringWithFormat:@"%@%@ Model Dictionary %@",CSI_Base_URL,endpoint,request_dic]];
    //
    //    activityViewCenterConstraint.constant=-200.0;
    //#endif
    //
    //#else
    //    NSLog(@"not in debug mode");
    //    [debugView setHidden:true];
    //    [h createSessionforCSIEndPoint:endpoint withModelDictionary:request_dic];
    //    activityContainerView.hidden = false;
    //
    //    [_activityIndicator startAnimating];
    //    //[_debugContainerView setHidden:true];
    //#endif
    
}

- (NSString *)genRandStringLength:(int)len {
    DebugLog(@"");
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        if(i==8||i==13||i==18||i==23)
        {
            [randomString appendString:@"-"];
            continue;
        }
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

-(void)authCall
{
    DebugLog(@"");
    _isSecondCall = YES;
    _isAccessCall = NO;
   // h=[[APIhandler alloc]init];
   // h.delegate = self;
    
    apiHandler = [[mHealthApiHandler alloc]init];
    apiHandler.delegate = self;
    
    _endpoint=@"";
    
    double epochSeconds = [[NSDate date] timeIntervalSince1970];
    double expireTimeInSecondsSinceEpoch = epochSeconds + AUTHORIZATION_TOKEN_LIFESPAN_IN_SECONDS;
    //
    NSString * bodyString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%d%@%@%@%d%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"{\"iss\"",@":\"", [[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"],@"\",",@"\"sub\"",@":\"", [[NSUserDefaults standardUserDefaults]valueForKey:@"wcsi"],@"\",",@"\"aud\"",@":\"",Auth_Base_URL,@"\",",@"\"iat\"",@":\"",(int)epochSeconds,@"\",",@"\"exp\"",@":\"",(int)expireTimeInSecondsSinceEpoch,@"\",",@"\"jti\"",@":\"",[[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"],@"\",",@"\"scope\"",@":\"",@"patient/Patient.read sens/ETH sens/SOC conf/V",@"\",",@"\"prn\"",@":\"",@"http://smoac.fhirblocks.io:8080",@"\",",@"\"sta\"",@":\"",[[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"],@"\"}"];
    ////    NSString *bodyString = @"{\"iss\":\"b8565047-08d8-4293-b81e-ec2e9d37db8e\",\"sub\":\"b8565047-08d8-4293-b81e-ec2e9d37db8e\",\"aud\":\"http://smoac.fhirblocks.io:8080/vaca/auth\",\"iat\":\"1513148732\",\"exp\":\"1513149032\",\"jti\":\"65073A24-A6B4-4FF6-93CA-5C8DCC857862\",\"scope\":\"patient/Patient.read sens/ETH sens/SOC conf/V\",\"sta\":\"65073A24-A6B4-4FF6-93CA-5C8DCC857862\"}";
    NSDictionary *arraydata1=[[NSDictionary alloc]initWithObjectsAndKeys:(NSString *)[_dic valueForKey:@"guid"],@"iss",(NSString *)[_dic valueForKey:@"guid"],@"sub" ,Auth_Base_URL,@"aud",[NSString stringWithFormat:@"%d",(int)epochSeconds],@"iat",[NSString stringWithFormat:@"%d",(int)expireTimeInSecondsSinceEpoch],@"exp",[[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"],@"jti",@"patient/Patient.read sens/ETH sens/SOC conf/V",@"scope",[[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"],@"sta",nil];
    NSString *bodyDictString = [NSString stringWithFormat:@"%@",arraydata1];
    NSString * headerString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"{\"alg\"",@":\"",@"ES256",@"\",",@"\"typ\"",@":\"",@"jwt",@"\"}"];
    NSDictionary *arraydata2=[[NSDictionary alloc]initWithObjectsAndKeys:@"ES256",@"alg",@"jwt",@"typ",nil];
    NSString *headerDictString = [NSString stringWithFormat:@"%@",arraydata2];
//    [self generateKeys];
    //
    NSData * dataForSignature = [bodyString dataUsingEncoding:NSDataBase64Encoding64CharacterLineLength];
    NSString * bodyEncodedString = [dataForSignature base64EncodedStringWithOptions:0];
    // Creation of Signature
    NSData *signature=[self createSignature:dataForSignature withKey:privateKey];
    NSString *signatureString = [signature base64EncodedStringWithOptions:0];
    ////    NSString *signatureString = @"MEUCIQDdKOEMmkGbb2wYslMM4IR29oQPcCaPJYJ5LvnFI6LC4AIgMMAXDO92Ai4wYVl8YEL7HveknY+rYRrMhRbTuQQkxkQ=";
    //
    NSData * headerData = [headerString dataUsingEncoding:NSDataBase64Encoding64CharacterLineLength];
    NSString * headerEncodedString = [headerData base64EncodedStringWithOptions:0];
    
    NSString * finalAssembly = [NSString stringWithFormat:@"%@.%@.%@",headerEncodedString,bodyEncodedString,signatureString];
    modelDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:@"authorization_code",@"grant_type",@"urn:ietf:params:oauth:client-assertion-type:jwt-bearer",@"assertion_type",finalAssembly,@"assertion", nil];
    NSData * privateKeyData = [[NSUserDefaults standardUserDefaults]valueForKey:@"PrivateKey"];
    CryptoExportImportManager * exportImportManager = [[CryptoExportImportManager alloc]init];
    NSData * exportableDERKey = [exportImportManager exportPublicKeyToDER:privateKeyData keyType:(NSString*)kSecAttrKeyTypeEC keySize:256];
    derKeyString = [exportableDERKey base64EncodedStringWithOptions:0];
    NSLog(@"Private Key %@",derKeyString);
    NSString * exportablePEMKey = [exportImportManager exportPublicKeyToPEM:exportableDERKey keyType:(NSString*)kSecAttrKeyTypeEC  keySize:256];
    urlEncodedString = [NSString stringWithFormat:@"%@%@",@"grant_type=authorization_code&assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer&assertion=",finalAssembly];
#if ISDEBUG
    
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray1"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@%@%@%@\n\nBody Encoded String: %@\n\nHeader Encoded String: \n%@\n\nSignature String: \n%@\n\nURL Encoded String:\n%@",Auth_Base_URL,_endpoint,headerString,bodyString,bodyEncodedString,headerEncodedString,signatureString,urlEncodedString]];
    [array2 addObject:[NSString stringWithFormat:@"%@",signatureString]
     ];
//    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray1"];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //            [_debugView setHidden:true];
    //[h createSessionforAuthEndPoint:_endpoint withURLEncodedString:urlEncodedString];
    [apiHandler createSessionforAuthEndPoint:_endpoint withURLEncodedString:urlEncodedString];

    // [h createSessionforAuthEndPoint:_endpoint withModelDictionary:modelDictionary];
    
    _activityContainerView.hidden = false;
    
    [activityIndicator startAnimating];
    [self showBusyActivityView];
#else
//    [_debugView setHidden:false];
//    _debugView.contentSize = CGSizeMake(398, 512);
//    [_activityContainerView setHidden:false];
//    // [_debugContainerView setHidden:false];
//    [_requestLabel setText:[NSString stringWithFormat:@"%@%@%@%@%@",Auth_Base_URL,_endpoint,headerDictString,bodyDictString,urlEncodedString]];
//
//    _activityViewCenterConstraint.constant=-200.0;
//    [activityIndicator startAnimating];
#endif
    
#else
//    NSLog(@"not in debug mode");
//    [_debugView setHidden:true];
//    [h createSessionforAuthEndPoint:_endpoint withURLEncodedString:urlEncodedString];
//    _activityContainerView.hidden = false;
//
//    [activityIndicator startAnimating];
    //[_debugContainerView setHidden:true];
#endif
    
}

-(void)accessCall
{
    DebugLog(@"");
    [self showBusyActivityView];
    _isAccessCall = YES;
    //h=[[APIhandler alloc]init];
   // h.delegate = self;
    
    apiHandler = [[mHealthApiHandler alloc]init];
    apiHandler.delegate = self;
    
    _endpoint=@"";
    
    NSString * headerString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"{\"kid\"",@":\"",[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"],@"\",",@"\"alg\"",@":\"",@"ES256",@"\"}"];
    NSString * bodyString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"{\"code\"",@":\"",[authCodeDictionary objectForKey:@"code"],@"\",",@"\"iss\"",@":\"",[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"],@"\"}"];
    NSLog(@"Body String %@",bodyString);
    
    NSData * dataForSignature = [bodyString dataUsingEncoding:NSDataBase64Encoding64CharacterLineLength];
    NSString * bodyEncodedString = [dataForSignature base64EncodedStringWithOptions:0];
    NSLog(@"Body Encoded String %@",bodyEncodedString);
    NSData * headerData = [headerString dataUsingEncoding:NSDataBase64Encoding64CharacterLineLength];
    NSString * headerEncodedString = [headerData base64EncodedStringWithOptions:0];
    NSLog(@"Header Encoded String %@ ",headerEncodedString);
    NSData *signature=[self createSignature:dataForSignature withKey:privateKey];
    NSString *signatureString = [signature base64EncodedStringWithOptions:0];
    NSLog(@"Signature String %@",signatureString);

     NSString * finalAssembly = [NSString stringWithFormat:@"%@.%@.%@",headerEncodedString,bodyEncodedString,signatureString];
    
    urlEncodedString = [NSString stringWithFormat:@"%@%@%@%@",@"grant_type=authorization_code&code=",[authCodeDictionary objectForKey:@"code"],@"&client_assertion_type=urn%3Aietf%3Aparams%3Aoauth%3Aclient-assertion-type%3Ajwt-bearer&client_assertion=",finalAssembly];
    NSLog(@"URL Encoded String %@",urlEncodedString);
#if ISDEBUG
    
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray1"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@%@%@%@\n\nBody Encoded String: %@\n\nHeader Encoded String: \n%@\n\nSignature String: \n%@\n\nURL Encoded String:\n%@",Access_Base_URL,_endpoint,headerString,bodyString,bodyEncodedString,headerEncodedString,signatureString,urlEncodedString]];
   
    //    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray1"];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //            [_debugView setHidden:true];
//    [h createSessionforAuthEndPoint:_endpoint withURLEncodedString:urlEncodedString];
    // [h createSessionforAuthEndPoint:_endpoint withModelDictionary:modelDictionary];
    
    _activityContainerView.hidden = false;
    
    [activityIndicator startAnimating];
    [self showBusyActivityView];
#else
    //    [_debugView setHidden:false];
    //    _debugView.contentSize = CGSizeMake(398, 512);
    //    [_activityContainerView setHidden:false];
    //    // [_debugContainerView setHidden:false];
    //    [_requestLabel setText:[NSString stringWithFormat:@"%@%@%@%@%@",Auth_Base_URL,_endpoint,headerDictString,bodyDictString,urlEncodedString]];
    //
    //    _activityViewCenterConstraint.constant=-200.0;
    //    [activityIndicator startAnimating];
#endif
    
#else
    //    NSLog(@"not in debug mode");
    //    [_debugView setHidden:true];
    //    [h createSessionforAuthEndPoint:_endpoint withURLEncodedString:urlEncodedString];
    //    _activityContainerView.hidden = false;
    //
    //    [activityIndicator startAnimating];
    //[_debugContainerView setHidden:true];
#endif
    //[h createSessionforAccessEndPoint:_endpoint withURLEncodedString:urlEncodedString];
    [apiHandler createSessionforAccessEndPoint:_endpoint withURLEncodedString:urlEncodedString];
}

-(void)fetchFHIRResourceConsumption:(NSString*)accessStr;
{
    DebugLog(@"");
    [self showBusyActivityView];
    //NSString *strFetchFHIRResourceURL=FHIR_CONSUMPTION_URL;
   // APIhandler *h=[[APIhandler alloc]init];
    //h.delegate = self;
    
    mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc]init];
    apiHandler.delegate = self;
    
    //_endpoint=@"getGloballyUniqueIdentifier";
    isFhirResourceConsumption = YES;
    
#if ISDEBUG
    
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    //[_debugView setHidden:true];
   // [_debugContainerView setHidden:true];
    NSMutableArray * array = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
    NSMutableArray * array1 = [NSMutableArray arrayWithArray:array];
    [array1 addObject:[NSString stringWithFormat:@"%@",FHIR_CONSUMPTION_URL]];
    [[NSUserDefaults standardUserDefaults]setObject:array1 forKey:@"LogArray"];
    
#else
    
    NSLog(@"not in end screen debug mode");
    //[_debugView setHidden:false];
    //[_debugContainerView setHidden:false];
    //[_requestLabel setText:[NSString stringWithFormat:@"%@%@",Base_URL,_endpoint]];
    
#endif
#else
    NSLog(@"not in debug mode");
   // [_debugView setHidden:true];
    //[_debugContainerView setHidden:true];
#endif
    
    //[h createFHIRResourceConsumptionRequest:strFetchFHIRResourceURL accessToken:accessStr];
    [apiHandler createFHIRResourceConsumptionRequest:FHIR_CONSUMPTION_URL accessToken:accessStr];

}

-(void) showBusyActivityView
{
    DebugLog(@"");
    [DejalBezelActivityView activityViewForView:self.view];
}

-(void) hideBusyActivityView
{
    DebugLog(@"");
    [DejalBezelActivityView removeViewAnimated:YES];
}
@end
