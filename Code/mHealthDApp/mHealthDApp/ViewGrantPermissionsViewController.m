//
//  ViewGrantPermissionsViewController.m
//  mHealthDAP
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "ViewGrantPermissionsViewController.h"
#import "CustomCell.h"
#import "PermissionData.h"
#import "PermissionResourcesTableViewCell.h"
//#import "APIhandler.h"
#import "Constants.h"
#import "ServerSingleton.h"
#import "ViewGrantPermissionsViewController.h"
#import "PermissionController.h"
#import "DejalActivityView.h"

@interface ViewGrantPermissionsViewController ()
{
    NSArray *imgArray;
    NSArray *imgFamilyArray;
    NSArray *titleArray;
    NSArray *titleFamilyArray;
    NSArray *csiArray;
    NSMutableArray *csiFamilyArray;
    NSMutableArray *panelArray;
    NSMutableArray *indexArray;
    NSMutableArray *indexFamilyArray;
    UILabel *noDataLabel;
    BOOL optionalResource;
    int selectedIndex;
    int oldSelectedIndex;
    int filteredSelectedIndex;
    NSString * searchString;
    BOOL isPanelOpen;
    SecKeyRef privateKey;
    SecKeyAlgorithm algorithm;
    NSDictionary *request_dic;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *doctorFamilySegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *doctorFamilyTableView;
@property (strong, nonatomic) IBOutlet UIView *viewForBtn;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *grantPermissionBtn;
@property(nonatomic) NSString *endpoint;
@property(strong,nonatomic) NSDictionary *dic;
@property (nonatomic) BOOL isFetchPermissions;
@property (nonatomic) BOOL isDeletePermissions;

@end

@implementation ViewGrantPermissionsViewController

- (void)viewDidLoad {
     DebugLog(@"");
    [super viewDidLoad];
    isPanelOpen = NO;
    optionalResource=[[NSUserDefaults standardUserDefaults]boolForKey:@"checkBtn"];
    UIFont *font = [UIFont fontWithName:@"Avenir Next" size:19.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [_doctorFamilySegmentedControl setTitleTextAttributes:attributes
                                                 forState:UIControlStateNormal];
    
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
        csiArray=[[NSArray alloc]initWithObjects:@"1e54e260-e1d7-4267-a53c-f3cd11b87194",
                  @"8baa80d3-3900-46cb-89f7-3c383aff2d66",
                  @"be983ee6-ad1e-40bf-aeed-f2ddfa6f4bf7",
                  @"0f5e502a-8b34-435f-8e1a-300ce2a0ae49",
                  @"f8100b03-cd7f-4265-a39f-23d90cf07cd3",
                  @"dbd8e39f-0596-47ab-8a2a-0191db042672",
                  @"d2727ba8-062b-4092-b618-37d77abda6ab", nil];
    }
    if (csiFamilyArray == nil)
    {
        csiFamilyArray = (NSMutableArray*)[[NSUserDefaults standardUserDefaults]valueForKey:FINALFAMILYDATAARRAY];//(NSMutableArray *)[[NSUserDefaults standardUserDefaults]valueForKey:@"csiFamilyArray"];
    }
    
    panelArray = [[NSMutableArray alloc]init];
    
    self.navigationController.navigationBar.hidden=NO;
    self.navigationController.navigationBar.topItem.title = @"";
    //set nav bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:15/255.00f green:105/255.00f blue:145/255.00f alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];

    _label.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    _label.layer.shadowOffset=CGSizeMake(0.0f, 0.0f);
    _label.layer.shadowRadius=1.5f;
    _label.layer.shadowOpacity=0.9f;
    _label.layer.masksToBounds=NO;
    UIEdgeInsets shadowInset=UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath=[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_label.bounds, shadowInset)];
    _label.layer.shadowPath=shadowPath.CGPath;
    _viewForBtn.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    _viewForBtn.layer.shadowOffset=CGSizeMake(0.0f, 0.0f);
    _viewForBtn.layer.shadowRadius=4.5f;
    _viewForBtn.layer.shadowOpacity=0.9f;
    _viewForBtn.layer.masksToBounds=NO;
   
    UIBezierPath *shadowPath1=[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_viewForBtn.bounds, shadowInset)];
    _viewForBtn.layer.shadowPath=shadowPath1.CGPath;
    _grantPermissionBtn.layer.cornerRadius=5.0;
    self.navigationController.navigationBar.hidden=NO;
    [self fetchPermissions];
    // Do any additional setup after loading the view.
}

