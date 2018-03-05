//
//  SelectMemberViewController.m
//  mHealthDApp
//
//  Created by Sonam Agarwal on 11/17/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import "SelectMemberViewController.h"
#import "SelectMemberTableViewCell.h"
#import "HeaderView.h"
#import "UICKeyChainStore.h"
#import "Constants.h"
#import "AddCSIViewController.h"
#import "APIhandler.h"
#import "ServerSingleton.h"
#import "DejalActivityView.h"


@interface SelectMemberViewController ()<HeaderViewDelegate>
{
    NSArray *imgFamilyArray;
    NSArray *titleFamilyArray;
    NSArray *namesArray;
    NSArray *fromDateArray;
    NSArray *toDateArray;
    NSArray * publicClaims;
    int selectedIndex;
    NSMutableArray *existingCaregiverDataArray;
    NSMutableString *strBecomeFriendData;
    
    SecKeyRef privateKey;
    SecKeyAlgorithm algorithm;
    NSDictionary *request_dic;
    
    NSMutableArray *caregiverPermissionDataArray;
    BOOL isCaregiverBool;
    
}
@property (strong, nonatomic) IBOutlet UIView *viewForBtn;
@property (strong, nonatomic) IBOutlet UIView *backgroundVw;
@property (strong, nonatomic) IBOutlet UITableView *permissionDataTableView;
@property (strong, nonatomic) IBOutlet UIButton *updateBtn;
@property (strong, nonatomic) IBOutlet UIButton *btnBecomeFriend;
@property (strong, nonatomic) IBOutlet UIButton *btnInviteFriend;
//added changes for fetch permission call
@property (nonatomic) BOOL isFetchPermissions;
@property(nonatomic) NSString *endpoint;

@end

