//
//  SelectFamilyMemberViewController.m
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "SelectFamilyMemberViewController.h"
#import "SelectFamilyMemberTableViewCell.h"
#import "APIhandler.h"
#import "ServerSingleton.h"
#import "Constants.h"
#import "DejalActivityView.h"
#import "AddCSIViewController.h"
#import "TestCollectionViewCell.h"
#import "TestCollectionViewCell_Ipad.h"
#import "DocCollectionViewCell.h"
#import "DocCollectionViewCell_Ipad.h"

@interface SelectFamilyMemberViewController ()
{
    NSArray *family;
    NSArray *family_subtitle;
    NSArray * imgFamilyArray;
    int selectedIndex;
    SecKeyRef privateKey;
    SecKeyAlgorithm algorithm;
    NSDictionary *request_dic;
    NSMutableArray * serverCsiArray;
    NSMutableString *stringPublicData;
    
    int collectionTwoIndex;
}

@property (strong, nonatomic) IBOutlet UITableView *selectFamilyMemberTableView;

@property (strong,nonatomic) IBOutlet UIButton *btnBecomeFriend;
@property(nonatomic) NSString *endpoint;
@property(strong,nonatomic) NSDictionary *dic;
@property (nonatomic) BOOL isFetchPermissions;
@end

@implementation SelectFamilyMemberViewController
@synthesize userCollectionView;
@synthesize collectionOne;

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    stringPublicData = [[NSMutableString alloc] initWithString:@""];

    selectedIndex=-1;
    family=[NSArray arrayWithObjects:@"Worried Wendy",@"Problem Peter",@"Tricky Troy",@"Sports Susan", nil];
    family_subtitle=[NSArray arrayWithObjects:@"Mother",@"Father",@"Brother",@"Sister", nil];
    imgFamilyArray=[[NSArray alloc]initWithObjects:@"Mother",@"Father",@"Brother",@"Sister", nil];
    [self showBusyActivityView];
    [self fetchPermissions];
   // [self.userCollectionView registerNib:[UINib nibWithNibName:@"TestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"test"];
    //[self.userCollectionView registerNib:[UINib nibWithNibName:@"TestCollectionViewCell_Ipad" bundle:nil] forCellWithReuseIdentifier:@"test_ipad"];
    [self.userCollectionView registerNib:[UINib nibWithNibName:@"DocCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Doc"];
   // [self.userCollectionView registerNib:[UINib nibWithNibName:@"DocCollectionViewCell_Ipad" bundle:nil] forCellWithReuseIdentifier:@"Doc_ipad"];

    //collectionTwoIndex = 0;
    /*CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = 1.0 / -300;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        perspectiveTransform.m34 = 1.0 / -600;
    }
    self.collectionOne.layer.transform =
    CATransform3DRotate(perspectiveTransform, (22.5 * M_PI / 180), 0.0f, 1.5f, 0.0f);
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        perspectiveTransform.m34 = 1.0 / -300;
    }
    
    self.userCollectionView.layer.transform =
    CATransform3DRotate(perspectiveTransform, (5.5 * M_PI / 180), 0.0f, -0.2f, 0.0f);
    // 5.5 , -0.2
    perspectiveTransform.m34 = 1.0 / -1500;

    collectionTwoIndex = 0;*/
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = 1.0 / -100;
    self.userCollectionView.layer.transform =
    CATransform3DRotate(perspectiveTransform, (4 * M_PI / 180), 0.0f, -0.1f, 0.0f);
    // 5.5 , -0.2
    self.userCollectionView.backgroundColor=[UIColor clearColor];
    [self.userCollectionView reloadData];
}

- (IBAction)becomeFriendTapped:(id)sender {
    DebugLog(@"");
    //[UIPasteboard generalPasteboard].string = [[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"];
    [UIPasteboard generalPasteboard].string = stringPublicData;

}
- (IBAction)inviteFriendTapped:(id)sender {
    DebugLog(@"");
    [self performSegueWithIdentifier:@"SelectFamilyMemberToAddCSIVIew" sender:self];
}

