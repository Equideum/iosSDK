//
//  PermissionViewController.m
//  FBlocksCSA
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "PermissionViewController.h"
//#import "APIhandler.h"
#import "ServerSingleton.h"
#import "UICKeyChainStore.h"
#import "Constants.h"
#import "DateCollectionViewCell_Ipad.h"
#import "DateCollectionViewCell.h"
#import "WPSAlertController.h"
#import "CustomTableViewCell.h"
#import "PermissionResourcesDetailsViewController.h"

@interface PermissionViewController ()<UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>{
    NSString *endpoint;
    NSDictionary *request_dic;
    NSArray *dicData;
    
    SecKeyRef privateKey;
    SecKeyAlgorithm algorithm;
    UIView *activityContainerView;
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation PermissionViewController

- (void)viewDidLoad {
     DebugLog(@"");
    [super viewDidLoad];
    //@"",@"",@"",
    //@"",nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    CGRect viewFrame=self.viewBottom.frame;
    
    viewFrame.origin.y=  viewFrame.origin.y-15;
    
    CGRect shadowPathExcludingTop = UIEdgeInsetsInsetRect(viewFrame, contentInsets);
    
    self.viewBottom.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPathExcludingTop].CGPath;
    self.viewBottom.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.viewBottom.layer.shadowOffset = CGSizeMake(0.0,0.0f);
    self.viewBottom.layer.shadowOpacity = 0.3f;
    self.viewBottom.layer.masksToBounds=NO;
    
    
    dicData = @[@{@"title": @"Condition", @"subtitle": @"This resource represents your condition of an illness i.e. if the illness is in active or deactive state."}, @{@"title": @"Device", @"subtitle": @"This resource will have information about tests done from various medical devices/instruments."}, @{@"title": @"Observations", @"subtitle": @"This resource will have detail information and observation about various test results"}, @{@"title": @"Optional Resource", @"subtitle": @"This is optional resource."}];
    // Do any additional setup after loading the view.
    
    self.btnAccept.layer.cornerRadius = 5; // this value vary as per your desire
    self.btnAccept.clipsToBounds = YES;
    
    self.btnReject.layer.cornerRadius = 5; // this value vary as per your desire
    self.btnReject.clipsToBounds = YES;
    
    self.btnDetails.layer.cornerRadius = 5; // this value vary as per your desire
    self.btnDetails.clipsToBounds = YES;
    
    [[self.btnDetails layer] setBorderColor:[[UIColor colorWithRed:124/255.0 green:170/255.0 blue:174/255.0 alpha:1.0] CGColor]];
    [[self.btnDetails layer] setBorderWidth:1.f];
    
    // 3D Effect Code
    //    CATransform3D perspectiveTransform = CATransform3DIdentity;
    //    perspectiveTransform.m34 = 1.0 / -300;
    //    self.backgroundImageView.layer.sublayerTransform = perspectiveTransform;
    // 3D Effect Code
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = 1.0 / -100;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        perspectiveTransform.m34 = 1.0 / -600;
    }
    
    //self.imgAppIcon.layer.transform =  CATransform3DRotate(perspectiveTransform, (22.5 * M_PI / 180), 0.0f, 1.5f, 0.0f);
   // self.collectionOne.layer.transform =
   // CATransform3DRotate(perspectiveTransform, (60.0 * M_PI / 180), 65, -0.3f, 0.4f);
    
   // self.imgAppIcon.layer.anchorPoint = CGPointMake(0.0, 0.0);

    CATransform3D _3Dt = CATransform3DRotate(perspectiveTransform, (-15.0 * M_PI / 180), 0.0f, -0.2f, 0.0f);

    self.imgAppIcon.layer.transform = _3Dt;
    self.imgCal1.layer.transform =  CATransform3DRotate(perspectiveTransform, (65.0 * M_PI / 180), 1.5, -0.3f, 0.4f);
    self.imgCal.layer.transform =  CATransform3DRotate(perspectiveTransform, (65.0 * M_PI / 180), 1.5 , -0.4f, 0.4f);
    self.imgCal2.layer.transform =  CATransform3DRotate(perspectiveTransform, (65.0 * M_PI / 180), 1.5, -0.3f, 0.4f);
    
    //self.imgMessage.layer.transform = CATransform3DRotate(perspectiveTransform, (3.0 * M_PI / 180), 0.0f, 0.00f, 0.1f);
    
    
    [self.imgMessage setHidden:YES];
    [self.lblMessage setHidden:YES];
    
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
    
    // 58.0,38.0,78.0 ;y: -0.3f
}

-(void) viewDidAppear:(BOOL)animated {
     DebugLog(@"");
    [super viewDidAppear:animated];
    
   // [self writePermissions];
}

