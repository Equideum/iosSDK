//
//  UtilsViewController.m
//  mHealthDApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "UtilsViewController.h"
#import "Constants.h"
#import "UICKeyChainStore.h"


#define INVITE_FRIEND @"Invite Friend"
#define BECOME_FRIEND @"Become Friend"
#define LOGS @"Logs"
#define RESET @"Reset"
#define LOGOUT @"Logout"

@interface UtilsViewController ()
{
    NSMutableArray *arrMenu;
    NSMutableString *strBecomeFriendData;
    NSArray * publicClaims;

}
@end

@implementation UtilsViewController
@synthesize tblMenu;
- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
   
    publicClaims = [[NSUserDefaults standardUserDefaults]valueForKey:@"PublicClaims"];

    strBecomeFriendData = [[NSMutableString alloc] initWithString:@"mHealthDApp"];
    [strBecomeFriendData appendString:[NSString stringWithFormat:@"#%@",[[publicClaims objectAtIndex:1] objectForKey:@"value"]]];
    [strBecomeFriendData appendString:[NSString stringWithFormat:@"%@%@",COMPONENTS_SEPERATED_STRING,[[publicClaims objectAtIndex:3] objectForKey:@"value"]]];
    [strBecomeFriendData appendString:[NSString stringWithFormat:@"%@%@",COMPONENTS_SEPERATED_STRING,[[publicClaims objectAtIndex:4] objectForKey:@"value"]]];
    [strBecomeFriendData appendString:[NSString stringWithFormat:@"%@%@",COMPONENTS_SEPERATED_STRING,[[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"]]];
    
    // Do any additional setup after loading the view.
    [self.tblMenu registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.navigationController.navigationBar.hidden=NO;
    self.title=@"Utility";
    arrMenu = [[NSMutableArray alloc]initWithObjects:INVITE_FRIEND,BECOME_FRIEND,LOGS,RESET,LOGOUT, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark ==============================
#pragma mark UItableview delegates
#pragma mark ==============================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMenu.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@",arrMenu[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([arrMenu[indexPath.row] isEqualToString:INVITE_FRIEND])
    {
        [self performSegueWithIdentifier:@"UtilsToAddCSI" sender:self];
    }
    else if ([arrMenu[indexPath.row] isEqualToString:BECOME_FRIEND])
    {
        [UIPasteboard generalPasteboard].string = strBecomeFriendData;
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if ([arrMenu[indexPath.row] isEqualToString:LOGS])
    {
        [self performSegueWithIdentifier:@"UtilsToLogs" sender:self];
    }
    else if ([arrMenu[indexPath.row] isEqualToString:RESET])
    {
        [self resetCall];
        [self.navigationController popViewControllerAnimated:YES];

    }
    else if ([arrMenu[indexPath.row] isEqualToString:LOGOUT])
    {
        exit (0);
    }
}
-(void)resetCall
{
    DebugLog(@"");
    [UICKeyChainStore setString:nil forKey:@"dcsi" service:@"MyService"];
    [UICKeyChainStore setString:nil forKey:@"dSharedPermissions" service:@"MyService"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"UniqueIdentifier"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"dcsi"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"dpermissionshared"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"wcsi"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"Flow"];
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