-(void)fetchPermissions
{
     DebugLog(@"");
    [self showBusyActivityView];
    _isFetchPermissions = YES;
//    APIhandler *h=[[APIhandler alloc]init];
//    h.delegate = self;
    
    mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc]init];
    apiHandler.delegate = self;
    
    _endpoint=@"fetchPermissionsPreviouslyGrantedByMe";
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    time_t currentTime = [[ServerSingleton sharedServerSingleton]time];
    
    NSString *currentDate  = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    NSString *guid = [[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"];
    NSString *nonce = [self genRandStringLength:36];

    NSLog(@"current Date :%@ ",currentDate);
    NSLog(@"%@",guid);
    NSLog(@"%@", nonce);
    
    NSString *payload=[NSString stringWithFormat:@"%@%@%@%@%@%@%@"
                       ,@"|",guid,@"|",currentDate,@"|",nonce,@"|"];
    
    NSLog(@"%@", payload);
    
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
    request_dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"ecdsa",@"cipher",guid,@"csiGuid",currentDate,@"dateTime",nonce,@"nonce",signatureString,@"signature" ,nil];
    //picker
    
    //#if ISDEBUG
    //
    //#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array2;
    if(_isDeletePermissions)
    {
        NSMutableArray *array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"PermissionsLogArray"];
        array2 = [NSMutableArray arrayWithArray:array1];
        
    }
    else
    {
        array2 = [[NSMutableArray alloc]init];
    }
    
    [array2 addObject:[NSString stringWithFormat:@"%@%@%@",Permission_Base_URL,_endpoint,request_dic]];
    //    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"PermissionsLogArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [debugView setHidden:true];
   // [h createSessionforPermissionEndPoint:_endpoint withModelDictionary:request_dic];
    
    [apiHandler createSessionforPermissionEndPoint:_endpoint withModelDictionary:request_dic];

//    _activityContainerView.hidden = false;
    
//    [activityIndicator startAnimating];
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

-(void)handleData :(NSData*)data errr:(NSError*)error
{
     DebugLog(@"");
    if(error)
    {
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideBusyActivityView];
        });
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
        NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"PermissionsLogArray"];
        NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
        [array2 addObject:[NSString stringWithFormat:@"%@%@%@",Permission_Base_URL,_endpoint,request_dic]];
        //    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
        [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"PermissionsLogArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
    indexArray = [[NSMutableArray alloc]init];
    indexFamilyArray = [[NSMutableArray alloc]init];
    _dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
#if ISDEBUG
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"PermissionsLogArray"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@",_dic]];
    //    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"PermissionsLogArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
#else
    dispatch_async(dispatch_get_main_queue(), ^{
        [_debugView setHidden:true];
        [_responseView setHidden:false];
        // [_debugContainerView setHidden:false];
        [_responseLabel setText:[NSString stringWithFormat:@"response dictionary: %@",_dic]];
    });
    
#endif
#else
    //    NSLog(@"not in debug mode");
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [_debugView setHidden:true];
    //        [activityIndicator stopAnimating];
    //        [self performSelector:@selector(loadDashboard) withObject:nil];
    //        //[_debugContainerView setHidden:true];
    //    });
    
    
#endif
    if(_isFetchPermissions)
    {
    NSArray *permissions = [_dic valueForKey:@"permissions"];
    NSMutableArray * serverCsiArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in permissions) {
        NSArray * permissionCsiArray = [dict objectForKey:@"permissionedCsiGuids"];
        [serverCsiArray addObjectsFromArray:permissionCsiArray];
    }
    
//    serverCsiArray = [permissionsDictionary objectForKey:@"permissionedCsiGuids"];
//    if([serverCsiArray count] != [_permissionsArray count] + [_permissionsFamilyArray count])
//    {
        for (NSString * csi in serverCsiArray) {
            for (NSString *permissionCsi in csiArray) {
                if([csi isEqualToString:permissionCsi])
                {
                    [indexArray addObject:[NSString stringWithFormat:@"%d", (int)[csiArray indexOfObject:permissionCsi]]];
                }
            }
        }
        for (NSString * csi in serverCsiArray) {
            for (NSString *permissionCsi in csiFamilyArray) {
                
                NSArray *arrData=[permissionCsi componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
                
                
                if([csi isEqualToString:arrData[3]])
                {
                    [indexFamilyArray addObject:[NSString stringWithFormat:@"%d", (int)[csiFamilyArray indexOfObject:permissionCsi]]];
                }
            }
        }
    
    if([NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"]] != nil)
    {
        _permissionsArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"]];
    }
    else
    {
        _permissionsArray = [[NSMutableArray alloc]init];
    }
    if([NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"]] != nil)
    {
        _permissionsFamilyArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"]];
    }
    else
    {
        _permissionsFamilyArray = [[NSMutableArray alloc]init];
    }
    NSMutableArray * permissionArrayCopy = [_permissionsArray copy];
    NSMutableArray * permissionFamilyArrayCopy = [_permissionsFamilyArray copy];
    
    for (PermissionData *permData in permissionArrayCopy) {
        BOOL isPresent = NO;
        for (NSString *index in indexArray) {
            if([index intValue] == permData.index)
            {
                isPresent = YES;
                break;
            }
        }
        if(!isPresent)
        {
            [_permissionsArray removeObject:permData];
        }
    }
    for (PermissionData *permData in permissionFamilyArrayCopy) {
        
        BOOL isPresent = NO;
        for (NSString *index in indexFamilyArray) {
            
            NSString *strData = csiFamilyArray[[index intValue]];
            NSArray *arrData = [strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
            
            if([permData.firstName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[0]].lowercaseString] && [permData.LastName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[1]].lowercaseString])
            {
//            if([index intValue] == permData.index)
//            {
                isPresent = YES;
                break;
            }
        }
        if(!isPresent)
        {
            [_permissionsFamilyArray removeObject:permData];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBusyActivityView];
        [_doctorFamilyTableView reloadData];
        [_doctorFamilySegmentedControl setTitle:[NSString stringWithFormat:@"Providers - (0%lu)",(unsigned long)[_permissionsArray count]] forSegmentAtIndex:0];
        [_doctorFamilySegmentedControl setTitle:[NSString stringWithFormat:@"Caregivers - (0%lu)",(unsigned long)[_permissionsFamilyArray count]] forSegmentAtIndex:1];
    });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchPermissions];
        });
    }