-(void)fetchPermissions
{
    DebugLog(@"");
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
//    [array2 addObject:[NSString stringWithFormat:@"%@%@%@",Permission_Base_URL,_endpoint,request_dic]];
    //    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"PermissionsLogArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [debugView setHidden:true];
    [h createSessionforPermissionEndPoint:_endpoint withModelDictionary:request_dic];
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

- (void)fetchPublicClaims
{
    DebugLog(@"");
//    _isFetchPublicClaims = YES;
    _isFetchPermissions = NO;
    APIhandler *h=[[APIhandler alloc]init];
    h.delegate = self;
    _endpoint=@"fetchPublicClaims";
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    time_t currentTime = [[ServerSingleton sharedServerSingleton]time];
    
    NSString *currentDate  = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    NSString *deviceId = [[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"];
    NSString *guid = [[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"];
    
    NSString *desiredGuid;
    if([serverCsiArray count] > 0)
    {
       desiredGuid = [serverCsiArray objectAtIndex:0];
        if(desiredGuid.length == 0)
        {
            desiredGuid = [[NSUserDefaults standardUserDefaults]valueForKey:@"wcsi"];
        }
    }
    else if(desiredGuid.length == 0)
    {
        desiredGuid = [[NSUserDefaults standardUserDefaults]valueForKey:@"wcsi"];

    }
    
    NSString *nonce = [self genRandStringLength:36];
    
    //    [self generateKeys];
    
    NSString *payload=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@",@"|",@"ecdsa",@"|",guid,@"|",currentDate,@"|",desiredGuid,@"|",nonce,@"|"];
    payload=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"|",desiredGuid,@"|",currentDate,@"|",nonce,@"|"];
    NSLog(@"%@", payload);
    NSData * dataForSignature = [payload dataUsingEncoding:NSUTF8StringEncoding];
    // Creation of Signature
    NSData *signature=[self createSignature:dataForSignature withKey:privateKey];
    NSString *signatureString = [signature base64EncodedStringWithOptions:0];
    
    NSLog(@"current Date :%@ ",currentDate);
    NSLog(@"device id:%@",deviceId);
    NSLog(@"%@",guid);
    NSLog(@"%@", nonce);
    
    
    
    request_dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"ecdsa",@"cipher",currentDate,@"dateTime",guid,@"csiGuid",nonce,@"nonce",signatureString,@"signature",desiredGuid,@"desiredCsiGuid" ,nil];
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@%@%@",CSI_Base_URL,_endpoint,request_dic]];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    [h createSessionforCSIEndPoint:_endpoint withModelDictionary:request_dic];
    
#if ISDEBUG
    
#if ISENDSCREEN
    //    NSLog(@"in end screen debug mode");
    //    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
    //    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    //    [array2 addObject:[NSString stringWithFormat:@"%@%@%@",CSI_Base_URL,_endpoint,request_dic]];
    //    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    //    [_debugView setHidden:true];
    //    [_debugView1 setHidden:true];
    //    [h createSessionforCSIEndPoint:_endpoint withModelDictionary:request_dic];
    //    _activityContainerView.hidden = false;
    //
    //    [_activityIndicator startAnimating];
#else
    //    [_debugView setHidden:true];
    //    [_debugContainerView setHidden:true];
    //    [_debugView1 setHidden:false];
    //    _debugView1.contentSize = CGSizeMake(398, 512);
    //    [_activityContainerView setHidden:false];
    //    // [_debugContainerView setHidden:false];
    //    [_requestLabel1 setText:[NSString stringWithFormat:@"%@%@ Model Dictionary %@",CSI_Base_URL,_endpoint,request_dic]];
    //
    //    _activityViewCenterConstraint.constant=-200.0;
    //    [_activityIndicator startAnimating];
#endif
    
#else
    NSLog(@"not in debug mode");
    //    [_debugView setHidden:true];
    //    [_debugView1 setHidden:true];
    //    [h createSessionforCSIEndPoint:_endpoint withModelDictionary:request_dic];
    //    _activityContainerView.hidden = false;
    //
    //    [_activityIndicator startAnimating];
    //[_debugContainerView setHidden:true];
#endif
    
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

- (void)didReceiveMemoryWarning {
    DebugLog(@"");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)closeButtonTapped
{
    DebugLog(@"");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([serverCsiArray count] > 4)
    {
        return 4;
    }
    else
    {
        return [serverCsiArray count];
    }
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"Cell";
   SelectFamilyMemberTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.titleLabel.text=[family objectAtIndex:indexPath.row];
    cell.subtitleLabel.text=[family_subtitle objectAtIndex:indexPath.row];
    UIImage *image1=[UIImage imageNamed:[imgFamilyArray objectAtIndex:indexPath.row]];
    cell.image.image=image1;
    if(selectedIndex==-1 && indexPath.row==0)
    {
        cell.radioImage.image=[UIImage imageNamed:@"radio_btn"];
        return cell;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    selectedIndex=(int)indexPath.row;
    [tableView reloadData];
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:selectedIndex] forKey:@"Selected_Index"];
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:YES] forKey:@"isCaregiver"];
    [self performSegueWithIdentifier:@"CaregiverSegue" sender:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *viewArray=[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil];
    HeaderView *view=(HeaderView *)[viewArray objectAtIndex:0];
    view.delegate = self;
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
    _dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    
    if(_isFetchPermissions)
    {
        NSArray *permissions = [_dic valueForKey:@"permissions"];
        serverCsiArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in permissions) {
            NSArray * permissionCsiArray = [dict objectForKey:@"permissionedCsiGuids"];
            NSString * grantingCSI = [dict objectForKey:@"grantingCsiGuid"];
            [serverCsiArray addObject:grantingCSI];
        }
        [self fetchPublicClaims];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_selectFamilyMemberTableView reloadData];
            
        });
       
    }
    else
    {
        //success of fetch public claims
        NSArray *dataArray=[_dic objectForKey:@"claims"];
        [stringPublicData appendString:[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:1] objectForKey:@"value"]]];
        [stringPublicData appendString:[NSString stringWithFormat:@"%@%@",COMPONENTS_SEPERATED_STRING,[[dataArray objectAtIndex:3] objectForKey:@"value"]]];
        [stringPublicData appendString:[NSString stringWithFormat:@"%@%@",COMPONENTS_SEPERATED_STRING,[[dataArray objectAtIndex:4] objectForKey:@"value"]]];
        [stringPublicData appendString:[NSString stringWithFormat:@"%@%@",COMPONENTS_SEPERATED_STRING,[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"]]];
        dispatch_async(dispatch_get_main_queue(), ^{
        [self hideBusyActivityView];
 });
    }
    
//
//        //    serverCsiArray = [permissionsDictionary objectForKey:@"permissionedCsiGuids"];
//        //    if([serverCsiArray count] != [_permissionsArray count] + [_permissionsFamilyArray count])
//        //    {
//        for (NSString * csi in serverCsiArray) {
//            for (NSString *permissionCsi in csiArray) {
//                if([csi isEqualToString:permissionCsi])
//                {
//                    [indexArray addObject:[NSString stringWithFormat:@"%d", (int)[csiArray indexOfObject:permissionCsi]]];
//                }
//            }
//        }
//        for (NSString * csi in serverCsiArray) {
//            for (NSString *permissionCsi in csiFamilyArray) {
//                if([csi isEqualToString:permissionCsi])
//                {
//                    [indexFamilyArray addObject:[NSString stringWithFormat:@"%d", (int)[csiFamilyArray indexOfObject:permissionCsi]]];
//                }
//            }
//        }
//
//        if([NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"]] != nil)
//        {
//            _permissionsArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"]];
//        }
//        else
//        {
//            _permissionsArray = [[NSMutableArray alloc]init];
//        }
//        if([NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"]] != nil)
//        {
//            _permissionsFamilyArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"]];
//        }
//        else
//        {
//            _permissionsFamilyArray = [[NSMutableArray alloc]init];
//        }
//        NSMutableArray * permissionArrayCopy = [_permissionsArray copy];
//        NSMutableArray * permissionFamilyArrayCopy = [_permissionsFamilyArray copy];
//
//        for (PermissionData *permData in permissionArrayCopy) {
//            BOOL isPresent = NO;
//            for (NSString *index in indexArray) {
//                if([index intValue] == permData.index)
//                {
//                    isPresent = YES;
//                    break;
//                }
//            }
//            if(!isPresent)
//            {
//                [_permissionsArray removeObject:permData];
//            }
//        }
//        for (PermissionData *permData in permissionFamilyArrayCopy) {
//            BOOL isPresent = NO;
//            for (NSString *index in indexFamilyArray) {
//                if([index intValue] == permData.index)
//                {
//                    isPresent = YES;
//                    break;
//                }
//            }
//            if(!isPresent)
//            {
//                [_permissionsFamilyArray removeObject:permData];
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_doctorFamilyTableView reloadData];
//            [_doctorFamilySegmentedControl setTitle:[NSString stringWithFormat:@"Providers - (0%lu)",(unsigned long)[_permissionsArray count]] forSegmentAtIndex:0];
//            [_doctorFamilySegmentedControl setTitle:[NSString stringWithFormat:@"Caregivers - (0%lu)",(unsigned long)[_permissionsFamilyArray count]] forSegmentAtIndex:1];
//        });
//    }
//    else
//    {
//        [self fetchPermissions];
//    }
    //    }
    
    //    if(!_isThirdCall)
    //    {
    //        _guidDictionary = _dic;
    //    }
#if ISDEBUG
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"PermissionsLogArray"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@",_dic]];
    //[[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
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
    if(jsonError)
    {
        //        [NSException raise:@"Exception in parsing JSON data" format:@"%@",jsonError.localizedDescription];
    }
    
    
    
    //    _resultsArray=[[NSArray alloc]initWithArray:[dic objectForKey:@"companies"]];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DebugLog(@"");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SelectFamilyToAddCSI"])
    {
        AddCSIViewController *addCSIViewController = segue.destinationViewController;
        addCSIViewController.strFromScreen=@"CaregiverFlow";
        
    }
}
#pragma mark -
#pragma mark ==============================
#pragma mark Collection View Delegates
#pragma mark ==============================
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([[UIScreen mainScreen] bounds].size.height == 568.0)
    {
        return UIEdgeInsetsMake(12,15,0,15);
    }
    else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        return UIEdgeInsetsMake(10, 60, 10, 60);
    }
    else{
        return UIEdgeInsetsMake(-30, 60, 0, 60);
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        DocCollectionViewCell_Ipad *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Doc" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor whiteColor];
        cell.docName.textColor = [UIColor colorWithRed:78.0f/255 green:88.0f/255 blue:90.0f/255 alpha:1.0f];
        cell.docType.textColor = [UIColor colorWithRed:121.0f/255 green:131.0f/255 blue:133.0f/255 alpha:1.0f];
        cell.docImg.image=[UIImage imageNamed:@"Doc1.png"];
        cell.docName.text =@"Worried wendy";
        cell.docType.text =@"Cardio";
        cell.docName.numberOfLines = 2;
        cell.alpha=0.5;
        
        cell.backgroundColor=[UIColor redColor];
        cell.layer.shadowOpacity = 0;
        cell.layer.shadowRadius = 0.0;
        
        if(indexPath.row==collectionTwoIndex)
        {
            cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            cell.layer.shadowOffset = CGSizeMake(5,5);
            cell.layer.shadowOpacity = 1;
            cell.layer.shadowRadius = 5.0;
            cell.clipsToBounds = false;
            cell.layer.masksToBounds = false;
        }
        return cell;
    }
    else
    {
        
        DocCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Doc" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor whiteColor];
        cell.docName.textColor = [UIColor colorWithRed:78.0f/255 green:88.0f/255 blue:90.0f/255 alpha:1.0f];
        cell.docType.textColor = [UIColor colorWithRed:121.0f/255 green:131.0f/255 blue:133.0f/255 alpha:1.0f];
        cell.docImg.image=[UIImage imageNamed:@"Doc1.png"];
        cell.docName.text =@"Worried wendy";
        cell.docType.text =@"Cardio";
        cell.docName.numberOfLines = 2;
        cell.alpha=0.5;
        
        cell.backgroundColor=[UIColor redColor];
        cell.layer.shadowOpacity = 0;
        cell.layer.shadowRadius = 0.0;
        
        if(indexPath.row==collectionTwoIndex)
        {
            cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            cell.layer.shadowOffset = CGSizeMake(5,5);
            cell.layer.shadowOpacity = 1;
            cell.layer.shadowRadius = 5.0;
            cell.clipsToBounds = false;
            cell.layer.masksToBounds = false;
        }
        return cell;
    }
    return nil;
}
-(void)selectCenterCell{
    DebugLog(@"");
    NSIndexPath *indexPath;
    if([[self.userCollectionView visibleCells] count] == 0)
    {
        return;
    }
    UICollectionViewCell *closestCell = [self.userCollectionView visibleCells][0];
    for (UICollectionViewCell *cell in [self.userCollectionView visibleCells]) {
        
        int closestCellDelta = fabs(closestCell.center.x - self.userCollectionView.bounds.size.width/2.0 - self.userCollectionView.contentOffset.x);
        int cellDelta = fabs(cell.center.x - self.userCollectionView.bounds.size.width/2.0 - self.userCollectionView.contentOffset.x);
        if (cellDelta < closestCellDelta){
            closestCell = cell;
        }
        
        indexPath = [self.userCollectionView indexPathForCell:closestCell];
        NSLog(@"%@",indexPath);
    }
    collectionTwoIndex=(int)indexPath.row;
    // [self.collectionOne reloadData];
    [self.userCollectionView reloadData];
    [self.userCollectionView layoutIfNeeded]; // imp line
    // [self.collectionOne scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    [self.userCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
#pragma mark -
#pragma mark ==============================
#pragma mark Activity Indicator methods
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
