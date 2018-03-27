//
//  ExtendedLogsViewController.m
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "ExtendedLogsViewController.h"
#import "Constants.h"

@interface ExtendedLogsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;

@end

@implementation ExtendedLogsViewController

- (void)viewDidLoad {
    DebugLog(@"");
    _label1.text=@"";
    _label2.text=@"";
    _label3.text=@"";
    _label4.text=@"";

    [super viewDidLoad];
    
   NSArray *array = [[NSUserDefaults standardUserDefaults]valueForKey:@"LogArray1"];
   //@"http://smoac.fhirblocks.io:8080/permission/writePermission"
    NSMutableString *witePermissionDataString = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *writePermissionResponseString = [[NSMutableString alloc] initWithString:@""];
    //for (NSString *strData in array)
    for (int iCount=0; iCount<array.count; iCount++)
    {
        NSString *strData = array[iCount];
        if ([strData rangeOfString:[NSString stringWithFormat:@"%@writePermission",Permission_Base_URL]].location != NSNotFound)
        {
            [witePermissionDataString appendString:[NSString stringWithFormat:@"\n%@",strData]];
            [writePermissionResponseString appendString:[NSString stringWithFormat:@"\n%@",array[iCount+1]]];

        }
    }
    DebugLog(@"===>%@ \nresponse string ===>%@",witePermissionDataString,writePermissionResponseString);
    
    NSMutableString *fetchPublicClaimDataString = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *fetchPublicClaimResponseString = [[NSMutableString alloc] initWithString:@""];
    //for (NSString *strData in array)
    for (int iCount=0; iCount<array.count; iCount++)
    {
        NSString *strData = array[iCount];
        if ([strData rangeOfString:[NSString stringWithFormat:@"%@fetchPublicClaims",CSI_Base_URL]].location != NSNotFound)
        {
            [fetchPublicClaimDataString appendString:[NSString stringWithFormat:@"\n%@",strData]];
            [fetchPublicClaimResponseString appendString:[NSString stringWithFormat:@"\n%@",array[iCount+1]]];
            
        }
    }
    DebugLog(@"===>%@ \nresponse string ===>%@",fetchPublicClaimDataString,fetchPublicClaimResponseString);
    
    
    NSString * s5=witePermissionDataString;//[array objectAtIndex:12];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:s5];
    NSRange range = [s5 rangeOfString:@"Body Encoded String:"];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range];
    
    NSRange range1 = [s5 rangeOfString:@"Header Encoded String:"];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range1];
    
    NSRange range2 = [s5 rangeOfString:@"Signature String:"];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range2];
    
    NSRange range3 = [s5 rangeOfString:@"URL Encoded String:"];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range3];
    
    _label1.attributedText=attString;
    
    
   /* NSString * s6=[array objectAtIndex:14];
    _label2.text=s6;
    _signatureLabel.text=[array objectAtIndex:13];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width - 8, self.label1.frame.size.height * 3);
//    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width - 8, self.label5.frame.size.height * 2);*/
    NSString * s3=[array objectAtIndex:8];
    _label3.text=fetchPublicClaimDataString;
    
    NSString *s6=[array objectAtIndex:7];
    _label2.text=writePermissionResponseString;
    
    NSString * s4=[array objectAtIndex:9];
    _label4.text=fetchPublicClaimResponseString;//s4;
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:128.0/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.hidden = NO;
    
    // Do any additional setup after loading the view.
}
- (IBAction)backButtonPressed:(id)sender {
    DebugLog(@"");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
