 //
//  FirstViewController.m
//  MHealthApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "FirstViewController.h"
#import "PermissionController.h"
//#import "APIhandler.h"
#import "Constants.h"
#import "mHealthDApp-Swift.h"
#import "ViewController.h"
#import "UICKeyChainStore.h"
#import "ServerSingleton.h"
#import "DejalActivityView.h"


@interface FirstViewController ()
{
    NSMutableArray *arrayOfButtons;
    Usertype type;
    BOOL isPatient;
    BOOL isCaregiver;
    BOOL isBoth;
    SecKeyAlgorithm algorithm;
    NSString * derKeyString;
    SecKeyRef privateKey;
    NSDictionary *request_dic;
    mHealthApiHandler *apiHandler;
}
@property(strong,nonatomic) NSDictionary *guidDictionary;
@property (weak, nonatomic) IBOutlet UIView *debugContainerView;
@property (weak, nonatomic) IBOutlet UIView *debugView;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *debugView1;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityViewCenterConstraint;
@property (weak, nonatomic) IBOutlet UIView *activityContainerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *responseView;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel1;
@property(nonatomic) NSString *endpoint;
@property (nonatomic) BOOL isThirdCall;
@property (nonatomic) BOOL isFetchPublicClaims;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    arrayOfButtons=[NSMutableArray arrayWithObjects:_patient_Btn,_caregiver_Btn,_bothButton,nil];
    [_patient_Btn setTag:1];
    [_caregiver_Btn setTag:2];
    [_bothButton setTag:3];
    // Do any additional setup after loading the view.
    _patient_Btn.layer.cornerRadius=30.0;
    _caregiver_Btn.layer.cornerRadius=30.0;
    _bothButton.layer.cornerRadius=30.0;
    _next.layer.cornerRadius=8.0;
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"PermissionArray"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"PermissionFamilyArray"];
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:0] forKey:@"Selected_Index"];
    [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:NO] forKey:@"isCaregiver"];
     [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"checkBtn"];
    if(isPatient == false || isCaregiver == false || isBoth == false)
    {
        _next.userInteractionEnabled = NO;
        [_next setBackgroundColor:[UIColor lightGrayColor]];
    }
//    #if ISDEBUG
//    #if ISENDSCREEN
//        [self performSelector:@selector(secondCall) withObject:nil afterDelay:0];
//    #else
//        [self performSelector:@selector(secondCall) withObject:nil afterDelay:0];
//    #endif
//    # else
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"apppermissionshared"] == nil)
    {
        [self performSelector:@selector(secondCall) withObject:nil afterDelay:0];

    }
    
    
//    #endif
}

- (void)didReceiveMemoryWarning {
    DebugLog(@"");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//#if ISDEBUG
//
//
//#if ISENDSCREEN
//NSLog(@"in end screen debug mode");
//[_debugView setHidden:true];
//[_debugContainerView setHidden:true];
//
//NSMutableArray * array = [[NSMutableArray alloc]init];
//[array addObject:[NSString stringWithFormat:@"%@%@",Base_URL,_endpoint]];
//[[NSUserDefaults standardUserDefaults]setObject:array forKey:@"LogArray"];
//
//#else
//NSLog(@"not in end screen debug mode");
//[_debugView setHidden:false];
//[_debugContainerView setHidden:false];
//[_requestLabel setText:[NSString stringWithFormat:@"%@%@",Base_URL,_endpoint]];
//#endif
//
//#else
//NSLog(@"not in debug mode");
//[_debugView setHidden:true];
//[_debugContainerView setHidden:true];
//#endif
-(void)secondCall
{
    DebugLog(@"");
    
//    _isSecondCall=YES;
    [self showBusyActivityView];
    //APIhandler *h=[[APIhandler alloc]init];
    //h.delegate = self;
    
    mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc]init];
    apiHandler.delegate = self;
    
    _endpoint=@"getGloballyUniqueIdentifier";
#if ISDEBUG
    
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    [_debugView setHidden:true];
    [_debugContainerView setHidden:true];
    NSMutableArray * array = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
    NSMutableArray * array1 = [NSMutableArray arrayWithArray:array];
    [array1 addObject:[NSString stringWithFormat:@"%@%@",Base_URL,_endpoint]];
    [[NSUserDefaults standardUserDefaults]setObject:array1 forKey:@"LogArray"];
    
#else
    
    NSLog(@"not in end screen debug mode");
    [_debugView setHidden:false];
    [_debugContainerView setHidden:false];
    [_requestLabel setText:[NSString stringWithFormat:@"%@%@",Base_URL,_endpoint]];
    