@implementation SelectMemberViewController
@synthesize permissionDataTableView;
@synthesize backgroundVw;
- (IBAction)copyLink:(id)sender {
    DebugLog(@"");
    [UIPasteboard generalPasteboard].string =@"hello";
}

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    
    existingCaregiverDataArray=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:FINALFAMILYDATAARRAY]];
    publicClaims = [[NSUserDefaults standardUserDefaults]valueForKey:@"PublicClaims"];
    caregiverPermissionDataArray=[[NSMutableArray alloc] init];

    
    strBecomeFriendData = [[NSMutableString alloc] initWithString:@""];
    [strBecomeFriendData appendString:[NSString stringWithFormat:@"%@",[[publicClaims objectAtIndex:1] objectForKey:@"value"]]];
    [strBecomeFriendData appendString:[NSString stringWithFormat:@"%@%@",COMPONENTS_SEPERATED_STRING,[[publicClaims objectAtIndex:3] objectForKey:@"value"]]];
    [strBecomeFriendData appendString:[NSString stringWithFormat:@"%@%@",COMPONENTS_SEPERATED_STRING,[[publicClaims objectAtIndex:4] objectForKey:@"value"]]];
    [strBecomeFriendData appendString:[NSString stringWithFormat:@"%@%@",COMPONENTS_SEPERATED_STRING,[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"]]];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor=[UIColor clearColor];
    self.modalPresentationStyle=UIModalPresentationCurrentContext;
    _updateBtn.layer.cornerRadius=5.0;
    
    
    
    selectedIndex=-1;
    NSNumber *isCaregiver;//= [[NSUserDefaults standardUserDefaults]valueForKey:@"isCaregiver"];
    NSString *isCaregiverFlow=[[NSUserDefaults standardUserDefaults]valueForKey:@"Flow"];
    
    if([isCaregiverFlow isEqualToString:@"Caregiver"])
    {
        isCaregiver=[NSNumber numberWithInt:1];
    }
    else
    {
        isCaregiver=[NSNumber numberWithInt:0];
    }
    isCaregiverBool=[isCaregiver boolValue];
    if(!isCaregiverBool)
    {
        if (imgFamilyArray == nil)
        {
            imgFamilyArray=[[NSArray alloc]initWithObjects:@"Patient",@"Mother",@"Father",@"Brother",@"Sister", nil];
        }
        if (titleFamilyArray == nil)
        {
            titleFamilyArray=[[NSArray alloc]initWithObjects:@"      ",@"Daughter",@"Father",@"Brother",@"Sister", nil];
        }
        namesArray=[NSArray arrayWithObjects:@"Hefty Harvey",@"Worried Wendy",@"Tim Watson",@"Michael Watson",@"Jenny Watson", nil];
        fromDateArray=[NSArray arrayWithObjects:@"",@"11/18/17",@"11/19/17",@"11/20/17",@"11/21/17", nil];
        toDateArray=[NSArray arrayWithObjects:@"",@"12/18/17",@"12/19/17",@"12/20/17",@"12/21/17", nil];
    }
    else{
        if (imgFamilyArray == nil)
        {
            imgFamilyArray=[[NSArray alloc]initWithObjects:@"Mother",@"Father",@"Brother",@"Sister", nil];
        }
        if (titleFamilyArray == nil)
        {
            titleFamilyArray=[[NSArray alloc]initWithObjects:@"Mother",@"Father",@"Brother",@"Sister", nil];
        }
        namesArray=[NSArray arrayWithObjects:@"Crystal Watson",@"Tim Watson",@"Michael Watson",@"Jenny Watson", nil];
        fromDateArray=[NSArray arrayWithObjects:@"11/18/17",@"11/19/17",@"11/20/17",@"11/21/17", nil];
        toDateArray=[NSArray arrayWithObjects:@"12/18/17",@"12/19/17",@"12/20/17",@"12/21/17", nil];
    }
    _viewForBtn.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    _viewForBtn.layer.shadowOffset=CGSizeMake(0.0f, 0.0f);
    _viewForBtn.layer.shadowRadius=4.5f;
    _viewForBtn.layer.shadowOpacity=0.9f;
    _viewForBtn.layer.masksToBounds=NO;
     UIEdgeInsets shadowInset=UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath1=[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_viewForBtn.bounds, shadowInset)];
    _viewForBtn.layer.shadowPath=shadowPath1.CGPath;
    
    
    
    if(isCaregiverBool)
    {
        [self fetchPermission];
    }
}
-(void)fetchPermission
{
    DebugLog(@"");
    [self showBusyActivityView];
    _isFetchPermissions = YES;
    APIhandler *
    h=[[APIhandler alloc]init];
    h.delegate = self;
    _endpoint=@"fetchPermissionsGivenToMe";
    
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
    
    NSString *payload=[NSString stringWithFormat:@"%@%@%@%@%@"
                       //                       %@%@"
                       //                       ,@"|",guid,
                       ,@"|",currentDate,@"|",nonce,@"|"];
    
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
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"PermissionsLogArray"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"PermissionsLogArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [debugView setHidden:true];
    [h createSessionforPermissionEndPoint:_endpoint withModelDictionary:request_dic];
    
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
    //    indexArray = [[NSMutableArray alloc]init];
    //    indexFamilyArray = [[NSMutableArray alloc]init];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    
    NSArray *arrData =[dict objectForKey:@"permissions"];
    for (int iCount=0; iCount<[arrData count]; iCount++)
    {
        NSDictionary *dictData=arrData[iCount];
        NSString *strGrantingGUID = [dictData objectForKey:@"grantingCsiGuid"];
        NSString *startTime=[dictData objectForKey:@"startTime"];
        NSString *endTime=[dictData objectForKey:@"endTime"];

        for (int jCount=0; jCount<[existingCaregiverDataArray count]; jCount++)
        {
            NSMutableString *strPermission =[[NSMutableString alloc] initWithString:existingCaregiverDataArray[jCount]];
            [strPermission appendString:[NSString stringWithFormat:@"#%@",startTime]];
            [strPermission appendString:[NSString stringWithFormat:@"#%@",endTime]];
            
            
            NSArray *arrPermission =[strPermission componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
            //if([strGrantingGUID isEqualToString:arrPermission[3]])//4d2e3274-ee88-4d75-9a1c-899bfe693cc7
            if([strGrantingGUID isEqualToString:arrPermission[3]])
            {
                [caregiverPermissionDataArray addObject:strPermission];
                break;
                
            }
            
        }
        
    }
    NSLog(@"%@",caregiverPermissionDataArray);
    dispatch_async(dispatch_get_main_queue(), ^{
        [permissionDataTableView reloadData];
        [self hideBusyActivityView];
       // backgroundVw.backgroundColor=[UIColor greenColor];
        backgroundVw.alpha=0.4;

 });
    
    
}
-(void)closeButtonTapped
{
    DebugLog(@"");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)resetButtonTapped:(id)sender {
    DebugLog(@"");
    [UICKeyChainStore setString:nil forKey:@"dcsi" service:@"MyService"];
    [UICKeyChainStore setString:nil forKey:@"dSharedPermissions" service:@"MyService"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"UniqueIdentifier"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"dcsi"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"dpermissionshared"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"wcsi"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Flow"];
}
- (IBAction)logoutButtonTapped:(id)sender {
    DebugLog(@"");
    exit (0);
}
- (IBAction)btnInviteFriendClicked:(id)sender {
    DebugLog(@"");
    [self performSegueWithIdentifier:@"SelectMemberToAddCSI" sender:self];//PermissionViewToViewController

}
- (IBAction)btnBecomeFriendClicked:(id)sender {
    DebugLog(@"");
    [UIPasteboard generalPasteboard].string = strBecomeFriendData;

}


- (void)didReceiveMemoryWarning {
    DebugLog(@"");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateBtnTapped:(id)sender {
    DebugLog(@"");
    if(!isCaregiverBool)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Selected_Index" object:[NSNumber numberWithInt:selectedIndex]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if(caregiverPermissionDataArray.count>0)
//        return 2;
//    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(section == 0)
//    {
//        return 1;
//    }
//    else
//    {
        return caregiverPermissionDataArray.count;
//    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!isCaregiverBool)
    {
       NSString *identifier=@"Cell";
       NSString *firstName = [(NSDictionary *)[publicClaims objectAtIndex:1] valueForKey:@"value"];
       NSString *lastName = [(NSDictionary *)[publicClaims objectAtIndex:3] valueForKey:@"value"];
       SelectMemberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
       cell.titleLabel.text=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
       cell.subtitle_Label.text=[titleFamilyArray objectAtIndex:indexPath.row];
       
       BOOL isDataExisted=NO;
       NSString *gender;
       for (int iCount=0; iCount<existingCaregiverDataArray.count; iCount++)
       {
           NSString *strData=existingCaregiverDataArray[iCount];
           NSArray *arrData=[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
           //if([firstName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[0]].lowercaseString] && [lastName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[1]].lowercaseString])
           if([firstName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[0]].lowercaseString] && [lastName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[1]].lowercaseString])
           {
               //set image for existing
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
       if(!isDataExisted)
       {
           gender = [(NSDictionary *)[publicClaims objectAtIndex:4] valueForKey:@"value"];
       }
       
       if([gender.lowercaseString isEqualToString:@"male"])
       {
           cell.image.image=[UIImage imageNamed:@"maledefault.png"];
       }
       else if([gender.lowercaseString isEqualToString:@"female"])
       {
           cell.image.image=[UIImage imageNamed:@"femaledefault.png"];
       }
       
    
       
       NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",fromDateArray[indexPath.row],toDateArray[indexPath.row]];
       //Create mutable string from original one
       NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
       
       //Fing range of the string you want to change colour
       //If you need to change colour in more that one place just repeat it
       NSRange range = [myString rangeOfString:fromDateArray[indexPath.row]];
       [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1] range:range];
       [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0f] range:range];
       NSRange range1 = [myString rangeOfString:toDateArray[indexPath.row]];
       [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1] range:range1];
       [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0f] range:range1];
       
       //Add it to the label - notice its not text property but it's attributeText
       cell.fromtolabel.attributedText = attString;
       
       if(selectedIndex==indexPath.row)
       {
           cell.radioImage.image=[UIImage imageNamed:@"radio_btn"];
       }
       else
       {
           cell.radioImage.image=[UIImage imageNamed:@"radio_uncheck"];
       }
       if(indexPath.row == 0 && !(isCaregiverBool))
       {
           cell.fromtolabel.text = @"Me-Patient";
       }
       if(selectedIndex==-1 && indexPath.row==0)
       {
           cell.radioImage.image=[UIImage imageNamed:@"radio_btn"];
           
           return cell;
       }
       //    NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",fromDateArray[indexPath.row],toDateArray[indexPath.row]];
       //    //Create mutable string from original one
       //    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
       //
       //    //Fing range of the string you want to change colour
       //    //If you need to change colour in more that one place just repeat it
       //    NSRange range = [myString rangeOfString:fromDateArray[indexPath.row]];
       //    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1] range:range];
       //    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0f] range:range];
       //    NSRange range1 = [myString rangeOfString:toDateArray[indexPath.row]];
       //    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1] range:range1];
       //    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0f] range:range1];
       //
       //    //Add it to the label - notice its not text property but it's attributeText
       //    cell.fromtolabel.attributedText = attString;
       return cell;
   }
    else
    {
        NSString *identifier=@"Cell";
        SelectMemberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        NSString *strData = caregiverPermissionDataArray[indexPath.row];
        NSArray *arrData = [strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
        
        cell.titleLabel.text=[NSString stringWithFormat:@"%@ %@",arrData[0],arrData[1]];
       if(![arrData[4] isEqualToString:@"NA"])
           cell.subtitle_Label.text=arrData[4];
        
        NSString *startTime=arrData[5];
        NSString *endTime=arrData[6];
        
        if(![arrData[4] isEqualToString:@"NA"])
        {
            cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrData[4]]];
        }
        else
        {
            NSString *gender = arrData[2];
            if([gender.lowercaseString isEqualToString:@"male"])
            {
                cell.image.image=[UIImage imageNamed:@"maledefault.png"];
            }
            else if([gender.lowercaseString isEqualToString:@"female"])
            {
                cell.image.image=[UIImage imageNamed:@"femaledefault.png"];
            }
        }
        
        NSDateFormatter *dateformatter1 = [[NSDateFormatter alloc] init];
        [dateformatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        dateformatter1.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        NSDate *startDateInDate = [dateformatter1 dateFromString:startTime];
        NSDate *endDateInDate = [dateformatter1 dateFromString:endTime];
        
        [dateformatter1 setDateFormat:@"dd/MM/yy"];
        [dateformatter1 setTimeZone:[NSTimeZone localTimeZone]];
        NSString *formattedStartTime = [dateformatter1 stringFromDate:startDateInDate];
        NSString *formattedEndTime = [dateformatter1 stringFromDate:endDateInDate];

        
        NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",formattedStartTime,formattedEndTime];
        //Create mutable string from original one
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
        
        //Fing range of the string you want to change colour
        //If you need to change colour in more that one place just repeat it
        NSRange range = [myString rangeOfString:fromDateArray[indexPath.row]];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1] range:range];
        [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0f] range:range];
        NSRange range1 = [myString rangeOfString:toDateArray[indexPath.row]];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1] range:range1];
        [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNext-Medium" size:14.0f] range:range1];
        
        //Add it to the label - notice its not text property but it's attributeText
        cell.fromtolabel.attributedText = attString;
        
        if(selectedIndex==indexPath.row)
        {
            cell.radioImage.image=[UIImage imageNamed:@"radio_btn"];
        }
        else
        {
            cell.radioImage.image=[UIImage imageNamed:@"radio_uncheck"];
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *viewArray=[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil];
    HeaderView *view=(HeaderView *)[viewArray objectAtIndex:0];
    view.delegate = self;
    return view;
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    NSArray *viewArray=[[NSBundle mainBundle]loadNibNamed:@"FooterView" owner:self options:nil];
//    UIView *view=[viewArray objectAtIndex:0];
//    return view;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    if(!isCaregiverBool)
    {
        selectedIndex=(int)indexPath.row;
        [permissionDataTableView reloadData];
        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:selectedIndex] forKey:@"Selected_Index"];
    }
    else
    {
        
        selectedIndex=(int)indexPath.row;
        [permissionDataTableView reloadData];
         [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:selectedIndex] forKey:@"Selected_Index"];
        
        [[NSUserDefaults standardUserDefaults] setObject:caregiverPermissionDataArray[indexPath.row] forKey:@"ProfileImageData"];
        
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 70;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DebugLog(@"");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SelectMemberToAddCSI"])
    {
        AddCSIViewController *addCSIViewController = segue.destinationViewController;
        addCSIViewController.strFromScreen=@"PatientFlow";
        
    }
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
