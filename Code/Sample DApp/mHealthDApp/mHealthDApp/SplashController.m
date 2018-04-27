
//
//  SplashController.m
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import<LocalAuthentication/LocalAuthentication.h>
#import "SplashController.h"
#import "Constants.h"
#import "UICKeyChainStore.h"
#import "ServerSingleton.h"
#import "Constants.h"

#define FBLOCKSCSASCHEME @"FBlocksCSA://?scheme=mHealthDApp"

@interface SplashController ()
@property (weak, nonatomic) IBOutlet UIView *debugContainerView;
@property (weak, nonatomic) IBOutlet UIView *debugView;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgThumb;
@property (strong, nonatomic) IBOutlet UILabel *lblAuthenticateText;
@property (strong, nonatomic) IBOutlet UIButton *btnAction;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraintImgThumb;


@property(nonatomic) NSString *endpoint;
@property (nonatomic) BOOL isSecondCall;
@end

@implementation SplashController

@synthesize imgThumb,lblAuthenticateText;
@synthesize topConstraintImgThumb;
@synthesize btnAction;

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    imgThumb.hidden=YES;
    lblAuthenticateText.hidden=YES;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:@"WalletCsiPosted" object:nil];
    CGRect applicationFrame=[[UIScreen mainScreen] bounds];
    if(applicationFrame.size.height <= 480)
    {
        topConstraintImgThumb.constant = topConstraintImgThumb.constant - 100;
    }
    btnAction.layer.cornerRadius=5;

}

