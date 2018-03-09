//
//  ViewController.m
//  MHealthApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "PermissionController.h"
#import "CMPopTipView.h"
#import "PermissionSummaryViewController.h"
#import "APIhandler.h"
#import "Constants.h"
#import "mHealthDApp-Swift.h"
#import "UICKeyChainStore.h"

@interface PermissionController ()
{
    NSArray *titles;
    NSArray *subtitles;
    APIhandler *h;
    SecKeyAlgorithm algorithm;
    NSString * derKeyString;
    SecKeyRef privateKey;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    NSDictionary *modelDictionary;
    NSString * urlEncodedString;
}
@property (weak, nonatomic) IBOutlet UIView *activityContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityViewCenterConstraint;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel;
@property (weak, nonatomic) IBOutlet UIView *responseView;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *debugView;
@property(nonatomic) NSString *endpoint;
@end

@implementation PermissionController
- (IBAction)showPopover:(id)sender {
     DebugLog(@"");
        UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
    NSString *contentMessage=@"Permission for the below 3 resources (condition,device and observation) will be shared by default.You can choose the optional resource whether to share or not.";
    CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
    popTipView.dismissAlongWithUserInteraction = YES;
    popTipView.backgroundColor=[UIColor colorWithRed:212.0/255.0 green:236.0/255.0 blue:246.0/255.0 alpha:1];
    popTipView.textColor=[UIColor colorWithRed:39.0/255.0 green:108.0/255.0 blue:149.0/255.0 alpha:1];
    popTipView.borderColor=[UIColor clearColor];
    popTipView.borderWidth=0.0;
    popTipView.hasGradientBackground=NO;
    popTipView.textFont=[UIFont fontWithName:@"Avenir Next" size:12.0];
    popTipView.textAlignment = NSTextAlignmentLeft;
    popTipView.has3DStyle=NO;
    popTipView.cornerRadius=0.0;
  if([[UIScreen mainScreen] bounds].size.height == 667.0)
   {
       popTipView.maxWidth=300.0;
   }
  else{
    popTipView.maxWidth=350.0;
  }
    popTipView.shouldEnforceCustomViewPadding=YES;
   popTipView.bubblePaddingY=20.0;
   popTipView.bubblePaddingX=10.0;
    popTipView.sidePadding=28.0;
 
        [popTipView presentPointingAtBarButtonItem:barButtonItem animated:NO];
}

- (IBAction)checkBtnClicked:(id)sender {
     DebugLog(@"");
    UIButton *btn=(UIButton *)sender;
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"checkBtn"])
    {
        [btn setImage:[UIImage imageNamed:@"default_check"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"checkBtn"];}
    else{
        [btn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"checkBtn"];
        
    }
}
    
    



- (void)viewDidLoad {
     DebugLog(@"");
    [super viewDidLoad];
    [_backBtn setTitleColor:[UIColor colorWithRed:80.0/255.0 green:205.0/255.0 blue:224.0/255.0 alpha:1] forState:UIControlStateNormal];
    _backBtn.layer.borderColor = [UIColor colorWithRed:80.0/255.0 green:205.0/255.0 blue:224.0/255.0 alpha:1].CGColor;
    _backBtn.layer.cornerRadius=5.0;
    _backBtn.layer.borderWidth=1.0;
    _acceptBtn.backgroundColor=[UIColor colorWithRed:80.0/255.0 green:205.0/255.0 blue:224.0/255.0 alpha:1];
    _acceptBtn.layer.cornerRadius=5.0;
    titles=[NSArray arrayWithObjects:@"Condition",@"Device",@"Observations",@"Optional Resource", nil];
    subtitles=[NSArray arrayWithObjects:@"This resource represents your condition of an illness i.e. if the illness is in active or deactive state.",@"This resource will have information about tests done from various medical devices/instruments.",@"This resource will have detail information and observation about various test results",
               @"Lorem ipsum dolor sit amet, consectetur adipiscing elit,sed do eiusmod tempor.",nil];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:128.0/255.0 alpha:1];
    _viewForButtons.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    _viewForButtons.layer.shadowOffset=CGSizeMake(0.0f, 0.0f);
    _viewForButtons.layer.shadowRadius=4.5f;
    _viewForButtons.layer.shadowOpacity=0.9f;
    _viewForButtons.layer.masksToBounds=NO;
    UIEdgeInsets shadowInset=UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath=[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_viewForButtons.bounds, shadowInset)];
    _viewForButtons.layer.shadowPath=shadowPath.CGPath;
   // self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.topItem.title = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:@"dpermissionsharedNotification" object:nil];