//    }
    
    //    if(!_isThirdCall)
    //    {
    //        _guidDictionary = _dic;
    //    }

    if(jsonError)
    {
        //        [NSException raise:@"Exception in parsing JSON data" format:@"%@",jsonError.localizedDescription];
    }
    
    
    
    //    _resultsArray=[[NSArray alloc]initWithArray:[dic objectForKey:@"companies"]];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(_doctorFamilySegmentedControl.selectedSegmentIndex == 0)
    {
        if(_isFiltered==NO)
        {
            return  [_permissionsArray count] + [panelArray count] ;
        }
        else
        {
            return [_filteredDoctorArray count] + [panelArray count];
        }
    }
    else
    {
        if(_isFamilyFiltered==NO)
        {
            return  [_permissionsFamilyArray count]+ [panelArray count];
        }else
        {
            return [_filteredFamilyArray count]+ [panelArray count];
        }
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"Cell";
    
    PermissionData *permData;
    if([panelArray count] == 0)
    {
        if(_doctorFamilySegmentedControl.selectedSegmentIndex == 0)
        {
            CustomCell *cell=(CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if(!_isFiltered)
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
                cell.checkButton.tag = indexPath.row;
                cell.deleteButton.tag = indexPath.row;
            //Add it to the label - notice its not text property but it's attributeText
                cell.fromAndToLabel.attributedText = attString;
                 return cell;
            }
            else{
                
                permData = _filteredDoctorPermissionArray[indexPath.row];
                cell.title.text=_filteredDoctorArray[indexPath.row];
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
                cell.image.image=[UIImage imageNamed:_filteredDoctorImgArray[indexPath.row]];
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
                cell.checkButton.tag = indexPath.row;
                cell.deleteButton.tag = indexPath.row;
                [cell.checkButton setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
                //Add it to the label - notice its not text property but it's attributeText
                cell.fromAndToLabel.attributedText = attString;
            
             return cell;
            }
        }
        else
        {
            CustomCell *cell=(CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if(!_isFamilyFiltered)
            {
                permData = _permissionsFamilyArray[indexPath.row];
                cell.subtitle.text = @"";
                BOOL isDataExisted=NO;
                NSString *gender;
                
                for (int iCount=0; iCount<[csiFamilyArray count]; iCount++)
                {
                    NSString *strData=csiFamilyArray[iCount];
                    NSArray *arrData=[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
                    
                    if([permData.firstName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[0]].lowercaseString] && [permData.LastName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[1]].lowercaseString])
                    {
                        if(![arrData[4] isEqualToString:@"NA"])
                        {
                            cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrData[4]]];
                        }
                        else
                        {
                            gender = arrData[2];
                            
                        }
                        isDataExisted=YES;
                        break;
                    }
                    
                }
                if([gender.lowercaseString isEqualToString:@"male"])
                {
                    cell.image.image=[UIImage imageNamed:@"maledefault.png"];
                }
                else if([gender.lowercaseString isEqualToString:@"female"])
                {
                    cell.image.image=[UIImage imageNamed:@"femaledefault.png"];
                }
               // cell.image.image = [UIImage imageNamed:imgFamilyArray[permData.index]];
                cell.title.text = [NSString stringWithFormat:@"%@ %@",permData.firstName,permData.LastName];//titleFamilyArray[permData.index];
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
                cell.checkButton.tag = indexPath.row;
                cell.deleteButton.tag = indexPath.row;
                //Add it to the label - notice its not text property but it's attributeText
                cell.fromAndToLabel.attributedText = attString;
            }
            else
            {
                permData = _filteredFamilyPermissionArray[indexPath.row];
                cell.subtitle.text = @"";
               // cell.image.image = [UIImage imageNamed:_filteredFamilyImgArray[indexPath.row]];
               // cell.title.text = _filteredFamilyArray[indexPath.row];
                BOOL isDataExisted=NO;
                NSString *gender;
                
                for (int iCount=0; iCount<[csiFamilyArray count]; iCount++)
                {
                    NSString *strData=csiFamilyArray[iCount];
                    NSArray *arrData=[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
                    
                    if([permData.firstName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[0]].lowercaseString] && [permData.LastName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[1]].lowercaseString])
                    {
                        if(![arrData[4] isEqualToString:@"NA"])
                        {
                            cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrData[4]]];
                        }
                        else
                        {
                            gender = arrData[2];
                            
                        }
                        isDataExisted=YES;
                        break;
                    }
                    
                }
                if([gender.lowercaseString isEqualToString:@"male"])
                {
                    cell.image.image=[UIImage imageNamed:@"maledefault.png"];
                }
                else if([gender.lowercaseString isEqualToString:@"female"])
                {
                    cell.image.image=[UIImage imageNamed:@"femaledefault.png"];
                }
                // cell.image.image = [UIImage imageNamed:imgFamilyArray[permData.index]];
                cell.title.text = [NSString stringWithFormat:@"%@ %@",permData.firstName,permData.LastName];
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
                cell.checkButton.tag = indexPath.row;
                cell.deleteButton.tag = indexPath.row;
                [cell.checkButton setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
                //Add it to the label - notice its not text property but it's attributeText
                cell.fromAndToLabel.attributedText = attString;
                
            }
             return cell;
        }
    }
    else
    {
        if(indexPath.row <= selectedIndex)
        {
            CustomCell *cell=(CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            if(_doctorFamilySegmentedControl.selectedSegmentIndex == 0)
            {
                if(!_isFiltered)
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
                    cell.checkButton.tag = indexPath.row;
                    cell.deleteButton.tag = indexPath.row;
                    //Add it to the label - notice its not text property but it's attributeText
                    cell.fromAndToLabel.attributedText = attString;
                     return cell;
                }
                else{
                    permData = _filteredDoctorPermissionArray[indexPath.row];
                    cell.title.text=_filteredDoctorArray[indexPath.row];
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
                    cell.image.image=[UIImage imageNamed:_filteredDoctorImgArray[indexPath.row]];
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
                    cell.checkButton.tag = indexPath.row;
                    cell.deleteButton.tag = indexPath.row;
                    //Add it to the label - notice its not text property but it's attributeText
                    cell.fromAndToLabel.attributedText = attString;
                     return cell;
                    
                }
            }
            else
            {
                if(!_isFamilyFiltered)
                {
                    permData = _permissionsFamilyArray[indexPath.row];
                    cell.subtitle.text = @"";
                    //cell.image.image = [UIImage imageNamed:imgFamilyArray[permData.index]];
                   // cell.title.text = titleFamilyArray[permData.index];
                    BOOL isDataExisted=NO;
                    NSString *gender;
                    
                    for (int iCount=0; iCount<[csiFamilyArray count]; iCount++)
                    {
                        NSString *strData=csiFamilyArray[iCount];
                        NSArray *arrData=[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
                        
                        if([permData.firstName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[0]].lowercaseString] && [permData.LastName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[1]].lowercaseString])
                        {
                            if(![arrData[4] isEqualToString:@"NA"])
                            {
                                cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrData[4]]];
                            }
                            else
                            {
                                gender = arrData[2];
                                
                            }
                            isDataExisted=YES;
                            break;
                        }
                        
                    }
                    if([gender.lowercaseString isEqualToString:@"male"])
                    {
                        cell.image.image=[UIImage imageNamed:@"maledefault.png"];
                    }
                    else if([gender.lowercaseString isEqualToString:@"female"])
                    {
                        cell.image.image=[UIImage imageNamed:@"femaledefault.png"];
                    }
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
                    cell.checkButton.tag = indexPath.row;
                    cell.deleteButton.tag = indexPath.row;
                    //Add it to the label - notice its not text property but it's attributeText
                    cell.fromAndToLabel.attributedText = attString;
                }
                else
                {
                    permData = _filteredFamilyPermissionArray[indexPath.row];
                    cell.subtitle.text = @"";
                    //cell.image.image = [UIImage imageNamed:_filteredFamilyImgArray[indexPath.row]];
                   // cell.title.text = _filteredFamilyArray[indexPath.row];
                    BOOL isDataExisted=NO;
                    NSString *gender;
                    
                    for (int iCount=0; iCount<[csiFamilyArray count]; iCount++)
                    {
                        NSString *strData=csiFamilyArray[iCount];
                        NSArray *arrData=[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
                        
                        if([permData.firstName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[0]].lowercaseString] && [permData.LastName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[1]].lowercaseString])
                        {
                            if(![arrData[4] isEqualToString:@"NA"])
                            {
                                cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrData[4]]];
                            }
                            else
                            {
                                gender = arrData[2];
                                
                            }
                            isDataExisted=YES;
                            break;
                        }
                        
                    }
                    if([gender.lowercaseString isEqualToString:@"male"])
                    {
                        cell.image.image=[UIImage imageNamed:@"maledefault.png"];
                    }
                    else if([gender.lowercaseString isEqualToString:@"female"])
                    {
                        cell.image.image=[UIImage imageNamed:@"femaledefault.png"];
                    }
                    // cell.image.image = [UIImage imageNamed:imgFamilyArray[permData.index]];
                    cell.title.text = [NSString stringWithFormat:@"%@ %@",permData.firstName,permData.LastName];
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
                    cell.checkButton.tag = indexPath.row;
                    cell.deleteButton.tag = indexPath.row;
                    //Add it to the label - notice its not text property but it's attributeText
                    cell.fromAndToLabel.attributedText = attString;
                    
                }
                 return cell;
            }
        }
        if(indexPath.row == selectedIndex + 1)
        {
            NSString *cellIdentifier1=@"permissionResourcesCell";
            PermissionResourcesTableViewCell *cell1=(PermissionResourcesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            
            if(optionalResource)
            {
                cell1.optionalResourcesLabel.hidden = false;
            }
            else
            {
                cell1.optionalResourcesLabel.hidden = true;
                cell1.conditionsLabelTopConstraint.constant = 20;
            }
//            [cell setSeparatorInset:UIEdgeInsetsZero];
            return cell1;
        }
        else if(indexPath.row > selectedIndex && indexPath.row != selectedIndex + 1)
        {
            if(_doctorFamilySegmentedControl.selectedSegmentIndex == 0)
            {
                CustomCell *cell=(CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if(!_isFiltered)
                {
                    permData = _permissionsArray[indexPath.row - 1];
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
                    cell.checkButton.tag = indexPath.row;
                    cell.deleteButton.tag = indexPath.row;
                    //Add it to the label - notice its not text property but it's attributeText
                    cell.fromAndToLabel.attributedText = attString;
                     return cell;
                }
                else{
                    permData = _filteredDoctorPermissionArray[indexPath.row - 1];
                    cell.title.text=_filteredDoctorArray[indexPath.row - 1];
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
                    cell.image.image=[UIImage imageNamed:_filteredDoctorImgArray[indexPath.row - 1]];
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
                    cell.checkButton.tag = indexPath.row;
                    cell.deleteButton.tag = indexPath.row;
                    //Add it to the label - notice its not text property but it's attributeText
                    cell.fromAndToLabel.attributedText = attString;
                     return cell;
                    
                }
            }
            else
            {
                CustomCell *cell=(CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                if(!_isFamilyFiltered)
                {
                    permData = _permissionsFamilyArray[indexPath.row - 1];
                    cell.subtitle.text = @"";
                   /// cell.image.image = [UIImage imageNamed:imgFamilyArray[permData.index]];
                    //cell.title.text = titleFamilyArray[permData.index];
                    BOOL isDataExisted=NO;
                    NSString *gender;
                    
                    for (int iCount=0; iCount<[csiFamilyArray count]; iCount++)
                    {
                        NSString *strData=csiFamilyArray[iCount];
                        NSArray *arrData=[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
                        
                        if([permData.firstName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[0]].lowercaseString] && [permData.LastName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[1]].lowercaseString])
                        {
                            if(![arrData[4] isEqualToString:@"NA"])
                            {
                                cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrData[4]]];
                            }
                            else
                            {
                                gender = arrData[2];
                                
                            }
                            isDataExisted=YES;
                            break;
                        }
                        
                    }
                    if([gender.lowercaseString isEqualToString:@"male"])
                    {
                        cell.image.image=[UIImage imageNamed:@"maledefault.png"];
                    }
                    else if([gender.lowercaseString isEqualToString:@"female"])
                    {
                        cell.image.image=[UIImage imageNamed:@"femaledefault.png"];
                    }
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
                    cell.deleteButton.tag = indexPath.row;
                    //Add it to the label - notice its not text property but it's attributeText
                    cell.fromAndToLabel.attributedText = attString;
                }
                else
                {
                    permData = _filteredFamilyPermissionArray[indexPath.row - 1];
                    cell.subtitle.text = @"";
                    cell.image.image = [UIImage imageNamed:_filteredFamilyImgArray[indexPath.row - 1]];
                    cell.title.text = _filteredFamilyArray[indexPath.row];
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
                    cell.deleteButton.tag = indexPath.row;
                    //Add it to the label - notice its not text property but it's attributeText
                    cell.fromAndToLabel.attributedText = attString;
                    
                }
                 return cell;
            }
        }
        
    }
    return nil;
   
}
- (IBAction)checkButtonTapped:(id)sender {
     DebugLog(@"");
    UIButton * button = (UIButton *)sender;
//    UITableViewCell *cell = [_doctorFamilyTableView cellForRowAtIndexPath:indexPath];
//    if ([cell.reuseIdentifier isEqualToString: @"Cell"])
//    {
    if(!isPanelOpen)
    {
        isPanelOpen = YES;
        oldSelectedIndex = selectedIndex;
        selectedIndex = (int)button.tag;
        [self.searchBar resignFirstResponder];
        if(_isFiltered)
        {
            //[self.searchBar resignFirstResponder];
//            CustomCell *cell = [self.doctorFamilyTableView cellForRowAtIndexPath:indexPath];
//            if (_doctorFamilySegmentedControl.selectedSegmentIndex == 0) {
//                filteredSelectedIndex = (int)[titleArray indexOfObject:cell.title.text];
//            }
//            else
//            {
//                filteredSelectedIndex = (int)[titleFamilyArray indexOfObject:cell.title.text];
//            }
//        }
        }
        [button setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        [self showPermissionPanelForRowAtIndexPath:[NSIndexPath indexPathWithIndex:button.tag]];
        [_doctorFamilyTableView reloadData];
    }
    else
    {
        isPanelOpen = NO;
        [self removePermissionPanel];
        [_doctorFamilyTableView reloadData];
        [button setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
    }
//        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.reuseIdentifier isEqualToString: @"Cell"])
//    {
//        oldSelectedIndex = selectedIndex;
//        selectedIndex = (int)indexPath.row;
//        [self.searchBar resignFirstResponder];
//        if(_isFiltered)
//        {
//            //[self.searchBar resignFirstResponder];
//            CustomCell *cell = [self.doctorFamilyTableView cellForRowAtIndexPath:indexPath];
//            if (_doctorFamilySegmentedControl.selectedSegmentIndex == 0) {
//                filteredSelectedIndex = (int)[titleArray indexOfObject:cell.title.text];
//            }
//            else
//            {
//                filteredSelectedIndex = (int)[titleFamilyArray indexOfObject:cell.title.text];
//            }
//        }
//        [self showPermissionPanelForRowAtIndexPath:indexPath];
//        [tableView reloadData];
//        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//    }
//    else
//    {
//        [self.searchBar resignFirstResponder];
//        //        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }
//
//
//}

-(void)showPermissionPanelForRowAtIndexPath:(NSIndexPath *)indexPath
{
     DebugLog(@"");
    NSMutableArray *deleteIndexPaths;
    //            if([self hasInlineDatePicker])
    //            {
    if([panelArray count] > 0)
    {
        [panelArray removeAllObjects];
        
        deleteIndexPaths = [NSMutableArray arrayWithObjects:
                            [NSIndexPath indexPathForRow:oldSelectedIndex + 1 inSection:0],
                            nil];
        
        if(oldSelectedIndex < selectedIndex)
        {
            selectedIndex = selectedIndex - 1;
        }
        else
        {
    
        }
    }
    [panelArray insertObject:@"permission" atIndex:0];

    
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:selectedIndex + 1 inSection:0],
                                 nil];
    [self.doctorFamilyTableView beginUpdates];
    [self.doctorFamilyTableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    [self.doctorFamilyTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.doctorFamilyTableView endUpdates];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     DebugLog(@"");
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"grant_new_permission"])
    {
        // Get reference to the destination view controller
        PermissionController *vc = [segue destinationViewController];
        vc.isFromViewGrantedPermission = YES;
        // Pass any objects to the view controller here, like...
       
    }
}

    - (IBAction)segmentedControlValueChanged:(id)sender
    {
         DebugLog(@"");
        if(_doctorFamilySegmentedControl.selectedSegmentIndex == 0)
        {
            [self.doctorFamilyTableView reloadData];
            if([panelArray count] > 0)
            {
                [self removePermissionPanel];
            }
            [self searchBar:self.searchBar textDidChange:searchString];
        }
        else
        {
            [self.doctorFamilyTableView reloadData];
            if([panelArray count] > 0)
            {
                [self removePermissionPanel];
            }
            [self searchBar:self.searchBar textDidChange:searchString];
        }
    }

