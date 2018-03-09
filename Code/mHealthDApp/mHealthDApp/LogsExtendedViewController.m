//
//  LogsExtendedViewController.m
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "LogsExtendedViewController.h"
#import "Constants.h"

@interface LogsExtendedViewController ()
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@end

@implementation LogsExtendedViewController

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    NSArray *array = [[NSUserDefaults standardUserDefaults]valueForKey:@"LogArray1"];
    
    NSMutableString *authDataString = [[NSMutableString alloc] initWithString:@""];
    for (NSString *strData in array) {
        if ([strData rangeOfString:@"http://smoac.fhirblocks.io:8080/vaca/auth"].location != NSNotFound) {
            [authDataString appendString:[NSString stringWithFormat:@"\n%@",strData]];
            
        }
    }
    DebugLog(@"===>%@",authDataString);
    
    NSString * s1=[array objectAtIndex:10];
    //_label1.text = s1;
    NSString * s2=[array objectAtIndex:11];
    _label2.text = @"";//s2;
    NSString * s5=authDataString;//[array objectAtIndex:15];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:s5];
    NSRange range = [s5 rangeOfString:@"Body Encoded String:"];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range];
    
    NSRange range1 = [s5 rangeOfString:@"Header Encoded String:"];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range1];
    
    NSRange range2 = [s5 rangeOfString:@"Signature String:"];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range2];
    
    NSRange range3 = [s5 rangeOfString:@"URL Encoded String:"];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range3];
    
    //_label3.attributedText=attString;
    _label1.attributedText=attString;

    NSMutableString *accessDataString = [[NSMutableString alloc] initWithString:@""];
    for (NSString *strData in array) {
        if ([strData rangeOfString:@"http://smoac.fhirblocks.io:8080/vaca/access"].location != NSNotFound) {
            [accessDataString appendString:[NSString stringWithFormat:@"\n%@",strData]];
            
        }
    }
    DebugLog(@"===>%@",accessDataString);
    
    NSString * accessStr=accessDataString;//[array objectAtIndex:15];
    NSMutableAttributedString *accessString = [[NSMutableAttributedString alloc] initWithString:accessStr];
    NSRange range4 = [accessStr rangeOfString:@"Body Encoded String:"];
    
    [accessString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range4];
    
    NSRange range5 = [accessStr rangeOfString:@"Header Encoded String:"];
    
    [accessString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range5];
    
    NSRange range6 = [accessStr rangeOfString:@"Signature String:"];
    
    [accessString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range6];
    
    NSRange range7 = [accessStr rangeOfString:@"URL Encoded String:"];
    
    [accessString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range7];
    
    //_label3.attributedText=attString;
    _label3.attributedText=accessString;

    
    
    NSString * s6=[array objectAtIndex:16];
    _label4.text=@"";//s6;
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