#endif
#else
    NSLog(@"not in debug mode");
    [_debugView setHidden:true];
    [_debugContainerView setHidden:true];
#endif
    
   // [h createSessionWithEndPoint:_endpoint];
    [apiHandler createSessionWithEndPoint:_endpoint];
}


- (IBAction)nextBtnCicked:(UIButton *)sender {
    DebugLog(@"");
    if(isPatient == true || isCaregiver == true || isBoth == true)
    {
        if(type==UsertypePatient||type==UsertypeBoth)
        {
            //        UINavigationController *navigation=[[UINavigationController alloc]init];
            //        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //        PermissionController *controller=[storyboard instantiateViewControllerWithIdentifier:@"PermissionController"];
            [[NSUserDefaults standardUserDefaults]setObject:@"Patient" forKey:@"Flow"];
            [self performSegueWithIdentifier:@"PermissionSegue" sender:self];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"Caregiver" forKey:@"Flow"];
            //[self performSegueWithIdentifier:@"SelectFamilySegue" sender:nil];
            [self performSegueWithIdentifier:@"FirstViewtoNavigation" sender:self];
        }
    }
    
}

- (IBAction)patientButtonClicked:(UIButton *)sender {
    DebugLog(@"");
  type=UsertypePatient;
  [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"apppermissionshared"];

   
    for (UIButton* button in arrayOfButtons)
    {
        sender.selected = true;
        isPatient = true;
        _next.userInteractionEnabled = YES;
        [_next setBackgroundColor:[UIColor colorWithRed:59.0/255.0 green:216.0/255.0 blue:226.0/255.0 alpha:1.0]];
        if (button != sender)
        {
            [button setSelected: FALSE];
            [button setBackgroundColor:[UIColor whiteColor]];
            if(button.tag==1)
            {
                [button setTitle:@"I am Patient" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:158.0/255.0 alpha:1 ]forState:UIControlStateNormal];
            }
            else if(button.tag==2)
            {
                [button setTitle:@"I am Caregiver" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:158.0/255.0 alpha:1 ]forState:UIControlStateNormal];
            }
            else{
                
                [button setTitle:@"Both" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:158.0/255.0 alpha:1 ]forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor lightGrayColor]];
            }
        }
    }
    
  
    if (sender.selected == TRUE) {
        [sender setSelected:FALSE];
        [self.redcheck setHidden:NO];
        sender.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:76.0/255.0 blue:122.0/255.0 alpha:1];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if (sender.selected == FALSE) {
        [sender setSelected:TRUE];
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
   }

- (IBAction)caregiverButtonClicked:(UIButton *)sender {
    DebugLog(@"");
    type=UsertypeCareGiver;
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"apppermissionshared"];

    for (UIButton* button in arrayOfButtons)
    {
          sender.selected = true;
        isCaregiver=true;
        _next.userInteractionEnabled = YES;
        [_next setBackgroundColor:[UIColor colorWithRed:59.0/255.0 green:216.0/255.0 blue:226.0/255.0 alpha:1.0]];
        if (button != sender)
        {
            [button setSelected: FALSE];
            [button setBackgroundColor:[UIColor whiteColor]];
            if(button.tag==1)
            {
                [button setTitle:@"I am Patient" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:158.0/255.0 alpha:1 ]forState:UIControlStateNormal];
            }
            else if(button.tag==2)
            {
                [button setTitle:@"I am Caregiver" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:158.0/255.0 alpha:1 ]forState:UIControlStateNormal];
            }
            else{
                
                [button setTitle:@"Both" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:158.0/255.0 alpha:1 ]forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor lightGrayColor]];
            }
        }
    }
    
 
    
    if (sender.selected == TRUE) {
        [sender setSelected:FALSE];
        [self.redcheck2 setHidden:NO];
        sender.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:76.0/255.0 blue:122.0/255.0 alpha:1];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if (sender.selected == FALSE) {
        [sender setSelected:TRUE];
        [sender setBackgroundColor:[UIColor whiteColor]];
    }

}

