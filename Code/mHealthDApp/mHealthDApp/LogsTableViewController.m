//
//  LogsTableViewController.m
//  mHealthDApp
//
//  Created by bhavesh devnani on 09/01/18.
//  Copyright © 2018 Sonam Agarwal. All rights reserved.
//

#import "LogsTableViewController.h"
#import "RequestTableViewCell.h"
#import "ResponseTableViewCell.h"
#import "LogHeaderView.h"
#import "Constants.h"

@interface LogsTableViewController ()

@end

@implementation LogsTableViewController

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
//    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [(NSMutableArray *)[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionsLogArray"]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 179;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    if(indexPath.row % 2 == 0)
    {
        RequestTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell" forIndexPath:indexPath];
        cell.requestLabel.text = [(NSArray *)[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionsLogArray"] objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        ResponseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ResponseCell" forIndexPath:indexPath];
        cell.responseLabel.text = [(NSArray *)[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionsLogArray"] objectAtIndex:indexPath.row];
        return cell;
    }
//     Configure the cell...
 
    
}

-(void)closeButtonTapped
{
    DebugLog(@"");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *viewArray=[[NSBundle mainBundle]loadNibNamed:@"LogHeaderView" owner:self options:nil];
    LogHeaderView *view=(LogHeaderView *)[viewArray objectAtIndex:0];
    view.delegate = self;
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