- (IBAction)cleanUpAtLogout:(id)sender {
    DebugLog(@"");

    [UICKeyChainStore setString:nil forKey:@"dcsi" service:@"MyService"];
    [UICKeyChainStore setString:nil forKey:@"dSharedPermissions" service:@"MyService"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"UniqueIdentifier"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"dcsi"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"dpermissionshared"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"wcsi"];
    exit (0);
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    DebugLog(@"");

    NSLog(@"will enter foreground notification");
    NSString *fBlocksCSA=FBLOCKSCSASCHEME;
    BOOL canOpenURL=[[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:fBlocksCSA]];
    if (!canOpenURL) {
        
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Please install CSA!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Download"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.fhirblocks.org/"] options:@{} completionHandler:nil];
                                                              }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];*/
        lblAuthenticateText.hidden = NO;
        lblAuthenticateText.text = @"Please install CSA!";
        btnAction.tag = 1;
         [btnAction setTitle:@"Download" forState:UIControlStateNormal];
        [btnAction addTarget:self action:@selector(btnAlertAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        if([[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"] == nil
           ||[[NSUserDefaults standardUserDefaults]valueForKey:@"wcsi"] == nil)
        {
           /* UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                           message:@"Please do registration in CSA."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                                                      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:fBlocksCSA] options:@{} completionHandler:nil];
                                                                      
                                                                  }];
            
            
            //                                                                  }];
            [alert addAction:firstAction];
            [self presentViewController:alert animated:YES completion:nil];*/
            lblAuthenticateText.hidden = NO;
            lblAuthenticateText.text = @"Please do registration in CSA.";
            btnAction.tag = 2;
             [btnAction setTitle:@"Ok" forState:UIControlStateNormal];
            [btnAction addTarget:self action:@selector(btnAlertAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else
        {
//            if([[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"] == nil)
//            {
#if ISDEBUG
#if ISENDSCREEN
            [self performSelector:@selector(firstCall) withObject:nil afterDelay:0];
#else
            [self performSelector:@selector(firstCall) withObject:nil afterDelay:25];
#endif
# else
            [self performSelector:@selector(firstCall) withObject:nil afterDelay:0];
#endif
                
//            }
//            else
//            {
//                if([(NSString *)[[NSUserDefaults standardUserDefaults]valueForKey:@"Flow"] isEqualToString:@"Patient"])
//                {
//                    [self performSegueWithIdentifier:@"LoggedinDashboardSegue" sender:nil];
//                }
//                else if([(NSString *)[[NSUserDefaults standardUserDefaults]valueForKey:@"Flow"] isEqualToString:@"Caregiver"])
//                {
//                    [self performSegueWithIdentifier:@"LoggedinCaregiverSegue" sender:nil];
//                }
//                else
//                {
//                    [self performSelector:@selector(showWelcomeScreenWithDelay) withObject:nil];
//                }
//            }
        }
    }
}
-(IBAction)btnAlertAction:(id)sender
{
    DebugLog(@"");
    lblAuthenticateText.hidden = YES;
    btnAction.hidden = YES;
    
    NSString *fBlocksCSA=FBLOCKSCSASCHEME;

    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 1)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.fhirblocks.org/"] options:@{} completionHandler:nil];
    else
      [[UIApplication sharedApplication]openURL:[NSURL URLWithString:fBlocksCSA] options:@{} completionHandler:nil];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    DebugLog(@"");

    [super viewDidAppear:animated];
    NSString *fBlocksCSA=@"FBlocksCSA://?scheme=mHealthDApp";
    BOOL canOpenURL=[[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:fBlocksCSA]];
    if (!canOpenURL) {
       
        /*UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                       message:@"Please install CSA!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Download"
                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.fhirblocks.org/"] options:@{} completionHandler:nil];
                                                              }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];*/
       
        lblAuthenticateText.hidden = NO;
        lblAuthenticateText.text = @"Please install CSA!";
        btnAction.tag = 1;
        [btnAction setTitle:@"Download" forState:UIControlStateNormal];
        [btnAction addTarget:self action:@selector(btnAlertAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        if([[NSUserDefaults standardUserDefaults]valueForKey:@"UniqueIdentifier"] == nil
            ||[[NSUserDefaults standardUserDefaults]valueForKey:@"wcsi"] == nil)
        {
            /*UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                           message:@"Please do registration in CSA."
                                                                    preferredStyle:UIAlertControllerStyleAlert];

                                                                                                                                        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                                                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                                                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                                                                                                  [[UIApplication sharedApplication]openURL:[NSURL URLWithString:fBlocksCSA] options:@{} completionHandler:nil];
                                                                      
                                                                                                                                                                                              }];
                                                                      //                                                                  [alert addAction:firstAction];
                                                                      //                                                                  [self presentViewController:alert animated:YES completion:nil];
                                                                      
                                                                      
//                                                                  }];
            [alert addAction:firstAction];
            [self presentViewController:alert animated:YES completion:nil];*/
            lblAuthenticateText.hidden = NO;
            lblAuthenticateText.text = @"Please do registration in CSA.";
            btnAction.tag = 2;
            [btnAction setTitle:@"Ok" forState:UIControlStateNormal];
            [btnAction addTarget:self action:@selector(btnAlertAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            
            if ([[NSUserDefaults standardUserDefaults]valueForKey:@"apppermissionshared"] != nil)
            {
                NSString *strPermission = [[NSUserDefaults standardUserDefaults]valueForKey:@"apppermissionshared"];
                if([strPermission isEqualToString:@"delete"])
                {
                    [self performSelector:@selector(showWelcomeScreenWithDelay) withObject:nil];
                }
            }
            else
            {
                
                if([[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"] == nil)
                {
#if ISDEBUG
#if ISENDSCREEN
                    [self performSelector:@selector(firstCall) withObject:nil afterDelay:5];
#else
                    [self performSelector:@selector(firstCall) withObject:nil afterDelay:25];
#endif
# else
                    [self performSelector:@selector(firstCall) withObject:nil afterDelay:0];
#endif
                    
                }
                else
                {
                    if([(NSString *)[[NSUserDefaults standardUserDefaults]valueForKey:@"Flow"] isEqualToString:@"Patient"])
                    {
                        imgThumb.hidden=NO;
                        lblAuthenticateText.hidden=YES;
                        btnAction.hidden = YES;
                        LAContext *myContext = [[LAContext alloc] init];
                        NSError *authError = nil;
                        NSString *myLocalizedReasonString = @"Place your finger to authenticate";
                        
                        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
                            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                      localizedReason:myLocalizedReasonString
                                                reply:^(BOOL success, NSError *error) {
                                                    if (success) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            imgThumb.image=[UIImage imageNamed:@"thumb_green.png"];
                                                            [self performSelector:@selector(showDashBoard) withObject:nil afterDelay:1.0];
                                                        });
                                                    } else
                                                    {
                                                        switch (error.code) {
                                                            case LAErrorAuthenticationFailed:
                                                            {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                   message:@"You reached maximum attempts"
                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                             message:@"Your app will now be terminated."
                                                                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                              UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                                                                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                                                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                                                                                        exit(0);
                                                                                                                                                                                        
                                                                                                                                                                                    }];
                                                                                                                              [alert addAction:firstAction];
                                                                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                                                                              
                                                                                                                              
                                                                                                                          }];
                                                                    [alert addAction:firstAction];
                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                    
                                                                });
                                                                break;
                                                            }
                                                            case LAErrorUserCancel:
                                                            {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                   message:@"You pressed Cancel Button"
                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                             message:@"Your app will now be terminated."
                                                                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                              UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                                                                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                                                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                                                                                        exit(0);
                                                                                                                                                                                        
                                                                                                                                                                                    }];
                                                                                                                              [alert addAction:firstAction];
                                                                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                                                                              
                                                                                                                              
                                                                                                                          }];
                                                                    [alert addAction:firstAction];
                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                    
                                                                });
                                                                break;
                                                            }
                                                            case LAErrorUserFallback:
                                                            {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                   message:@"You can auntheticate using only touchid"
                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                             message:@"Your app will now be terminated."
                                                                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                              UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                                                                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                                                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                                                                                        exit(0);
                                                                                                                                                                                        
                                                                                                                                                                                    }];
                                                                                                                              [alert addAction:firstAction];
                                                                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                                                                              
                                                                                                                          }];
                                                                    [alert addAction:firstAction];
                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                });
                                                                break;
                                                            }
                                                            default: {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                   message:error.localizedDescription
                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                              
                                                                                                                          }];
                                                                    [alert addAction:firstAction];
                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                });
                                                                break;
                                                            }
                                                        }
                                                    }//else
                                                }];
                        }
                        else {
                            
                            
                            
                            //        dispatch_async(dispatch_get_main_queue(), ^{
                            //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                            //                                                                           message:@"Touch Id is disabled on your device.Please enable it to authenticate"
                            //                                                                    preferredStyle:UIAlertControllerStyleAlert];
                            //            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                            //                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            //                                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                            //
                            //
                            //                                                                  }];
                            //
                            //            [alert addAction:firstAction];
                            //
                            //            [self presentViewController:alert animated:YES completion:nil];
                            //
                            //            // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                            //        });
                            switch (authError.code) {
                                    
                                case kLAErrorTouchIDNotAvailable:
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        imgThumb.hidden=NO;
                                        lblAuthenticateText.hidden=YES;
                                        btnAction.hidden = YES;
                                        
                                    });
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                                       message:@"Touch Id is not available for your device.Press OK to continue"
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                  
                                                                                                  //[self performSegueWithIdentifier:@"LoggedinDashboardSegue" sender:nil];
                                                                                                  imgThumb.image=[UIImage imageNamed:@"thumb_green.png"];
                                                                                                  [self performSelector:@selector(showDashBoard) withObject:nil afterDelay:1.0];
                                                                                              }];
                                        
                                        [alert addAction:firstAction];
                                        
                                        [self presentViewController:alert animated:YES completion:nil];
                                        
                                        // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                                    });
                                    
                                    break;
                                }
                                case kLAErrorTouchIDNotEnrolled:{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                       message:@"Touch Id is not enabled on your device.Please enable it and then continue running this app."
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                  
                                                                                                  
                                                                                              }];
                                        
                                        [alert addAction:firstAction];
                                        
                                        [self presentViewController:alert animated:YES completion:nil];
                                        
                                        // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                                    });
                                    
                                    break;
                                }
                                    
                                    
                                default:
                                    break;
                            }
                        }
                    }
                    else if([(NSString *)[[NSUserDefaults standardUserDefaults]valueForKey:@"Flow"] isEqualToString:@"Caregiver"])
                    {
                        //imgThumb.hidden=NO;
                        lblAuthenticateText.hidden=YES;
                        btnAction.hidden = YES;
                        
                        LAContext *myContext = [[LAContext alloc] init];
                        NSError *authError = nil;
                        NSString *myLocalizedReasonString = @"Place your finger to authenticate";
                        
                        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
                            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                      localizedReason:myLocalizedReasonString
                                                reply:^(BOOL success, NSError *error) {
                                                    if (success) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            imgThumb.image=[UIImage imageNamed:@"thumb_green.png"];
                                                            sleep(1);
                                                            [self performSegueWithIdentifier:@"LoggedinDashboardSegue" sender:nil];
                                                        });
                                                    } else
                                                    {
                                                        switch (error.code) {
                                                            case LAErrorAuthenticationFailed:
                                                            {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                   message:@"You reached maximum attempts"
                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                             message:@"Your app will now be terminated."
                                                                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                              UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                                                                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                                                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                                                                                        exit(0);
                                                                                                                                                                                        
                                                                                                                                                                                    }];
                                                                                                                              [alert addAction:firstAction];
                                                                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                                                                              
                                                                                                                              
                                                                                                                          }];
                                                                    [alert addAction:firstAction];
                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                    
                                                                });
                                                                break;
                                                            }
                                                            case LAErrorUserCancel:
                                                            {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                   message:@"You pressed Cancel Button"
                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                             message:@"Your app will now be terminated."
                                                                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                              UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                                                                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                                                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                                                                                        exit(0);
                                                                                                                                                                                        
                                                                                                                                                                                    }];
                                                                                                                              [alert addAction:firstAction];
                                                                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                                                                              
                                                                                                                              
                                                                                                                          }];
                                                                    [alert addAction:firstAction];
                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                    
                                                                });
                                                                break;
                                                            }
                                                            case LAErrorUserFallback:
                                                            {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                   message:@"You can auntheticate using only touchid"
                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                                                                             message:@"Your app will now be terminated."
                                                                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                                                                              UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                                                                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                                                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                                                                                        exit(0);
                                                                                                                                                                                        
                                                                                                                                                                                    }];
                                                                                                                              [alert addAction:firstAction];
                                                                                                                              [self presentViewController:alert animated:YES completion:nil];
                                                                                                                              
                                                                                                                          }];
                                                                    [alert addAction:firstAction];
                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                });
                                                                break;
                                                            }
                                                            default: {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                                                   message:error.localizedDescription
                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                                              
                                                                                                                          }];
                                                                    [alert addAction:firstAction];
                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                });
                                                                break;
                                                            }
                                                        }
                                                    }//else
                                                }];
                        }
                        else {
                            
                            
                            //        dispatch_async(dispatch_get_main_queue(), ^{
                            //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                            //                                                                           message:@"Touch Id is disabled on your device.Please enable it to authenticate"
                            //                                                                    preferredStyle:UIAlertControllerStyleAlert];
                            //            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                            //                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            //                                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                            //
                            //
                            //                                                                  }];
                            //
                            //            [alert addAction:firstAction];
                            //
                            //            [self presentViewController:alert animated:YES completion:nil];
                            //
                            //            // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                            //        });
                            switch (authError.code) {
                                case kLAErrorTouchIDNotAvailable:
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        lblAuthenticateText.hidden=YES;
                                        btnAction.hidden = YES;
                                        
                                    });
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                                                       message:@"Touch Id is not available for your device.Press OK to continue"
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                  
                                                                                                  [self performSegueWithIdentifier:@"LoggedinDashboardSegue" sender:nil];
                                                                                              }];
                                        
                                        [alert addAction:firstAction];
                                        
                                        [self presentViewController:alert animated:YES completion:nil];
                                        
                                        // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                                    });
                                    
                                    break;
                                }
                                case kLAErrorTouchIDNotEnrolled:{
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                                       message:@"Touch Id is not enabled on your device.Please enable it and then continue running this app."
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                                                                  
                                                                                                  
                                                                                              }];
                                        
                                        [alert addAction:firstAction];
                                        
                                        [self presentViewController:alert animated:YES completion:nil];
                                        
                                        // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                                    });
                                    
                                    break;
                                }
                                    
                                    
                                default:
                                    break;
                            }
                        }
                    }
                    else
                    {
                        [self performSelector:@selector(showWelcomeScreenWithDelay) withObject:nil];
                    }
                }
            }

        
        }
    }