- (IBAction)bothButtonClicked:(id)sender {
    DebugLog(@"");
  type=UsertypeBoth;
 UIButton *uibtn=(UIButton*)sender;
    for (UIButton* button in arrayOfButtons)
    {
       uibtn.selected = true;
        _next.userInteractionEnabled = YES;
        [_next setBackgroundColor:[UIColor colorWithRed:59.0/255.0 green:216.0/255.0 blue:226.0/255.0 alpha:1.0]];
        isBoth=true;
        if (button != sender)
        {
            [button setSelected: FALSE];
            [button setBackgroundColor:[UIColor whiteColor]];
            if(button.tag==1)
            {
                [button setTitle:@"I am Patient" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:158.0/255.0 alpha:1 ]forState:UIControlStateNormal];
            }
            else if(button.tag==2)
            {
                [button setTitle:@"I am Caregiver" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:158.0/255.0 alpha:1 ]forState:UIControlStateNormal];
            }
            else{
                
                [button setTitle:@"Both" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:47.0/255.0 green:124.0/255.0 blue:158.0/255.0 alpha:1 ]forState:UIControlStateNormal];
            }
        }
    }
   
   if (uibtn.selected == TRUE) {
        [sender setSelected:FALSE];
        [self.redcheck3 setHidden:NO];
  uibtn.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:76.0/255.0 blue:122.0/255.0 alpha:1];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if (uibtn.selected == FALSE) {
        [sender setSelected:TRUE];
        [sender setBackgroundColor:[UIColor whiteColor]];
    }
    
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
        NSMutableArray * array = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
        NSMutableArray * array1 = [NSMutableArray arrayWithArray:array];
        [array1 addObject:[NSString stringWithFormat:@"error: %@",error.localizedDescription]];
        [[NSUserDefaults standardUserDefaults]setObject:array1 forKey:@"LogArray"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_debugView setHidden:true];
            [_debugContainerView setHidden:true];
        });
        
#else
        NSLog(@"not in end screen debug mode");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_debugView setHidden:false];
            [_debugContainerView setHidden:false];
            [_responseLabel setText:[NSString stringWithFormat:@"error: %@",error.localizedDescription]];
            if(_isThirdCall)
            {
                [_debugView setHidden:true];
                [_debugView1 setHidden:true];
                [_debugContainerView setHidden:true];
                [_responseView setHidden:false];
            // [_debugContainerView setHidden:false];
                [_responseLabel1 setText:[NSString stringWithFormat:@"error: %@",error.localizedDescription]];
            }
        });
#endif
#else
        NSLog(@"not in debug mode");
        dispatch_async(dispatch_get_main_queue(), ^{
            [_debugView setHidden:true];
            [_debugContainerView setHidden:true];
        });
#endif
        return;
    }
    NSError *jsonError;
    _dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if(!_isThirdCall)
    {
        _guidDictionary = _dic;
    }
#if ISDEBUG
    
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
    NSMutableArray * array1 = [NSMutableArray arrayWithArray:array];
    [array1 addObject:[NSString stringWithFormat:@"%@",_dic]];
    [[NSUserDefaults standardUserDefaults]setObject:array1 forKey:@"LogArray"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_debugView setHidden:true];
        [_debugContainerView setHidden:true];
        
    });
    
    if(_isThirdCall)
    {
        if(!_isFetchPublicClaims)
        {
            NSString *guid = [_guidDictionary valueForKey:@"guid"];
            [[NSUserDefaults standardUserDefaults]setObject:guid forKey:@"dcsi"];
            NSLog(@"dcsi %@",[_guidDictionary valueForKey:@"guid"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideBusyActivityView];
                [self performSelector:@selector(fetchPublicClaims) withObject:nil];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideBusyActivityView];
                NSArray *publicClaims = [_dic objectForKey:@"claims"];
                [[NSUserDefaults standardUserDefaults]setObject:publicClaims forKey:@"PublicClaims"];
            });
        }
        
        //        [UICKeyChainStore setString:guid forKey:@"dcsi" service:@"MyService"];
    }

    if(_isThirdCall)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator stopAnimating];
            [_activityContainerView setHidden:true];
            
        });
    }
    
    if(!_isThirdCall)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideBusyActivityView];
            [self performSelector:@selector(thirdCall) withObject:nil];
        });
    }
#else
    NSLog(@"not in end screen debug mode");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_debugView setHidden:false];
        [_debugContainerView setHidden:false];
        [_responseLabel setText:[NSString stringWithFormat:@"response dictionary: %@",_dic]];
        if(_isThirdCall)
        {
            [_debugView setHidden:true];
            [_debugView1 setHidden:true];
            [_debugContainerView setHidden:true];
            [_responseView setHidden:false];
            // [_debugContainerView setHidden:false];
            [_responseLabel1 setText:[NSString stringWithFormat:@"response dictionary: %@",_dic]];
            
        }
    });
#endif
#else
    NSLog(@"not in debug mode");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_debugView setHidden:true];
        [_debugContainerView setHidden:true];
    });
    if(_isThirdCall)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator stopAnimating];
            [_activityContainerView setHidden:true];
            
        });
    }
    if(!_isThirdCall)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(thirdCall) withObject:nil];
        });
    }
