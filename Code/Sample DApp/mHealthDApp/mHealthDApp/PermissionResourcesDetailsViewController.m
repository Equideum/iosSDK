//
//  PermissionResourcesDetailsViewController.m
//  FBlocksCSA
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */
//

#import "PermissionResourcesDetailsViewController.h"

@interface PermissionResourcesDetailsViewController ()

@end

@implementation PermissionResourcesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewAlert.layer.cornerRadius = 10;
    self.viewAlert.layer.masksToBounds = true;
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

- (IBAction)btnCloseTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