-(void)removePermissionPanel
{
     DebugLog(@"");
    isPanelOpen = NO;
    [panelArray removeAllObjects];
    NSMutableArray *deleteIndexPaths;
    deleteIndexPaths = [NSMutableArray arrayWithObjects:
                        [NSIndexPath indexPathForRow:selectedIndex + 1 inSection:0],
                        
                        nil];
    
    [_doctorFamilyTableView beginUpdates];
    [self.doctorFamilyTableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [self.doctorFamilyTableView endUpdates];
    
}

- (void)didReceiveMemoryWarning {
     DebugLog(@"");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
     DebugLog(@"");
    searchString = searchText;
    if(_doctorFamilySegmentedControl.selectedSegmentIndex == 0)
    {
        if(searchText.length==0)
        {
            _isFiltered=NO;
            noDataLabel.hidden = YES;
            [_doctorFamilyTableView reloadData];
        }
        else
        {
            _isFiltered=YES;
            _filteredDoctorArray=[[NSMutableArray alloc]init];
            _filteredDoctorImgArray=[[NSMutableArray alloc]init];
            _filteredDoctorPermissionArray=[[NSMutableArray alloc]init];
            for (int i=0; i< [_permissionsArray count]; i++)
            {
                PermissionData *data=[_permissionsArray objectAtIndex:i];
                NSRange range=[titleArray[data.index] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location!=NSNotFound)
                {
                    noDataLabel.hidden=YES;
                    [_filteredDoctorArray addObject:titleArray[i]];
                    [_filteredDoctorImgArray addObject:imgArray[i]];
                    
                    for (PermissionData *permData in _permissionsArray)
                    {
                        if(permData.index == i)
                        {
                            [_filteredDoctorPermissionArray addObject:permData];
                            break;
                        }
                    }
                }
                else{
                    
                    noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _view1.bounds.size.width, _view1.bounds.size.height)];
                    noDataLabel.text             = @"No results found";
                    noDataLabel.textColor        = [UIColor blackColor];
                    noDataLabel.textAlignment    = NSTextAlignmentCenter;
                    
                    _doctorFamilyTableView.backgroundView = noDataLabel;
                    _doctorFamilyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                }
            }
            if(_filteredDoctorArray.count==0)
            {
                noDataLabel.hidden=false;
            }
            else
            {
                noDataLabel.hidden=true;
            }
            
            if([panelArray count] > 0)
            {
                [panelArray removeAllObjects];
                isPanelOpen = NO;
            }
        }
    }
    else
    {
        if(searchText.length==0)
        {
            _isFamilyFiltered=NO;
            noDataLabel.hidden = YES;
            [_doctorFamilyTableView reloadData];
        }
        else
        {
            _isFamilyFiltered=YES;
            _filteredFamilyArray=[[NSMutableArray alloc]init];
            _filteredFamilyImgArray=[[NSMutableArray alloc]init];
            _filteredFamilyPermissionArray=[[NSMutableArray alloc]init];
            for (int i=0; i< [_permissionsFamilyArray count]; i++)
            {
                PermissionData *data=[_permissionsFamilyArray objectAtIndex:i];
                NSRange range=[titleFamilyArray[data.index] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location!=NSNotFound)
                {
                    noDataLabel.hidden=YES;
                    [_filteredFamilyArray addObject:titleFamilyArray[i]];
                    [_filteredFamilyImgArray addObject:imgFamilyArray[i]];
                    
                    for (PermissionData *permData in _permissionsArray)
                    {
                        if(permData.index == i)
                        {
                            [_filteredFamilyPermissionArray addObject:permData];
                            break;
                        }
                    }
                }
                else{
                    
                    noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _view1.bounds.size.width, _view1.bounds.size.height)];
                    noDataLabel.text             = @"No results found";
                    noDataLabel.textColor        = [UIColor blackColor];
                    noDataLabel.textAlignment    = NSTextAlignmentCenter;
                    
                    _doctorFamilyTableView.backgroundView = noDataLabel;
                    _doctorFamilyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                }
            }
            if(_filteredFamilyArray.count==0)
            {
                noDataLabel.hidden=false;
            }
            else
            {
                noDataLabel.hidden=true;
            }
            
            if([panelArray count] > 0)
            {
                [panelArray removeAllObjects];
                isPanelOpen = NO;
            }
        }
    }
    [_doctorFamilyTableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
     DebugLog(@"");
    [searchBar resignFirstResponder];
}