#endif
    if(jsonError)
    {
      //  [NSException raise:@"Exception in parsing JSON data" format:@"%@",jsonError.localizedDescription];
    }
    
    
    
    //    _resultsArray=[[NSArray alloc]initWithArray:[dic objectForKey:@"companies"]];
    
    
}
- (IBAction)okButtonTapped:(id)sender {
    DebugLog(@"");
    [self performSelector:@selector(thirdCall) withObject:nil];
}

-(void)thirdCall
{
    DebugLog(@"");
    [self showBusyActivityView];
    _isThirdCall = YES;
   
     apiHandler = [[mHealthApiHandler alloc] init];
    apiHandler.delegate = self;
    
    _endpoint=@"requestCsiRegistration";
    NSMutableArray *array=[[NSMutableArray alloc]init];
//    NSDictionary *arraydata1=[[NSDictionary alloc]initWithObjectsAndKeys:@"DateofBirth",@"key",@"11/29/1990",@"value" ,nil];
//    NSDictionary *arraydata2=[[NSDictionary alloc]initWithObjectsAndKeys:@"FirstName",@"key",@"Hefty",@"value" ,nil];
//    NSDictionary *arraydata3=[[NSDictionary alloc]initWithObjectsAndKeys:@"MiddleName",@"key",@"",@"value" ,nil];
//    NSDictionary *arraydata4=[[NSDictionary alloc]initWithObjectsAndKeys:@"LastName",@"key",@"Harvey",@"value" ,nil];
//    NSDictionary *arraydata5=[[NSDictionary alloc]initWithObjectsAndKeys:@"Gender",@"key",@"Male",@"value" ,nil];
    
    NSDictionary *arraydata1=[[NSDictionary alloc]initWithObjectsAndKeys:@"DateofBirth",@"key",@"",@"value" ,nil];
    NSDictionary *arraydata2=[[NSDictionary alloc]initWithObjectsAndKeys:@"FirstName",@"key",@"",@"value" ,nil];
    NSDictionary *arraydata3=[[NSDictionary alloc]initWithObjectsAndKeys:@"MiddleName",@"key",@"",@"value" ,nil];
    NSDictionary *arraydata4=[[NSDictionary alloc]initWithObjectsAndKeys:@"LastName",@"key",@"",@"value" ,nil];
    NSDictionary *arraydata5=[[NSDictionary alloc]initWithObjectsAndKeys:@"Gender",@"key",@"",@"value" ,nil];
    [array addObject:arraydata1];
    [array addObject:arraydata2];
    [array addObject:arraydata3];
    [array addObject:arraydata4];
    [array addObject:arraydata5];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    time_t currentTime = [[ServerSingleton sharedServerSingleton]time];
   
    NSString *currentDate  = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    NSString *deviceId = [[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"];
    NSString *guid = (NSString *)[_dic valueForKey:@"guid"];
    NSString *nonce = [self genRandStringLength:36];
    
    [self generateKeys];
    
    NSString *payload=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@"
//                       %@%@%@%@%@%@%@%@%@%@%@%@%@%@%@"
                       ,@"|",@"ecdsa",@"|",derKeyString,@"|",deviceId,@"|",currentDate,@"|",nonce,@"|",@"",@"|"];
//                       ,@"[{",@"\"key\": \"DateofBirth\", \"value\": \"",@"11/29/1990",@"\"},",@"{\"key\": \"FirstName\", \"value\": \"",@"Hefty",@"\"},"@"{\"key\": \"MiddleName\", \"value\": \"",@"",@"\"},"@"{\"key\": \"LastName\", \"value\": \"",@"Harvey",@"\"},"@"{\"key\": \"Gender\", \"value\": \"",@"Male",@"\"}",@"]",@"|"];
    payload=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"|",@"ecdsa",@"|",derKeyString,@"|",deviceId,@"|",currentDate,@"|",nonce,@"|",@"[{",@"\"key\": \"DateofBirth\", \"value\": \"",@"",@"\"},",@"{\"key\": \"FirstName\", \"value\": \"",@"",@"\"},"@"{\"key\": \"MiddleName\", \"value\": \"",@"",@"\"},"@"{\"key\": \"LastName\", \"value\": \"",@"",@"\"},"@"{\"key\": \"Gender\", \"value\": \"",@"",@"\"}",@"]",@"|"];
    NSLog(@"%@", payload);
    NSData * dataForSignature = [payload dataUsingEncoding:NSUTF8StringEncoding];
    // Creation of Signature
    NSData *signature=[self createSignature:dataForSignature withKey:privateKey];
    NSString *signatureString = [signature base64EncodedStringWithOptions:0];
    
    NSLog(@"current Date :%@ ",currentDate);
    NSLog(@"device id:%@",deviceId);
    NSLog(@"%@",guid);
    NSLog(@"%@", nonce);
    request_dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"org.fhirblocks.dapp",@"applicationClass",@"ecdsa",@"cipherSpec",currentDate,@"dateTime",deviceId,@"deviceId",guid,@"csiGuid",nonce,@"nonce",array,@"publicClaims",derKeyString,@"publicKey",signatureString,@"signature" ,nil];
    