-(void)writePermissions
{
     DebugLog(@"");
//    APIhandler *
//    h=[[APIhandler alloc]init];
//    h.delegate = self;
    
    mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc]init];
    apiHandler.delegate = self;
    
    endpoint=@"writePermission";
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    time_t currentTime = [[ServerSingleton sharedServerSingleton]time];
    
    NSString *currentDate  = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    NSString *deviceId = [UICKeyChainStore stringForKey:@"UniqueIdentifier" service:@"MyService"];
    NSString *guid = [[NSUserDefaults standardUserDefaults]valueForKey:@"wcsi"];
    NSString *nonce = [self genRandStringLength:36];
    
    //    [self generateKeys];
    // <space> represents a single whitespace
    NSMutableString * startDate = [[NSMutableString alloc]init];
    NSMutableString * endDate = [[NSMutableString alloc]init];
    NSMutableArray * permissionCsiGuids = [[NSMutableArray alloc]init];
    NSString * fullString = [[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"];
    //    NSArray *arrayOfStrings = [fullString componentsSeparatedByString:@"&&"];
    //
    //    NSString * doctorsString = arrayOfStrings[0];
    //    NSArray *arrayOfDoctorsString = [doctorsString componentsSeparatedByString:@"|"];
    //
    //    NSString * familyString = arrayOfStrings[1];
    //    NSArray *arrayOfFamilyString = [familyString componentsSeparatedByString:@"|"];
    //
    //   if([arrayOfDoctorsString count] != 0) {
    //        NSArray * elements = [(NSString *)arrayOfDoctorsString [1] componentsSeparatedByString:@","];
    //        [startDate appendString:elements[1]];
    //        [endDate appendString:elements[2]];
    //    }
    //    else
    //    {
    //        NSArray * elements = [(NSString *)arrayOfFamilyString [1] componentsSeparatedByString:@","];
    //        [startDate appendString:elements[1]];
    //        [endDate appendString:elements[2]];
    //    }
    //
    //    for (int i=1; i< [arrayOfDoctorsString count]; i++) {
    //        NSArray * elements = [(NSString *)arrayOfDoctorsString [i] componentsSeparatedByString:@","];
    //        [permissionCsiGuids addObject:elements[3]];
    //    }
    //
    //
    //    for (int i=1; i< [arrayOfFamilyString count]; i++) {
    //        NSArray * elements = [(NSString *)arrayOfFamilyString [i] componentsSeparatedByString:@","];
    //        [permissionCsiGuids addObject:elements[3]];
    //    }
    
    [permissionCsiGuids addObject:fullString];
    NSLog(@"current Date :%@ ",currentDate);
    NSLog(@"device id:%@",deviceId);
    NSLog(@"%@",guid);
    NSLog(@"%@", nonce);
    NSDateFormatter *dateformatter1 = [[NSDateFormatter alloc] init];
    [dateformatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateformatter1.dateFormat = @"dd/MM/yy";
    NSDate *startDateInDate = [dateformatter1 dateFromString:startDate];
    NSDate *endDateInDate = [dateformatter1 dateFromString:endDate];
    
    NSString *startDateInRequiredFormat = [dateformatter stringFromDate:[NSDate date]];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    NSString *endDateInRequiredFormat = [dateformatter stringFromDate:newDate];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:@"ETH"];
    [array addObject:@"SOC"];
    NSDictionary * heartScope = [[NSDictionary alloc]initWithObjectsAndKeys:@"write",@"accessType",@"V",@"confidentialityScope",@"patient",@"permissionType",@"Patient",@"resourceScope",array,@"sensitivityScope", nil];
    
    NSDictionary * permission = [[NSDictionary alloc]initWithObjectsAndKeys:endDateInRequiredFormat,@"endTime",heartScope,@"heartScope",permissionCsiGuids,@"permissionedCsiGuids",startDateInRequiredFormat,@"startTime",currentDate,@"timeStamp", nil];
    NSString *payload=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"|",endDateInRequiredFormat,@"|",startDateInRequiredFormat,@"|",fullString,@"|",@"patient",@"|",@"V",@"|",[array objectAtIndex:0],@"|",[array objectAtIndex:1],@"|",@"Patient",@"|",guid,@"|",currentDate,@"|",nonce,@"|"];
    //    payload=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"|",endDateInRequiredFormat,@"|",startDateInRequiredFormat,@"|",fullString,@"|",@"patient",@"|",@"V",@"|",[array objectAtIndex:0],@"||",[array objectAtIndex:1],@"||",@"Patient",@"||",guid,@"|",currentDate,@"|",nonce];
    
    NSLog(@"Payload %@", payload);
    NSData * dataForSignature = [payload dataUsingEncoding:NSUTF8StringEncoding];
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
    } else {  }
    
    // Creation of Signature
    NSData *signature=[self createSignature:dataForSignature withKey:privateKey];
    NSString *signatureString = [signature base64EncodedStringWithOptions:0];
    NSLog(@"Signature %@",signatureString);
    request_dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"ecdsa",@"cipher",currentDate,@"dateTime",guid,@"csiGuid",nonce,@"nonce",permission,@"permission",signatureString,@"signature" ,nil];
    //picker
    
    //#if ISDEBUG
    //
    //#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@%@%@",Permission_Base_URL,endpoint,request_dic]];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    //    [debugView setHidden:true];
    //[h createSessionforPermissionEndPoint:endpoint withModelDictionary:request_dic];
  
    [apiHandler createSessionforPermissionEndPoint:endpoint withModelDictionary:request_dic];

    
    activityContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
   
    //Create and add the Activity Indicator to splashView
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
    //activityIndicator.hidesWhenStopped = NO;
    [activityContainerView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    //    activityContainerView.hidden = false;
    
    //    [_activityIndicator startAnimating];
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



-(void)handleData :(NSData*)data errr:(NSError*)error
{
     DebugLog(@"");
    if(error)
    {
        WPSAlertController *alert = [WPSAlertController alertControllerWithTitle:@"Alert"
                                                                         message:error.localizedDescription
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  //                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                              }];
        
        [alert addAction:firstAction];
        
        [alert show];
        // [NSException raise:@"Exception downloading data " format:@"%@",error.localizedDescription];
        //#if ISDEBUG
        //
        //#if ISENDSCREEN
        NSLog(@"in end screen debug mode");
        NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
        NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
        [array2 addObject:[NSString stringWithFormat:@"error: %@",error.localizedDescription]];
        [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [debugView setHidden:true];
        //            //    [_debugContainerView setHidden:true];
        //        });
        //#else
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [debugView setHidden:false];
        //            //[_debugContainerView setHidden:false];
        //            [_responseLabel setText:[NSString stringWithFormat:@"error: %@",error.localizedDescription]];
        //        });
        //#endif
        //#else
        //        NSLog(@"not in debug mode");
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [debugView setHidden:true];
        //            //    [_debugContainerView setHidden:true];
        //        });
        //#endif
        return;
    }
    NSError *jsonError;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    //if([(NSString *)[dic valueForKey:@"status"] isEqualToString:@"ok"])
    // {
    // NSString *guid = [_dic valueForKey:@"guid"];
    [[NSUserDefaults standardUserDefaults]setObject:@"true" forKey:@"dpermissionshared"];
    //    [UICKeyChainStore setString:@"true" forKey:@"dpermissionshared" service:@"MyService"];
    //  }
    //#if ISDEBUG
    //#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@",dic]];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [debugView setHidden:true];
    //        [_activityIndicator stopAnimating];
    //        [self performSegueWithIdentifier:@"SecurityQuestionSegue" sender:self];
    //        //[_debugContainerView setHidden:true];
    //    });
    //#else
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [debugView setHidden:true];
    //        [_responseView setHidden:false];
    //        // [_debugContainerView setHidden:false];
    //        [_responseLabel setText:[NSString stringWithFormat:@"response dictionary: %@",dic]];
    //    });
    //
    //#endif
    //#else
    //    NSLog(@"not in debug mode");
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [debugView setHidden:true];
    //        [_activityIndicator stopAnimating];
    //        [self performSegueWithIdentifier:@"SecurityQuestionSegue" sender:self];
    //        //[_debugContainerView setHidden:true];
    //    });
    //
    //
    //#endif
    if(jsonError)
    {
        //        [NSException raise:@"Exception in parsing JSON data" format:@"%@",jsonError.localizedDescription];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [activityIndicator stopAnimating];
        [activityContainerView removeFromSuperview];
        NSString *mHealthDApp = [NSString stringWithFormat:@"%@://?dpermissionshared=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"scheme"],[[NSUserDefaults standardUserDefaults]valueForKey:@"dpermissionshared"]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:mHealthDApp] options:@{} completionHandler:nil];
//        WPSAlertController *alert = [WPSAlertController alertControllerWithTitle:@"Message"
//                                                                         message:@"Permission granted,Navigate to DApp"
//                                                                  preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
//                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                                  //
//                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
//                                                                 
//                                                              }];
//
//        [alert addAction:firstAction];
//
//        [alert show];
    });
}

- (void)didReceiveMemoryWarning {
     DebugLog(@"");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma MARK - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92.0;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnDetailsClicked:(id)sender {
     DebugLog(@"");
    //PermissionResourcesDetailsViewController
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PermissionResourcesDetailsViewController *newView = [storyboard instantiateViewControllerWithIdentifier:@"PermissionResourcesDetailsViewController"];
    newView.modalPresentationStyle = UIModalPresentationOverCurrentContext; 
    [self.navigationController presentViewController:newView animated:YES completion:nil];
}

- (IBAction)btnRejectClicked:(UIButton *)sender {
     DebugLog(@"");
    NSString *mHealthDApp = [NSString stringWithFormat:@"%@://",[[NSUserDefaults standardUserDefaults]valueForKey:@"scheme"]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:mHealthDApp] options:@{} completionHandler:nil];
}

- (IBAction)btnAcceptClicked:(UIButton *)sender {
     DebugLog(@"");
    [self writePermissions];
}
@end