- (IBAction)deletePermissionTapped:(id)sender {
     DebugLog(@"");
    _isDeletePermissions = YES;
    UIButton * button = (UIButton *)sender;
    NSString *csi;
    if(_doctorFamilySegmentedControl.selectedSegmentIndex == 0)
    {
        PermissionData * permData = _permissionsArray[button.tag];
        csi = csiArray[permData.index];
    }
    else
    {
        PermissionData * permData = _permissionsFamilyArray[button.tag];
        //csi = csiFamilyArray[permData.index];
        for (int iCount=0; iCount<[csiFamilyArray count]; iCount++)
        {
            NSString *strData=csiFamilyArray[iCount];
            NSArray *arrData=[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
            
            if([permData.firstName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[0]].lowercaseString] && [permData.LastName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[1]].lowercaseString])
            {
                csi=arrData[3];
                break;
            }
        }
        
        
        
    }
    
    [self showBusyActivityView];
//    APIhandler *h=[[APIhandler alloc]init];
//    h.delegate = self;
    
    mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc]init];
    apiHandler.delegate = self;
    
    _endpoint=@"deletePermission";
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    time_t currentTime = [[ServerSingleton sharedServerSingleton]time];
    
    NSString *currentDate  = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    NSString *guid = [[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"];
    NSString *nonce = [self genRandStringLength:36];
    
//    NSMutableArray * permissionCsiGuids = [[NSMutableArray alloc]init];
//    [permissionCsiGuids addObject:csi];
//
//    NSString *endDateInRequiredFormat = [dateformatter stringFromDate:[NSDate date]];
//
//    NSDate *newDate = [[NSDate date] dateByAddingTimeInterval:-1];
//    NSString *startDateInRequiredFormat = [dateformatter stringFromDate:newDate];
//
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    [array addObject:@"ETH"];
//    [array addObject:@"SOC"];
//    NSDictionary * heartScope = [[NSDictionary alloc]initWithObjectsAndKeys:@"",@"accessType",@"V",@"confidentialityScope",@"patient",@"permissionType",@"",@"resourceScope",array,@"sensitivityScope", nil];
//
//    NSDictionary * permission = [[NSDictionary alloc]initWithObjectsAndKeys:endDateInRequiredFormat,@"endTime",heartScope,@"heartScope",permissionCsiGuids,@"permissionedCsiGuids",startDateInRequiredFormat,@"startTime",currentDate,@"timeStamp", nil];
//
//    NSString *payload=[NSString stringWithFormat:@"%@%@%@%@%@"
//                       // %@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@"
//                       ,@"|",endDateInRequiredFormat,@"|",startDateInRequiredFormat,@"|"];
//    //,fullString,@"|",@"patient",@"|",@"V",@"|",[array objectAtIndex:0],@"|",[array objectAtIndex:1],@"|",@"Patient",@"|",guid,@"|",currentDate,@"|",nonce,@"|"];
//    NSLog(@"%@", payload);
//    NSMutableString * payloadMutableString = [NSMutableString stringWithFormat:@"%@", payload];
//    for (NSString * string in permissionCsiGuids) {
//        [payloadMutableString appendString:[NSString stringWithFormat:@"%@|",string]];
//    }
//    [payloadMutableString appendString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"patient",@"|",@"V",@"|",[array objectAtIndex:0],@"|",[array objectAtIndex:1],@"|",@"",@"|",guid,@"|",currentDate,@"|",nonce,@"|"]];
    
    NSString *payload=[NSString stringWithFormat:@"%@%@%@%@%@%@%@"
                       ,@"|",csi,@"|",currentDate,@"|",nonce,@"|"];
    
    NSLog(@"%@", payload);
    NSData * dataForSignature = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *signature=[self createSignature:dataForSignature withKey:privateKey];
    NSString *signatureString = [signature base64EncodedStringWithOptions:0];
    request_dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"ecdsa",@"cipher",guid,@"csiGuid",currentDate,@"dateTime",nonce,@"nonce",csi,@"permissionedGuidBeingDeleted",signatureString,@"signature" ,nil];
    //picker
    
    //#if ISDEBUG
    //
    //#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"PermissionsLogArray"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@%@%@",Permission_Base_URL,_endpoint,request_dic]];
    //    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"PermissionsLogArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [debugView setHidden:true];
   // [h createSessionforPermissionEndPoint:_endpoint withModelDictionary:request_dic];
    
    [apiHandler createSessionforPermissionEndPoint:_endpoint withModelDictionary:request_dic];

    //    _activityContainerView.hidden = false;
    _isFetchPermissions = NO;
    
}
#pragma mark -
#pragma mark ==============================
#pragma mark Activity Indicator Methods
#pragma mark ==============================
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