//    if([UICKeyChainStore stringForKey:@"UniqueIdentifier" service:@"MyService"] == nil || [UICKeyChainStore stringForKey:@"wcsi" service:@"MyService"] == nil)
//    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
//                                                                       message:@"Please install CSA!"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Download"
//                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
//                                                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.fhirblocks.org/"] options:@{} completionHandler:nil];
////                                                                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
////                                                                                                                                 message:@"Your app will now be terminated."
////                                                                                                                          preferredStyle:UIAlertControllerStyleAlert];
////                                                                  UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
////                                                                                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
////                                                                                                                            [alert dismissViewControllerAnimated:YES completion:nil];
////                                                                                                                            exit(0);
////
////                                                                                                                        }];
////                                                                  [alert addAction:firstAction];
////                                                                  [self presentViewController:alert animated:YES completion:nil];
//
//
//                                                              }];
//        [alert addAction:firstAction];
//        [self presentViewController:alert animated:YES completion:nil];
//
//    }
//    else
//    {
//
//#if ISDEBUG
//#if ISENDSCREEN
//        [self performSelector:@selector(firstCall) withObject:nil afterDelay:5];
//#else
//        [self performSelector:@selector(firstCall) withObject:nil afterDelay:25];
//#endif
//# else
//        [self performSelector:@selector(firstCall) withObject:nil afterDelay:0];
//#endif
//    }
//
}