//  _tableView.separatorColor=[UIColor clearColor] ;
    
//    UIBarButtonItem *_btn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"info"]
//                                                          style:UIBarButtonItemStylePlain
//                                                         target:self
//                                                         action:@selector(showPopover)];
   // UIBarButtonItem *_btn2=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Image"]
                                                      //    style:UIBarButtonItemStylePlain
                                                     //    target:self
                                                       //  action:@selector(showPopover)];
    
//    self.navigationItem.rightBarButtonItem=_btn;
   
}

- (void)appWillEnterForeground:(NSNotification *)notification {
     DebugLog(@"");
    NSLog(@"will enter foreground notification");
    
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"dpermissionshared"] == nil)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                       message:@"You need to go to CSA for granting permissions."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              }];
        
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
//        [[NSNotificationCenter defaultCenter] removeObserver:self];
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"GrantPermissionSegue" sender:self];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
     DebugLog(@"");
    [super viewWillAppear: animated];
    self.navigationItem.title = @"Permission Resources";
}
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
    cell.cell_title.text=[titles objectAtIndex:indexPath.row];
    cell.cell_subtitle.text=[subtitles objectAtIndex:indexPath.row];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backbuttonPressed:(id)sender {
     DebugLog(@"");
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    PermissionSummaryViewController * summaryController = [segue destinationViewController];
//    summaryController.permissionsArray = _permissionsArray;
//    summaryController.permissionsFamilyArray = _permissionsFamilyArray;
//}
- (IBAction)acceptButtonTapped:(id)sender {
     DebugLog(@"");
//    h=[[APIhandler alloc]init];
//    h.delegate = self;
//    _endpoint=@"";
//
////    NSMutableArray *array=[[NSMutableArray alloc]init];
////
//    double epochSeconds = [[NSDate date] timeIntervalSince1970];
//    double expireTimeInSecondsSinceEpoch = epochSeconds + AUTHORIZATION_TOKEN_LIFESPAN_IN_SECONDS;
//
//    NSString * bodyString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%d%@%@%@%d%@%@%@%@%@%@%@%@%@%@%@%@%@",@"{\"iss\"",@":\"",(NSString *)[_dic valueForKey:@"guid"],@"\",",@"\"sub\"",@":\"",(NSString *)[_dic valueForKey:@"guid"],@"\",",@"\"aud\"",@":\"",Auth_Base_URL,@"\",",@"\"iat\"",@":\"",(int)epochSeconds,@"\",",@"\"exp\"",@":\"",(int)expireTimeInSecondsSinceEpoch,@"\",",@"\"jti\"",@":\"",[UICKeyChainStore stringForKey:@"UniqueIdentifier" service:@"MyService"],@"\",",@"\"scope\"",@":\"",@"patient/Patient.read sens/ETH sens/SOC conf/V",@"\",",@"\"sta\"",@":\"",[UICKeyChainStore stringForKey:@"UniqueIdentifier" service:@"MyService"],@"\"}"];
////    NSString *bodyString = @"{\"iss\":\"b8565047-08d8-4293-b81e-ec2e9d37db8e\",\"sub\":\"b8565047-08d8-4293-b81e-ec2e9d37db8e\",\"aud\":\"http://smoac.fhirblocks.io:8080/vaca/auth\",\"iat\":\"1513148732\",\"exp\":\"1513149032\",\"jti\":\"65073A24-A6B4-4FF6-93CA-5C8DCC857862\",\"scope\":\"patient/Patient.read sens/ETH sens/SOC conf/V\",\"sta\":\"65073A24-A6B4-4FF6-93CA-5C8DCC857862\"}";
//    NSDictionary *arraydata1=[[NSDictionary alloc]initWithObjectsAndKeys:(NSString *)[_dic valueForKey:@"guid"],@"iss",(NSString *)[_dic valueForKey:@"guid"],@"sub" ,Auth_Base_URL,@"aud",[NSString stringWithFormat:@"%d",(int)epochSeconds],@"iat",[NSString stringWithFormat:@"%d",(int)expireTimeInSecondsSinceEpoch],@"exp",[UICKeyChainStore stringForKey:@"UniqueIdentifier" service:@"MyService"],@"jti",@"patient/Patient.read sens/ETH sens/SOC conf/V",@"scope",[UICKeyChainStore stringForKey:@"UniqueIdentifier" service:@"MyService"],@"sta",nil];
//    NSString *bodyDictString = [NSString stringWithFormat:@"%@",arraydata1];
//    NSString * headerString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"{\"alg\"",@":\"",@"ES256",@"\",",@"\"typ\"",@":\"",@"jwt",@"\"}"];
//    NSDictionary *arraydata2=[[NSDictionary alloc]initWithObjectsAndKeys:@"ES256",@"alg",@"jwt",@"typ",nil];
//    NSString *headerDictString = [NSString stringWithFormat:@"%@",arraydata2];
//    [self generateKeys];
//
//    NSData * dataForSignature = [bodyString dataUsingEncoding:NSDataBase64Encoding64CharacterLineLength];
//    NSString * bodyEncodedString = [dataForSignature base64EncodedStringWithOptions:0];
//    // Creation of Signature
//    NSData *signature=[self createSignature:dataForSignature withKey:privateKey];
//    NSString *signatureString = [signature base64EncodedStringWithOptions:0];
////    NSString *signatureString = @"MEUCIQDdKOEMmkGbb2wYslMM4IR29oQPcCaPJYJ5LvnFI6LC4AIgMMAXDO92Ai4wYVl8YEL7HveknY+rYRrMhRbTuQQkxkQ=";
//
//    NSData * headerData = [headerString dataUsingEncoding:NSDataBase64Encoding64CharacterLineLength];
//    NSString * headerEncodedString = [headerData base64EncodedStringWithOptions:0];
//
//    NSString * finalAssembly = [NSString stringWithFormat:@"%@.%@.%@",headerEncodedString,bodyEncodedString,signatureString];
//    modelDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:@"authorization_code",@"grant_type",@"urn:ietf:params:oauth:client-assertion-type:jwt-bearer",@"assertion_type",finalAssembly,@"assertion", nil];
//    urlEncodedString = [NSString stringWithFormat:@"%@%@",@"grant_type=authorization_code&assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer&assertion=",finalAssembly];
//#if ISDEBUG
//
//#if ISENDSCREEN
//    NSLog(@"in end screen debug mode");
//    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
//    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
//    [array2 addObject:[NSString stringWithFormat:@"%@%@%@%@\n\nBody Encoded String: %@\n\nHeader Encoded String: \n%@\n\nSignature String: \n%@\n\nURL Encoded String:\n%@",Auth_Base_URL,_endpoint,headerString,bodyString,bodyEncodedString,headerEncodedString,signatureString,urlEncodedString]];
//    [array2 addObject:[NSString stringWithFormat:@"%@",signatureString]
//     ];
//    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
//    [_debugView setHidden:true];
//    [h createSessionforAuthEndPoint:_endpoint withURLEncodedString:urlEncodedString];
//   // [h createSessionforAuthEndPoint:_endpoint withModelDictionary:modelDictionary];
//    _activityContainerView.hidden = false;
//
//    [activityIndicator startAnimating];
//#else
//    [_debugView setHidden:false];
//    _debugView.contentSize = CGSizeMake(398, 512);
//    [_activityContainerView setHidden:false];
//    // [_debugContainerView setHidden:false];
//    [_requestLabel setText:[NSString stringWithFormat:@"%@%@%@%@%@",Auth_Base_URL,_endpoint,headerDictString,bodyDictString,urlEncodedString]];
//
//    _activityViewCenterConstraint.constant=-200.0;
//    [activityIndicator startAnimating];
//#endif
//
//#else
//    NSLog(@"not in debug mode");
//    [_debugView setHidden:true];
//    [h createSessionforAuthEndPoint:_endpoint withURLEncodedString:urlEncodedString];
//    _activityContainerView.hidden = false;
//
//    [activityIndicator startAnimating];
//    //[_debugContainerView setHidden:true];
//#endif
///Users/dhaval.tannarana/Desktop/AAII doc/Keys
//
    
//    [UICKeyChainStore setString:[UICKeyChainStore stringForKey:@"dcsi" service:@"MyService"] forKey:@"dSharedPermissions" service:@"MyService"];
    if([[NSUserDefaults standardUserDefaults]valueForKey:@"dpermissionshared"] == nil)
    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message"
//                                                                   message:@"You need to go to CSA for granting permissions."
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
//                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSString *fBlocksCSA;
        if(self.isFromViewGrantedPermission == YES) {
            fBlocksCSA=[NSString stringWithFormat:@"FBlocksCSA://?dcsi=%@&screen2=yes",[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"]];
        } else {
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"checkBtn"] != nil && [[NSUserDefaults standardUserDefaults]boolForKey:@"checkBtn"] == YES) {
                fBlocksCSA=[NSString stringWithFormat:@"FBlocksCSA://?dcsi=%@&isSelected=yes",[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"]];
            } else {
                fBlocksCSA=[NSString stringWithFormat:@"FBlocksCSA://?dcsi=%@&isSelected=no",[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"]];
            }
        }
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:fBlocksCSA] options:@{} completionHandler:nil];
//                                                          }];
//    
//    
//        [alert addAction:firstAction];
//        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self performSegueWithIdentifier:@"GrantPermissionSegue" sender:self];
    }

}

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

-(NSData*)createSignature:(NSData*)data2sign withKey:(SecKeyRef)privateKey
{
     DebugLog(@"");
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
        NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
        NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
        [array2 addObject:[NSString stringWithFormat:@"error: %@",error.localizedDescription]];
        [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_debugView setHidden:true];
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
//    if(!_isThirdCall)
//    {
//        _guidDictionary = _dic;
//    }
#if ISDEBUG
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@",_dic]];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_debugView setHidden:true];
        [activityIndicator stopAnimating];
        [self performSegueWithIdentifier:@"PermissionSummarySegue" sender:self];
        //[_debugContainerView setHidden:true];
    });
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
        [self performSegueWithIdentifier:@"PermissionSummarySegue" sender:self];
        //[_debugContainerView setHidden:true];
    });
    
    
#endif
    if(jsonError)
    {
//        [NSException raise:@"Exception in parsing JSON data" format:@"%@",jsonError.localizedDescription];
    }
    
    
    
    //    _resultsArray=[[NSArray alloc]initWithArray:[dic objectForKey:@"companies"]];
    
    
}
- (IBAction)requestOkButtonPressed:(id)sender {
     DebugLog(@"");
    [h createSessionforAuthEndPoint:_endpoint withURLEncodedString:urlEncodedString];
    _activityContainerView.hidden = false;
    
    [activityIndicator startAnimating];
}
- (IBAction)responseOkButtonPressed:(id)sender {
    DebugLog(@"");
    [self performSegueWithIdentifier:@"PermissionSummarySegue" sender:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