#if ISDEBUG
    
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
    NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
    [array2 addObject:[NSString stringWithFormat:@"%@%@%@",CSI_Base_URL,_endpoint,request_dic]];
    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
    [_debugView setHidden:true];
    [_debugView1 setHidden:true];
    //[h createSessionforCSIEndPoint:_endpoint withModelDictionary:request_dic];
    [apiHandler createSessionforCSIEndPoint:_endpoint withModelDictionary:request_dic];
    _activityContainerView.hidden = false;
    
    [_activityIndicator startAnimating];
#else
    [_debugView setHidden:true];
    [_debugContainerView setHidden:true];
    [_debugView1 setHidden:false];
    _debugView1.contentSize = CGSizeMake(398, 512);
    [_activityContainerView setHidden:false];
    // [_debugContainerView setHidden:false];
    [_requestLabel1 setText:[NSString stringWithFormat:@"%@%@ Model Dictionary %@",CSI_Base_URL,_endpoint,request_dic]];
    
    _activityViewCenterConstraint.constant=-200.0;
    [_activityIndicator startAnimating];
#endif
    
#else
    NSLog(@"not in debug mode");
    [_debugView setHidden:true];
    [_debugView1 setHidden:true];
    [apiHandler createSessionforCSIEndPoint:_endpoint withModelDictionary:request_dic];
    _activityContainerView.hidden = false;
    
    [_activityIndicator startAnimating];
    //[_debugContainerView setHidden:true];
#endif
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
    NSLog(@"private key is %@:",privateKey);

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
    CFErrorRef error1 = NULL;
    NSData* keyDataAPIPrivate = (NSData*)CFBridgingRelease(  // ARC takes ownership
                                                           SecKeyCopyExternalRepresentation(privateKey, &error1)
                                                           );
    if (!keyDataAPIPrivate) {
        NSError *err = CFBridgingRelease(error1);  // ARC takes ownership
        // Handle the error. . .
    }
    [[NSUserDefaults standardUserDefaults]setObject:keyDataAPIPrivate forKey:@"PrivateKey"];
    CryptoExportImportManager * exportImportManager = [[CryptoExportImportManager alloc]init];
    NSData * exportableDERKey = [exportImportManager exportPublicKeyToDER:keyDataAPI keyType:(NSString*)kSecAttrKeyTypeEC keySize:256];
    derKeyString = [exportableDERKey base64EncodedStringWithOptions:0];
    NSLog(@"Public Key %@",derKeyString);
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
- (IBAction)requestOKButtonPressed:(id)sender
{
    DebugLog(@"");
    [apiHandler createSessionforCSIEndPoint:_endpoint withModelDictionary:request_dic];
    _activityContainerView.hidden = false;
    
    [_activityIndicator startAnimating];
}
- (IBAction)responseOkButtonPressed:(id)sender {
    DebugLog(@"");
    [_activityIndicator stopAnimating];
    [_responseView setHidden:true];
    // [_debugContainerView setHidden:false];
    [_responseLabel1 setHidden:true];
    [_activityContainerView setHidden:true];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DebugLog(@"");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"PermissionSegue"])
       {
           UINavigationController *navController=[segue destinationViewController];
           ViewController * viewController = [navController viewControllers][0];
           viewController.dic = _guidDictionary;
       }
//    viewController.permissionsFamilyArray = _permissionsFamilyArray;
}

- (void)fetchPublicClaims
{
    DebugLog(@"");
    [self showBusyActivityView];
    _isFetchPublicClaims = YES;
    
    mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc] init];
    apiHandler.delegate = self;
    
    _endpoint=@"fetchPublicClaims";
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    time_t currentTime = [[ServerSingleton sharedServerSingleton]time];
    
    NSString *currentDate  = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    NSString *deviceId = [[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"];
    NSString *guid = [_guidDictionary valueForKey:@"guid"];
    NSString *desiredGuid = [[NSUserDefaults standardUserDefaults]valueForKey:@"wcsi"];
    
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
    [apiHandler createSessionforCSIEndPoint:_endpoint withModelDictionary:request_dic];
    
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