-(void)showDashBoard
{
    DebugLog(@"");
    [self performSegueWithIdentifier:@"LoggedinDashboardSegue" sender:nil];
}

-(void)firstCall
{
    DebugLog(@"");

    mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc] init];
    apiHandler.delegate =  self;
    
    //APIhandler *h=[[APIhandler alloc]init];
    //h.delegate = self;
    
    _endpoint=@"ping";
   // [h createSessionWithEndPoint:_endpoint];
    [apiHandler createSessionWithEndPoint:_endpoint];
#if ISDEBUG
    
    
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    [_debugView setHidden:true];
    [_debugContainerView setHidden:true];
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    [array addObject:[NSString stringWithFormat:@"%@%@",Base_URL,_endpoint]];
    [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"LogArray"];
    
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
    
}

-(void)secondCall
{
    DebugLog(@"");

    _isSecondCall=YES;
   // APIhandler *h=[[APIhandler alloc]init];
   // h.delegate = self;
    
    mHealthApiHandler *apiHandler = [[mHealthApiHandler alloc] init];
    apiHandler.delegate =  self;
    
    _endpoint=@"getTime";
#if ISDEBUG
    
#if ISENDSCREEN
    NSLog(@"in end screen debug mode");
    NSMutableArray * array = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"LogArray"];
    NSMutableArray * array1 = [NSMutableArray arrayWithArray:array];
    [array1 addObject:[NSString stringWithFormat:@"%@%@",Base_URL,_endpoint]];
    [[NSUserDefaults standardUserDefaults]setObject:array1 forKey:@"LogArray"];
#else
    [_requestLabel setText:[NSString stringWithFormat:@"%@%@",Base_URL,_endpoint]];
    
#endif
#else
    
#endif
    
    //[h createSessionWithEndPoint:_endpoint];
    [apiHandler createSessionWithEndPoint:_endpoint];
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
    //    [self performSelector:@selector(showWelcomeScreenWithDelay) withObject:self afterDelay:0];
    });
    
    if(_isSecondCall)
    {
        
        [[NSUserDefaults standardUserDefaults]setObject:(NSString *)[_dic valueForKey:@"currentTime"] forKey:@"CurrentTime"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        NSString *dateString = [dateformatter stringFromDate:[NSDate date]];
        NSLog(@"Server Time %@",[_dic valueForKey:@"currentTime"]);
        NSLog(@"System Time %@",dateString);
        [[ServerSingleton sharedServerSingleton]checkTimeWithDate:(NSString *)[_dic valueForKey:@"currentTime"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(showWelcomeScreenWithDelay) withObject:nil];

        });
    }

    if(!_isSecondCall)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(secondCall) withObject:nil];
        });
    }
#else
    NSLog(@"not in end screen debug mode");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_debugView setHidden:false];
        [_debugContainerView setHidden:false];
        [_responseLabel setText:[NSString stringWithFormat:@"response dictionary: %@",_dic]];
    });
#endif
#else
    NSLog(@"not in debug mode");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_debugView setHidden:true];
        [_debugContainerView setHidden:true];
       // [self performSelector:@selector(showWelcomeScreenWithDelay) withObject:self afterDelay:0];
    });
    
    if(_isSecondCall)
    {
        [[NSUserDefaults standardUserDefaults]setObject:(NSString *)[_dic valueForKey:@"currentTime"] forKey:@"CurrentTime"];
        [[ServerSingleton sharedServerSingleton]checkTimeWithDate:(NSString *)[_dic valueForKey:@"currentTime"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(showWelcomeScreenWithDelay) withObject:nil];

        });
    }

    if(!_isSecondCall)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(secondCall) withObject:nil];
        });
    }
#endif
    if(jsonError)
    {
        [NSException raise:@"Exception in parsing JSON data" format:@"%@",jsonError.localizedDescription];
    }
    
    
}

- (IBAction)okBtnPressed:(UIButton *)sender {
    
    DebugLog(@"");
    if(_isSecondCall)
    {
        [[NSUserDefaults standardUserDefaults]setObject:(NSString *)[_dic valueForKey:@"currentTime"] forKey:@"CurrentTime"];
        [[ServerSingleton sharedServerSingleton]checkTimeWithDate:(NSString *)[_dic valueForKey:@"currentTime"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(showWelcomeScreenWithDelay) withObject:nil];
            
        });
    }
    
    if(!_isSecondCall)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(secondCall) withObject:nil];
        });
    }
}

- (void)didReceiveMemoryWarning {
    DebugLog(@"");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showWelcomeScreenWithDelay
{
    DebugLog(@"");
    [self performSegueWithIdentifier:@"WelcomeSegueNew" sender:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc
{
    DebugLog(@"");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
