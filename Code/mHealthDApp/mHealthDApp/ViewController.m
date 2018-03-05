//
//  ViewController.m
//  mHealthDAP
//
//  Created by bhavesh devnani on 09/11/17.
//  Copyright © 2017 bhavesh devnani. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "DateTableViewCell.h"
#import "PermissionData.h"
#import "PermissionSummaryViewController.h"
#import "CMPopTipView.h"
#import "PermissionController.h"
#import "Constants.h"

@interface ViewController ()
{
    BOOL isFiltered;
    NSMutableArray *filteredImgArray;
    NSMutableArray *finalFilteredArray;
    NSMutableArray *filteredPermissionArray;
    NSArray *imgArray;
    NSArray *imgFamilyArray;
    NSArray *titleArray;
    NSArray *titleFamilyArray;
    NSMutableArray *panelArray;
    NSMutableArray *permissionsArray;
    NSMutableArray *permissionsFamilyArray;
    NSMutableArray *csiFamilyArray;
    int selectedIndex;
    int oldSelectedIndex;
    int filteredSelectedIndex;
    NSString * selectedDate;
    NSString * selectedStartDate;
    NSString * selectedEndDate;
    NSString * searchString;
    BOOL isPanelOpened;
    NSMutableArray *finalFamilyPermissionDataArray;
}
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *doctorAndFamilyTableView;
// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (assign,nonatomic) NSInteger pickerCellRowHeight;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    self.searchBar.layer.borderWidth = 0.0;
    self.searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.searchBar.layer.cornerRadius = 0.0;
    
    self.searchBar.backgroundColor = [UIColor clearColor];
    
    _backButton.layer.cornerRadius=5.0;
    _acceptButton.layer.cornerRadius=5.0;
    UIFont *font = [UIFont fontWithName:@"Avenir Next" size:19.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [_segmentedControl setTitleTextAttributes:attributes
                                     forState:UIControlStateNormal];
    if (imgArray == nil)
    {
        imgArray=[[NSArray alloc]initWithObjects:@"Doc1",@"Doc2",@"Doc3",@"Doc5",@"Doc6",@"Doc7",@"Doc8", nil];
    }
    if (imgFamilyArray == nil)
    {
        imgFamilyArray=[[NSArray alloc]initWithObjects:@"Mother",@"Father",@"Brother",@"Sister", nil];
    }
    if (titleArray == nil)
    {
        titleArray=[[NSArray alloc]initWithObjects:@"Dr. Cardiac H. Cathy",@"Dr. Radio S. Rachel",@"Dr. Endo D. Eric",@"Dr. Primary F. Paul",@"Dr. Abdiel A. Jacobs",@"Dr. Ortho B. Otto",@"Dr. George D. Beller", nil];
    }
    if (titleFamilyArray == nil)
    {
        titleFamilyArray=[[NSArray alloc]initWithObjects:@"Worried Wendy",@"Hefty H. Harvey",@"Tricky X. Troy",@"Sports T. Susan", nil];
    }
    if ([[NSUserDefaults standardUserDefaults]valueForKey:FINALFAMILYDATAARRAY] == nil)
    {
        csiFamilyArray = [[NSMutableArray alloc]init];
    }
    else
    {
        csiFamilyArray =[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:FINALFAMILYDATAARRAY]];
    }
    finalFamilyPermissionDataArray = [[NSMutableArray alloc] init];
    
    for (int iCount=0; iCount<[csiFamilyArray count]; iCount++) {
        NSString *strData =[csiFamilyArray objectAtIndex:iCount];
        NSArray *arrData =[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
        
        // added following condition to avoid "NA" csi files
        if(![[arrData objectAtIndex:3] isEqualToString:@"NA"])
        {
            [finalFamilyPermissionDataArray addObject:strData];
        }
        
        
    }
    NSLog(@"%@",finalFamilyPermissionDataArray);
    panelArray = [[NSMutableArray alloc]init];
    if([NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"]] != nil)
    {
        permissionsArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"]];
    }
    else
    {
        permissionsArray = [[NSMutableArray alloc]init];
    }
    if([NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"]] != nil)
    {
        permissionsFamilyArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"]];
    }
    else
    {
        permissionsFamilyArray = [[NSMutableArray alloc]init];
    }
    selectedIndex = -1;
    UITableViewCell *pickerViewCellToCheck = [self.doctorAndFamilyTableView dequeueReusableCellWithIdentifier:@"datePicker"];
    self.pickerCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [[_backButton layer] setBorderWidth:1.0f];
    [[_backButton layer] setBorderColor:[UIColor colorWithRed:60.0/255.0 green:185.0/255.0 blue:200.0/255.0 alpha:1].CGColor];
    self.navigationController.navigationBar.topItem.title = @"";
    //set nav bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:15/255.00f green:105/255.00f blue:145/255.00f alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self enableBottomContainerView];
    _label.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    _label.layer.shadowOffset=CGSizeMake(0.0f, 0.0f);
    _label.layer.shadowRadius=1.5f;
    _label.layer.shadowOpacity=0.9f;
    _label.layer.masksToBounds=NO;
    UIEdgeInsets shadowInset=UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath=[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_label.bounds, shadowInset)];
    _label.layer.shadowPath=shadowPath.CGPath;
    _bottomContainerView.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    _bottomContainerView.layer.shadowOffset=CGSizeMake(0.0f, 0.0f);
    _bottomContainerView.layer.shadowRadius=2.5f;
    _bottomContainerView.layer.shadowOpacity=0.9f;
    _bottomContainerView.layer.masksToBounds=NO;
    
    UIBezierPath *shadowPath1=[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(_bottomContainerView.bounds, shadowInset)];
    _bottomContainerView.layer.shadowPath=shadowPath1.CGPath;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//
//    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view, typically from a nib.
}
//-(void)dismissKeyboard
//{
//    [self.searchBar resignFirstResponder];
//}
- (IBAction)showPopover:(id)sender {
    DebugLog(@"");
    UIBarButtonItem *barButtonItem = (UIBarButtonItem *)sender;
    NSString *contentMessage=@"Select the members and the duration for which you want to provide permissions.";
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
    popTipView.bubblePaddingY=10.0;
    popTipView.bubblePaddingX=20.0;
    popTipView.sidePadding=28.0;
    
    [popTipView presentPointingAtBarButtonItem:barButtonItem animated:NO];
    
}

- (void) viewWillAppear:(BOOL)animated {
    DebugLog(@"");
    [super viewWillAppear: animated];
    self.navigationItem.title = @"Grant Permission & Duration";
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([panelArray count] == 0)
    {
        return 71;
    }
    else
    {
        if ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row)
        {
            return self.pickerCellRowHeight;
        }
        else if(indexPath.row <= selectedIndex)
        {
            return 71;
        }
        else if(indexPath.row == selectedIndex + 1)
        {
            return 30;
        }
        else if (indexPath.row == selectedIndex + 2 || indexPath.row == selectedIndex + 3)
        {
            return 44;
        }
        else if (indexPath.row == selectedIndex + 4 && [self hasInlineDatePicker])
        {
            return 44;
        }
        else
        {
            return 71;
            
        }
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self hasInlineDatePicker])
    {
        // we have a date picker, so allow for it in the number of rows in this section
        NSInteger numRows;
        if(_segmentedControl.selectedSegmentIndex==0)
        {
            if(isFiltered)
            {
                numRows = [finalFilteredArray count] + [panelArray count];
            }
            else
            {
                numRows = [imgArray count] + [panelArray count];
            }
        }
        else
        {
            if (isFiltered)
            {
                numRows = [finalFilteredArray count] + [panelArray count];
            }
            else
            {
                numRows = [finalFamilyPermissionDataArray count] + [panelArray count];
            }
        }
        return ++numRows;
    }
    if(_segmentedControl.selectedSegmentIndex==0)
    {
        if(isFiltered)
        {
            return [finalFilteredArray count] + [panelArray count];
        }
        else
        {
            return [imgArray count] + [panelArray count];
        }
    }
    else
    {
        if(isFiltered)
        {
            return [finalFilteredArray count] + [panelArray count];
        }
        else
        {
            return [finalFamilyPermissionDataArray count] + [panelArray count];
        }
    }
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    if([panelArray count] == 0)
    {
        NSString *cellIdentifier=@"Cell";
        CustomCell *cell=(CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        [cell setSeparatorInset:UIEdgeInsetsZero];
        if(_segmentedControl.selectedSegmentIndex==0)
        {
            if(isFiltered)
            {
                cell.title.text= [finalFilteredArray objectAtIndex:indexPath.row];
                cell.image.image = [UIImage imageNamed:[filteredImgArray objectAtIndex:indexPath.row]];
                BOOL isPresent = NO;
                
                for (PermissionData *permData in filteredPermissionArray) {
                    
                    if(permData.index >= indexPath.row)
                    {
                        isPresent = YES;
                        NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                        //Create mutable string from original one
                        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                        
                        //Fing range of the string you want to change colour
                        //If you need to change colour in more that one place just repeat it
                        NSRange range = [myString rangeOfString:permData.startDate];
                        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                        NSRange range1 = [myString rangeOfString:permData.endDate];
                        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                        
                        //Add it to the label - notice its not text property but it's attributeText
                        cell.fromAndToLabel.attributedText = attString;
                        cell.checkButton.tag = indexPath.row;
                        [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = YES;
                        //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                        break;
                    }
                }
                if(!isPresent)
                {
                    cell.fromAndToLabel.text = @"";
//                    cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                    //                cell.checkButton.tag = indexPath.row;
                    [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                    cell.checkButton.userInteractionEnabled = NO;
                }
            }
            else
            {
                cell.title.text= [titleArray objectAtIndex:indexPath.row];
                cell.image.image = [UIImage imageNamed:[imgArray objectAtIndex:indexPath.row]];
                BOOL isPresent = NO;
                
                for (PermissionData *permData in permissionsArray) {
                    
                    if(permData.index == indexPath.row)
                    {
                        isPresent = YES;
                        NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                        //Create mutable string from original one
                        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                        
                        //Fing range of the string you want to change colour
                        //If you need to change colour in more that one place just repeat it
                        NSRange range = [myString rangeOfString:permData.startDate];
                        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                        NSRange range1 = [myString rangeOfString:permData.endDate];
                        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                        
                        //Add it to the label - notice its not text property but it's attributeText
                        cell.fromAndToLabel.attributedText = attString;
                        cell.checkButton.tag = indexPath.row;
                        [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = YES;
                        //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                        break;
                    }
                }
                if(!isPresent)
                {
                    cell.fromAndToLabel.text = @"";
//                    cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                    //                cell.checkButton.tag = indexPath.row;
                    [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                    cell.checkButton.userInteractionEnabled = NO;
                }
                
            }
            if([cell.title.text isEqualToString:@"Dr. Cardiac H. Cathy"])
            {
                cell.subtitle.text = @"Cardiologist, (MBBS)";
            }
            else if ([cell.title.text isEqualToString:@"Dr. Primary F. Paul"])
            {
                cell.subtitle.text = @"PCP, (MBBS)";
            }
            else if ([cell.title.text isEqualToString:@"Dr. George D. Beller"])
            {
                cell.subtitle.text = @"Dermatologist, (MBBS)";
            }
            else if ([cell.title.text isEqualToString:@"Dr. Radio S. Rachel"])
            {
                cell.subtitle.text = @"Anesthetic, (MBBS)";
            }
            else
            {
                cell.subtitle.text = @"Endocrinologist, (MBBS)";
            }
            
            
        }
        else
        {
            if(isFiltered)
            {
                cell.title.text= [finalFilteredArray objectAtIndex:indexPath.row];
                cell.image.image = [UIImage imageNamed:[filteredImgArray objectAtIndex:indexPath.row]];
                
                BOOL isPresent = NO;
                for (PermissionData *permData in filteredPermissionArray) {
                    
                    if(permData.index >= indexPath.row)
                    {
                        isPresent = YES;
                        NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                        //Create mutable string from original one
                        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                        
                        //Fing range of the string you want to change colour
                        //If you need to change colour in more that one place just repeat it
                        NSRange range = [myString rangeOfString:permData.startDate];
                        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                        NSRange range1 = [myString rangeOfString:permData.endDate];
                        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                        
                        //Add it to the label - notice its not text property but it's attributeText
                        cell.fromAndToLabel.attributedText = attString;
                        cell.checkButton.tag = indexPath.row;
                        [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = YES;
                        //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                        break;
                    }
                }
                if(!isPresent)
                {
                    cell.fromAndToLabel.text = @"";
                    //cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                    //cell.checkButton.tag = indexPath.row;
                    [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                    cell.checkButton.userInteractionEnabled = NO;
                }
            }
            else
            {
                NSString *strData =[finalFamilyPermissionDataArray objectAtIndex:indexPath.row];
                NSArray *arrData =[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
                cell.title.text= [NSString stringWithFormat:@"%@ %@",[arrData objectAtIndex:0],[arrData objectAtIndex:1]];//[titleFamilyArray objectAtIndex:indexPath.row];
                
                if(![[arrData objectAtIndex:4] isEqualToString:@"NA"])
                {
                    cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[arrData objectAtIndex:4]]];
                }
                else
                {
                    if([[arrData objectAtIndex:2] isEqualToString:@"Female"])
                    {
                        cell.image.image=[UIImage imageNamed:@"femaledefault.png"];

                    }
                    else
                    {
                        cell.image.image=[UIImage imageNamed:@"maledefault.png"];
                    }
                }
                //cell.title.text= [titleFamilyArray objectAtIndex:indexPath.row];
                //cell.image.image = [UIImage imageNamed:[imgFamilyArray objectAtIndex:indexPath.row]];
                
                
                
                BOOL isPresent = NO;
                for (PermissionData *permData in permissionsFamilyArray) {
                    
                    if(permData.index == indexPath.row)
                    {
                        isPresent = YES;
                        NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                        //Create mutable string from original one
                        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                        
                        //Fing range of the string you want to change colour
                        //If you need to change colour in more that one place just repeat it
                        NSRange range = [myString rangeOfString:permData.startDate];
                        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                        NSRange range1 = [myString rangeOfString:permData.endDate];
                        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                        
                        //Add it to the label - notice its not text property but it's attributeText
                        cell.fromAndToLabel.attributedText = attString;
                        cell.checkButton.tag = indexPath.row;
                        [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = YES;
                        //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                        break;
                    }
                }
                if(!isPresent)
                {
                    cell.fromAndToLabel.text = @"";
                    //cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                    //cell.checkButton.tag = indexPath.row;
                    [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                    cell.checkButton.userInteractionEnabled = NO;
                }
            }
            
            cell.subtitle.text = @"";
            
        }
        
        
        return cell;
    }
    else
    {
        if ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row)
        {
            NSString *cellIdentifier=@"datePicker";
            UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            return cell;
        }
        else if(indexPath.row <= selectedIndex)
        {
            NSString *cellIdentifier=@"Cell";
            CustomCell *cell=(CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if(_segmentedControl.selectedSegmentIndex==0)
            {
                if(isFiltered)
                {
                    cell.title.text= [finalFilteredArray objectAtIndex:indexPath.row];
                    cell.image.image = [UIImage imageNamed:[filteredImgArray objectAtIndex:indexPath.row]];
                    BOOL isPresent = NO;
                    
                    for (PermissionData *permData in filteredPermissionArray) {
                        
                        if(permData.index == indexPath.row)
                        {
                            isPresent = YES;
                            NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                            //Create mutable string from original one
                            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                            
                            //Fing range of the string you want to change colour
                            //If you need to change colour in more that one place just repeat it
                            NSRange range = [myString rangeOfString:permData.startDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                            NSRange range1 = [myString rangeOfString:permData.endDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                            
                            //Add it to the label - notice its not text property but it's attributeText
                            cell.fromAndToLabel.attributedText = attString;
                            cell.checkButton.tag = indexPath.row;
                            [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                            cell.checkButton.userInteractionEnabled = YES;
                            //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                            break;
                        }
                    }
                    if(!isPresent)
                    {
                        cell.fromAndToLabel.text = @"";
//                        cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                        //                cell.checkButton.tag = indexPath.row;
                        [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = NO;
                    }
                    
                }
                else
                {
                    cell.title.text= [titleArray objectAtIndex:indexPath.row];
                    cell.image.image = [UIImage imageNamed:[imgArray objectAtIndex:indexPath.row]];
                    BOOL isPresent = NO;
                    
                    for (PermissionData *permData in permissionsArray) {
                        
                        if(permData.index == indexPath.row)
                        {
                            isPresent = YES;
                            NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                            //Create mutable string from original one
                            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                            
                            //Fing range of the string you want to change colour
                            //If you need to change colour in more that one place just repeat it
                            NSRange range = [myString rangeOfString:permData.startDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                            NSRange range1 = [myString rangeOfString:permData.endDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                            
                            //Add it to the label - notice its not text property but it's attributeText
                            cell.fromAndToLabel.attributedText = attString;
                            cell.checkButton.tag = indexPath.row;
                            [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                            cell.checkButton.userInteractionEnabled = YES;
                            //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                            break;
                        }
                    }
                    if(!isPresent)
                    {
                        cell.fromAndToLabel.text = @"";
//                        cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                        //                cell.checkButton.tag = indexPath.row;
                        [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = NO;
                    }
                    
                }
                if([cell.title.text isEqualToString:@"Dr. Cardiac H. Cathy"])
                {
                    cell.subtitle.text = @"Cardiologist, (MBBS)";
                }
                else if ([cell.title.text isEqualToString:@"Dr. Primary F. Paul"])
                {
                    cell.subtitle.text = @"PCP, (MBBS)";
                }
                else if ([cell.title.text isEqualToString:@"Dr. George D. Beller"])
                {
                    cell.subtitle.text = @"Dermatologist, (MBBS)";
                }
                else if ([cell.title.text isEqualToString:@"Dr. Radio S. Rachel"])
                {
                    cell.subtitle.text = @"Anesthetic, (MBBS)";
                }
                else
                {
                    cell.subtitle.text = @"Endocrinologist, (MBBS)";
                }
                
            }
            else
            {
                if(isFiltered)
                {
                    cell.title.text= [finalFilteredArray objectAtIndex:indexPath.row];
                    cell.image.image = [UIImage imageNamed:[filteredImgArray objectAtIndex:indexPath.row]];
                    
                    BOOL isPresent = NO;
                    for (PermissionData *permData in filteredPermissionArray) {
                        
                        if(permData.index == indexPath.row)
                        {
                            isPresent = YES;
                            NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                            //Create mutable string from original one
                            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                            
                            //Fing range of the string you want to change colour
                            //If you need to change colour in more that one place just repeat it
                            NSRange range = [myString rangeOfString:permData.startDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                            NSRange range1 = [myString rangeOfString:permData.endDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                            
                            //Add it to the label - notice its not text property but it's attributeText
                            cell.fromAndToLabel.attributedText = attString;
                            cell.checkButton.tag = indexPath.row;
                            [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                            cell.checkButton.userInteractionEnabled = YES;
                            //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                            break;
                        }
                    }
                    if(!isPresent)
                    {
                        cell.fromAndToLabel.text = @"";
                        //cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                        //cell.checkButton.tag = indexPath.row;
                        [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = NO;
                    }
                }
                else
                {
                    NSString *strData =[finalFamilyPermissionDataArray objectAtIndex:indexPath.row];
                    NSArray *arrData =[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
                    cell.title.text= [NSString stringWithFormat:@"%@ %@",[arrData objectAtIndex:0],[arrData objectAtIndex:1]];//[titleFamilyArray objectAtIndex:indexPath.row];
                    
                    if(![[arrData objectAtIndex:4] isEqualToString:@"NA"])
                    {
                        cell.image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[arrData objectAtIndex:4]]];
                    }
                    else
                    {
                        if([[arrData objectAtIndex:2] isEqualToString:@"Female"])
                        {
                            cell.image.image=[UIImage imageNamed:@"femaledefault.png"];
                            
                        }
                        else
                        {
                            cell.image.image=[UIImage imageNamed:@"maledefault.png"];
                        }
                    }
                    //cell.title.text= [titleFamilyArray objectAtIndex:indexPath.row];
                   // cell.image.image = [UIImage imageNamed:[imgFamilyArray objectAtIndex:indexPath.row]];
                    
                    
                    BOOL isPresent = NO;
                    for (PermissionData *permData in permissionsFamilyArray) {
                        
                        if(permData.index == indexPath.row)
                        {
                            isPresent = YES;
                            NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                            //Create mutable string from original one
                            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                            
                            //Fing range of the string you want to change colour
                            //If you need to change colour in more that one place just repeat it
                            NSRange range = [myString rangeOfString:permData.startDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                            NSRange range1 = [myString rangeOfString:permData.endDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                            
                            //Add it to the label - notice its not text property but it's attributeText
                            cell.fromAndToLabel.attributedText = attString;
                            cell.checkButton.tag = indexPath.row;
                            [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                            cell.checkButton.userInteractionEnabled = YES;
                            //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                            break;
                        }
                    }
                    if(!isPresent)
                    {
                        cell.fromAndToLabel.text = @"";
                        //cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                        //cell.checkButton.tag = indexPath.row;
                        [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = NO;
                    }
                }
                
                cell.subtitle.text = @"";
            }
            return cell;
        }
        else if(indexPath.row == selectedIndex + 1)
        {
            NSString *cellIdentifier=@"permissionCell";
            UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            return cell;
        }
        else if (indexPath.row == selectedIndex + 2 || indexPath.row == selectedIndex + 3)
        {
            NSString *cellIdentifier=@"dateCell";
            DateTableViewCell *cell=(DateTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if(indexPath.row == selectedIndex + 2)
            {
                cell.title.text = @"From Date";
                if(_segmentedControl.selectedSegmentIndex==0)
                {
                    if(isFiltered)
                    {
                        BOOL isPresent = NO;
                        //permissionsArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"];
                        
                        for (PermissionData *permData in filteredPermissionArray) {
                            if (permData.index == filteredSelectedIndex)
                            {
                                if([permData.startDate isEqualToString:@""])
                                {
                                    cell.detailLabel.text = @"Select";
                                }
                                else
                                {
                                    isPresent = YES;
                                    cell.detailLabel.text = permData.startDate;
                                    break;
                                }
                            }
                        }
                        if(!isPresent)
                        {
                            if(selectedStartDate == nil)
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                cell.detailLabel.text = selectedStartDate;
                            }
                        }
                    }
                    else
                    {
                        BOOL isPresent = NO;
                        //permissionsArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"];
                    
                        for (PermissionData *permData in permissionsArray) {
                            if (permData.index == selectedIndex)
                            {
                                if([permData.startDate isEqualToString:@""])
                                {
                                    cell.detailLabel.text = @"Select";
                                }
                                else
                                {
                                    isPresent = YES;
                                    cell.detailLabel.text = permData.startDate;
                                    break;
                                }
                            }
                        }
                        if(!isPresent)
                        {
                            if(selectedStartDate == nil)
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                cell.detailLabel.text = selectedStartDate;
                            }
                        }
                    }
                }
                else
                {
                    if(isFiltered)
                    {
                        BOOL isPresent = NO;
                        //permissionsFamilyArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"];
                        
                        for (PermissionData *permData in filteredPermissionArray) {
                            if (permData.index == filteredSelectedIndex)
                            {
                                if([permData.startDate isEqualToString:@""])
                                {
                                    cell.detailLabel.text = @"Select";
                                }
                                else
                                {
                                    isPresent = YES;
                                    cell.detailLabel.text = permData.startDate;
                                    break;
                                }
                            }
                        }
                        if(!isPresent)
                        {
                            if(selectedStartDate == nil)
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                cell.detailLabel.text = selectedStartDate;
                            }
                        }
                    }
                    else
                    {
                        BOOL isPresent = NO;
                        //permissionsFamilyArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"];
                    
                        for (PermissionData *permData in permissionsFamilyArray) {
                            if (permData.index == selectedIndex)
                            {
                                if([permData.startDate isEqualToString:@""])
                                {
                                    cell.detailLabel.text = @"Select";
                                }
                                else
                                {
                                    isPresent = YES;
                                    cell.detailLabel.text = permData.startDate;
                                    break;
                                }
                            }
                        }
                        if(!isPresent)
                        {
                            if(selectedStartDate == nil)
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                cell.detailLabel.text = selectedStartDate;
                            }
                        }
                    }
                }
            }
            else
            {
                cell.title.text = @"To Date";
                if(_segmentedControl.selectedSegmentIndex==0)
                {
                    if(isFiltered)
                    {
                        BOOL isPresent = NO;
                        // permissionsArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"];
                        
                        for (PermissionData *permData in filteredPermissionArray) {
                            if (permData.index == filteredSelectedIndex)
                            {
                                if([permData.startDate isEqualToString:@""])
                                {
                                    cell.detailLabel.text = @"Select";
                                }
                                else
                                {
                                    isPresent = YES;
                                    cell.detailLabel.text = permData.endDate;
                                    break;
                                }
                            }
                        }
                        if(!isPresent)
                        {
                            if(selectedEndDate == nil)
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                cell.detailLabel.text = selectedEndDate;
                            }
                        }
                    }
                    else
                    {
                        BOOL isPresent = NO;
                        // permissionsArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"];
                    
                        for (PermissionData *permData in permissionsArray) {
                            if (permData.index == selectedIndex)
                            {
                                if([permData.startDate isEqualToString:@""])
                                {
                                    cell.detailLabel.text = @"Select";
                                }
                                else
                                {
                                    isPresent = YES;
                                    cell.detailLabel.text = permData.endDate;
                                    break;
                                }
                            }
                        }
                        if(!isPresent)
                        {
                            if(selectedEndDate == nil)
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                cell.detailLabel.text = selectedEndDate;
                            }
                        }
                    }
                }
                else
                {
                    if(isFiltered)
                    {
                        BOOL isPresent = NO;
                        //permissionsFamilyArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"];
                        
                        for (PermissionData *permData in filteredPermissionArray) {
                            if (permData.index == filteredSelectedIndex)
                            {
                                if([permData.startDate isEqualToString:@""])
                                {
                                    cell.detailLabel.text = @"Select";
                                }
                                else
                                {
                                    isPresent = YES;
                                    cell.detailLabel.text = permData.endDate;
                                    break;
                                }
                            }
                        }
                        if(!isPresent)
                        {
                            if(!isPresent)
                            {
                                if(selectedEndDate == nil)
                                {
                                    cell.detailLabel.text = @"Select";
                                }
                                else
                                {
                                    cell.detailLabel.text = selectedEndDate;
                                }
                            }
                        }
                    }
                    else
                    {
                        BOOL isPresent = NO;
                        //permissionsFamilyArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"];
                    
                        for (PermissionData *permData in permissionsFamilyArray) {
                            if (permData.index == selectedIndex)
                            {
                                if([permData.startDate isEqualToString:@""])
                                {
                                    cell.detailLabel.text = @"Select";
                                }
                                else
                                {
                                    isPresent = YES;
                                    cell.detailLabel.text = permData.endDate;
                                    break;
                                }
                            }
                        }
                        if(!isPresent)
                        {
                            if(!isPresent)
                            {
                                if(selectedEndDate == nil)
                                {
                                    cell.detailLabel.text = @"Select";
                                }
                                else
                                {
                                    cell.detailLabel.text = selectedEndDate;
                                }
                            }
                        }
                    }
                }
            }
            
            
            return cell;
        }
        else if ([self hasInlineDatePicker] && selectedIndex + 4 == indexPath.row)
        {
            NSString *cellIdentifier=@"dateCell";
            DateTableViewCell *cell=(DateTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            cell.title.text = @"To Date";
            if(_segmentedControl.selectedSegmentIndex==0)
            {
                if(isFiltered)
                {
                    BOOL isPresent = NO;
                    //permissionsFamilyArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"];
                    
                    for (PermissionData *permData in filteredPermissionArray) {
                        if (permData.index == filteredSelectedIndex)
                        {
                            if([permData.startDate isEqualToString:@""])
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                isPresent = YES;
                                cell.detailLabel.text = permData.endDate;
                                break;
                            }
                        }
                    }
                    if(!isPresent)
                    {
                        if(!isPresent)
                        {
                            if(selectedEndDate == nil)
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                cell.detailLabel.text = selectedEndDate;
                            }
                        }
                    }
                }
                else
                {
                    BOOL isPresent = NO;
                    // permissionsArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"];
                
                    for (PermissionData *permData in permissionsArray) {
                        if (permData.index == selectedIndex)
                        {
                            if([permData.startDate isEqualToString:@""])
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                isPresent = YES;
                                cell.detailLabel.text = permData.endDate;
                                break;
                            }
                        }
                    }
                    if(!isPresent)
                    {
                        if(selectedEndDate == nil)
                        {
                            cell.detailLabel.text = @"Select";
                        }
                        else
                        {
                            cell.detailLabel.text = selectedEndDate;
                        }
                    }
                }
            }
            else
            {
                if(isFiltered)
                {
                    BOOL isPresent = NO;
                    //permissionsFamilyArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"];
                    
                    for (PermissionData *permData in filteredPermissionArray) {
                        if (permData.index == filteredSelectedIndex)
                        {
                            if([permData.startDate isEqualToString:@""])
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                isPresent = YES;
                                cell.detailLabel.text = permData.endDate;
                                break;
                            }
                        }
                    }
                    if(!isPresent)
                    {
                        if(!isPresent)
                        {
                            if(selectedEndDate == nil)
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                cell.detailLabel.text = selectedEndDate;
                            }
                        }
                    }
                }
                else
                {
                    BOOL isPresent = NO;
                    //permissionsFamilyArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"];
                
                    for (PermissionData *permData in permissionsFamilyArray) {
                        if (permData.index == selectedIndex)
                        {
                            if([permData.startDate isEqualToString:@""])
                            {
                                cell.detailLabel.text = @"Select";
                            }
                            else
                            {
                                isPresent = YES;
                                cell.detailLabel.text = permData.endDate;
                                break;
                            }
                        }
                    }
                    if(!isPresent)
                    {
                        if(selectedEndDate == nil)
                        {
                            cell.detailLabel.text = @"Select";
                        }
                        else
                        {
                            cell.detailLabel.text = selectedEndDate;
                        }
                    }
                }
            }
            return cell;
        }
        else
        {
            NSString *cellIdentifier=@"Cell";
            CustomCell *cell=(CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            [cell setSeparatorInset:UIEdgeInsetsZero];
            if(_segmentedControl.selectedSegmentIndex==0)
            {
                if ([self hasInlineDatePicker])
                {
                    if(isFiltered)
                    {
                        cell.title.text= [finalFilteredArray objectAtIndex:indexPath.row - 4];
                        cell.image.image = [UIImage imageNamed:[filteredImgArray objectAtIndex:indexPath.row - 4]];
                    }
                    else
                    {
                        cell.title.text= [titleArray objectAtIndex:indexPath.row - 4];
                        cell.image.image = [UIImage imageNamed:[imgArray objectAtIndex:indexPath.row - 4]];
                    }
                }
                else
                {
                    if(isFiltered)
                    {
                        cell.title.text= [finalFilteredArray objectAtIndex:indexPath.row - 3];
                        cell.image.image = [UIImage imageNamed:[filteredImgArray objectAtIndex:indexPath.row - 3]];
                    }
                    else
                    {
                        cell.title.text= [titleArray objectAtIndex:indexPath.row - 3];
                        cell.image.image = [UIImage imageNamed:[imgArray objectAtIndex:indexPath.row - 3]];
                    }
                }
                if([cell.title.text isEqualToString:@"Dr. Cardiac H. Cathy"])
                {
                    cell.subtitle.text = @"Cardiologist, (MBBS)";
                }
                else if ([cell.title.text isEqualToString:@"Dr. Primary F. Paul"])
                {
                    cell.subtitle.text = @"PCP, (MBBS)";
                }
                else if ([cell.title.text isEqualToString:@"Dr. George D. Beller"])
                {
                    cell.subtitle.text = @"Dermatologist, (MBBS)";
                }
                else if ([cell.title.text isEqualToString:@"Dr. Radio S. Rachel"])
                {
                    cell.subtitle.text = @"Anesthetic, (MBBS)";
                }
                else
                {
                    cell.subtitle.text = @"Endocrinologist, (MBBS)";
                }
                BOOL isPresent = NO;
                int compareValue;
                //permissionsArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionArray"];
                if(isFiltered)
                {
                    for (PermissionData *permData in filteredPermissionArray) {
                        
                        if ([self hasInlineDatePicker])
                        {
                            compareValue = (int)indexPath.row - 4;
                        }
                        else
                        {
                            compareValue = (int)indexPath.row - 3;
                        }
                        if(permData.index == compareValue)
                        {
                            isPresent = YES;
                            NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                            //Create mutable string from original one
                            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                            
                            //Fing range of the string you want to change colour
                            //If you need to change colour in more that one place just repeat it
                            NSRange range = [myString rangeOfString:permData.startDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                            NSRange range1 = [myString rangeOfString:permData.endDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                            
                            //Add it to the label - notice its not text property but it's attributeText
                            cell.fromAndToLabel.attributedText = attString;
                            cell.checkButton.tag = compareValue;
                            [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                            cell.checkButton.userInteractionEnabled = YES;
                            //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                            break;
                        }
                    }
                    if(!isPresent)
                    {
                        cell.fromAndToLabel.text = @"";
                        //cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                        
                        [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = NO;
                    }
                    
                }
                else
                {
                    for (PermissionData *permData in permissionsArray) {
                        
                        if ([self hasInlineDatePicker])
                        {
                            compareValue = (int)indexPath.row - 4;
                        }
                        else
                        {
                            compareValue = (int)indexPath.row - 3;
                        }
                        if(permData.index == compareValue)
                        {
                            isPresent = YES;
                            NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                            //Create mutable string from original one
                            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                            
                            //Fing range of the string you want to change colour
                            //If you need to change colour in more that one place just repeat it
                            NSRange range = [myString rangeOfString:permData.startDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                            NSRange range1 = [myString rangeOfString:permData.endDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                            
                            //Add it to the label - notice its not text property but it's attributeText
                            cell.fromAndToLabel.attributedText = attString;
                            cell.checkButton.tag = compareValue;
                            [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                            cell.checkButton.userInteractionEnabled = YES;
                            //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                            break;
                        }
                    }
                    if(!isPresent)
                    {
                        cell.fromAndToLabel.text = @"";
                        //cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                        
                        [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = NO;
                    }
                }
            }
            else
            {
                if ([self hasInlineDatePicker])
                {
                    if(isFiltered)
                    {
                        cell.title.text= [finalFilteredArray objectAtIndex:indexPath.row - 4];
                        cell.image.image = [UIImage imageNamed:[filteredImgArray objectAtIndex:indexPath.row - 4]];
                    }
                    else
                    {
                        cell.title.text= [titleFamilyArray objectAtIndex:indexPath.row - 4];
                        cell.image.image = [UIImage imageNamed:[imgFamilyArray objectAtIndex:indexPath.row - 4]];
                    }
                }
                else
                {
                    if(isFiltered)
                    {
                        cell.title.text= [finalFilteredArray objectAtIndex:indexPath.row - 3];
                        cell.image.image = [UIImage imageNamed:[filteredImgArray objectAtIndex:indexPath.row - 3]];
                    }
                    else
                    {
                        cell.title.text= [titleFamilyArray objectAtIndex:indexPath.row - 3];
                        cell.image.image = [UIImage imageNamed:[imgFamilyArray objectAtIndex:indexPath.row - 3]];
                    }
                    
                }
                cell.subtitle.text = @"";
                BOOL isPresent = NO;
                int compareValue;
                //permissionsFamilyArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"PermissionFamilyArray"];
                if(isFiltered)
                {
                    for (PermissionData *permData in filteredPermissionArray) {
                        
                        if ([self hasInlineDatePicker])
                        {
                            compareValue = (int)indexPath.row - 4;
                        }
                        else
                        {
                            compareValue = (int)indexPath.row - 3;
                        }
                        if(permData.index == compareValue)
                        {
                            isPresent = YES;
                            NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                            //Create mutable string from original one
                            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                            
                            //Fing range of the string you want to change colour
                            //If you need to change colour in more that one place just repeat it
                            NSRange range = [myString rangeOfString:permData.startDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                            NSRange range1 = [myString rangeOfString:permData.endDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                            
                            //Add it to the label - notice its not text property but it's attributeText
                            cell.fromAndToLabel.attributedText = attString;
                            cell.checkButton.tag = compareValue;
                            [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                            cell.checkButton.userInteractionEnabled = YES;
                            //cell.checkImage.image = [UIImage imageNamed:@"Check"];
                            break;
                        }
                    }
                    if(!isPresent)
                    {
                        cell.fromAndToLabel.text = @"";
                        //cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                        
                        [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = NO;
                    }
                    
                }
                else
                {
                    for (PermissionData *permData in permissionsFamilyArray) {
                        if ([self hasInlineDatePicker])
                        {
                            compareValue = (int)indexPath.row - 4;
                        }
                        else
                        {
                            compareValue = (int)indexPath.row - 3;
                        }
                        if(permData.index == compareValue)
                        {
                            isPresent = YES;
                            NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
                            //Create mutable string from original one
                            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
                            
                            //Fing range of the string you want to change colour
                            //If you need to change colour in more that one place just repeat it
                            NSRange range = [myString rangeOfString:permData.startDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
                            NSRange range1 = [myString rangeOfString:permData.endDate];
                            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
                            
                            //Add it to the label - notice its not text property but it's attributeText
                            cell.fromAndToLabel.attributedText = attString;
                            cell.checkButton.tag = compareValue;
                            [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
                            cell.checkButton.userInteractionEnabled = YES;
                            // cell.checkImage.image = [UIImage imageNamed:@"Check"];
                            break;
                        }
                    }
                    if(!isPresent)
                    {
                        cell.fromAndToLabel.text = @"";
                        //cell.checkImage.image = [UIImage imageNamed:@"uncheck"];
                        [cell.checkButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
                        cell.checkButton.userInteractionEnabled = NO;
                    }
                }
                
            }
            return cell;
            
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString: @"Cell"])
    {
        oldSelectedIndex = selectedIndex;
        selectedIndex = (int)indexPath.row;
         [self.searchBar resignFirstResponder];
        if(isFiltered)
        {
            //[self.searchBar resignFirstResponder];
            CustomCell *cell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:indexPath];
            if (_segmentedControl.selectedSegmentIndex == 0) {
                filteredSelectedIndex = (int)[titleArray indexOfObject:cell.title.text];
            }
            else
            {
                filteredSelectedIndex = (int)[titleFamilyArray indexOfObject:cell.title.text];
            }
        }
        [self showPermissionPanelForRowAtIndexPath:indexPath];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    else if ([cell.reuseIdentifier isEqualToString: @"dateCell"])
    {
        [self.searchBar resignFirstResponder];
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    else
    {
        [self.searchBar resignFirstResponder];
        //        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    
}

- (BOOL)hasInlineDatePicker
{
    DebugLog(@"");
    return (self.datePickerIndexPath != nil);
}

- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    selectedDate = nil;
    // display the date picker inline with the table content
    [self.doctorAndFamilyTableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.doctorAndFamilyTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                                             withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
        //
    }
    
    // always deselect the row containing the start or end date
    [self.doctorAndFamilyTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.doctorAndFamilyTableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

-(void)showPermissionPanelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    selectedDate = nil;
    selectedEndDate = nil;
    selectedStartDate = nil;
    NSMutableArray *deleteIndexPaths;
    //            if([self hasInlineDatePicker])
    //            {
    if([panelArray count] > 0)
    {
        [panelArray removeAllObjects];
        
        deleteIndexPaths = [NSMutableArray arrayWithObjects:
                            [NSIndexPath indexPathForRow:oldSelectedIndex + 1 inSection:0],
                            [NSIndexPath indexPathForRow:oldSelectedIndex + 2 inSection:0],
                            [NSIndexPath indexPathForRow:oldSelectedIndex + 3 inSection:0],
                            nil];
        if ([self hasInlineDatePicker])
        {
            [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:oldSelectedIndex + 4 inSection:0]];
        }
        if(oldSelectedIndex < selectedIndex)
        {   if ([self hasInlineDatePicker])
        {
            selectedIndex = selectedIndex - 4;
            self.datePickerIndexPath = nil;
        }
        else
        {
            selectedIndex = selectedIndex - 3;
        }
        }
        else
        {
            if ([self hasInlineDatePicker])
            {
                self.datePickerIndexPath = nil;
            }
        }
    }
    [panelArray insertObject:@"permission" atIndex:0];
    [panelArray insertObject:@"dateCell" atIndex:1];
    [panelArray insertObject:@"dateCell" atIndex:2];
    
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:selectedIndex + 1 inSection:0],
                                 [NSIndexPath indexPathForRow:selectedIndex + 2 inSection:0],
                                 [NSIndexPath indexPathForRow:selectedIndex + 3 inSection:0],
                                 nil];
    [self.doctorAndFamilyTableView beginUpdates];
    [self.doctorAndFamilyTableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    
    [self.doctorAndFamilyTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.doctorAndFamilyTableView endUpdates];
    
}

- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    [self.doctorAndFamilyTableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.doctorAndFamilyTableView deleteRowsAtIndexPaths:indexPaths
                                             withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.doctorAndFamilyTableView insertRowsAtIndexPaths:indexPaths
                                             withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.doctorAndFamilyTableView endUpdates];
}

- (void)updateDatePicker
{
    DebugLog(@"");
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:99];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            if(_segmentedControl.selectedSegmentIndex==0)
            {
                BOOL isPresent = NO;
                for (PermissionData *permData in permissionsArray) {
                    if (permData.index == selectedIndex)
                    {
                        isPresent = YES;
                        if([permData.startDate isEqualToString:@""] && [permData.endDate isEqualToString:@""])
                        {
                            [targetedDatePicker setDate:[NSDate date] animated:NO];
                        }
                        else
                        {
                            NSIndexPath *fromCellIndexPath = nil;
                            fromCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 2 inSection:0];
                            if ([[self.doctorAndFamilyTableView cellForRowAtIndexPath:fromCellIndexPath] isKindOfClass:[DateTableViewCell class] ])
                            {
                                [targetedDatePicker setDate:[self.dateFormatter dateFromString:permData.endDate] animated:NO];
                            }
                            else
                            {
                                [targetedDatePicker setDate:[self.dateFormatter dateFromString:permData.startDate] animated:NO];
                            }
                            
                        }
                    }
                }
                if(!isPresent)
                {
                    [targetedDatePicker setDate:[NSDate date] animated:NO];
                }
            }
            else
            {
                BOOL isPresent = NO;
                for (PermissionData *permData in permissionsFamilyArray) {
                    if (permData.index == selectedIndex)
                    {
                        isPresent = YES;
                        if([permData.startDate isEqualToString:@""] && [permData.endDate isEqualToString:@""])
                        {
                            [targetedDatePicker setDate:[NSDate date] animated:NO];
                        }
                        else
                        {
                            NSIndexPath *fromCellIndexPath = nil;
                            fromCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 2 inSection:0];
                            if ([[self.doctorAndFamilyTableView cellForRowAtIndexPath:fromCellIndexPath] isKindOfClass:[DateTableViewCell class] ])
                            {
                                [targetedDatePicker setDate:[self.dateFormatter dateFromString:permData.endDate] animated:NO];
                            }
                            else
                            {
                                [targetedDatePicker setDate:[self.dateFormatter dateFromString:permData.startDate] animated:NO];
                            }
                            
                        }
                    }
                }
                if(!isPresent)
                {
                    [targetedDatePicker setDate:[NSDate date] animated:NO];
                }
            }
        }
    }
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.doctorAndFamilyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:99];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateAction:(id)sender
{
    DebugLog(@"");
    NSIndexPath *targetedCellIndexPath = nil;
    
    //    if ([self hasInlineDatePicker])
    //    {
    // inline date picker: update the cell's date "above" the date picker cell
    //
    targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    //    }
    //    else
    //    {
    //        // external date picker: update the current "selected" cell's date
    //        targetedCellIndexPath = [self.doctorAndFamilyTableView indexPathForSelectedRow];
    //    }
    
    // DateTableViewCell *cell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    //    NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
    //    [itemData setValue:targetedDatePicker.date forKey:kDateKey];
    
    // update the cell's date string
    //cell.detailLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    if(selectedDate!= nil)
    {
        NSIndexPath *fromCellIndexPath = nil;
        fromCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 2 inSection:0];
    }
    selectedDate = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    DebugLog(@"");
    searchString = searchText;
    if(searchText.length==0)
    {
        isFiltered=NO;
    }
    else{
        isFiltered=YES;
        finalFilteredArray=[[NSMutableArray alloc]init];
        filteredImgArray=[[NSMutableArray alloc]init];
        filteredPermissionArray=[[NSMutableArray alloc]init];
        if(_segmentedControl.selectedSegmentIndex == 0)
        {
            for (int i=0; i< [titleArray count]; i++) {
                NSRange range=[titleArray[i] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location!=NSNotFound)
                {
                    [finalFilteredArray addObject:titleArray[i]];
                    [filteredImgArray addObject:imgArray[i]];
                    
                    for (PermissionData *permData in permissionsArray) {
                        if(permData.index == i)
                        {
                            [filteredPermissionArray addObject:permData];
                            break;
                        }
                    }
                }
            }
        }
        else
        {
            if([csiFamilyArray count] == 0)
            {
                return;
            }
            for (int i=0; i< [titleFamilyArray count]; i++) {
                NSRange range=[titleFamilyArray[i] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if(range.location!=NSNotFound)
                {
                    [finalFilteredArray addObject:titleFamilyArray[i]];
                    [filteredImgArray addObject:imgFamilyArray[i]];
                    for (PermissionData *permData in permissionsFamilyArray) {
                        if(permData.index == i)
                        {
                            [filteredPermissionArray addObject:permData];
                            break;
                        }
                    }
                }
            }
        }
        if([panelArray count] > 0)
        {
            [panelArray removeAllObjects];
            if ([self hasInlineDatePicker])
            {
                self.datePickerIndexPath = nil;
            }
        }
    }
    
    [_doctorAndFamilyTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    DebugLog(@"");
    [searchBar resignFirstResponder];
}

- (IBAction)doneButtonTapped:(id)sender {
    DebugLog(@"");
    PermissionData * permissionData = [[PermissionData alloc]init];
    if(isFiltered)
    {
        permissionData.index = filteredSelectedIndex;
    }
    else
    {
        permissionData.index = selectedIndex;
    }
    NSIndexPath *targetedCellIndexPath = nil;
    targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];//    }
    DateTableViewCell *cell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:targetedCellIndexPath];
    
    if(selectedDate == nil)
    {
        cell.detailLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
        selectedDate = cell.detailLabel.text;
    }
    else
    {
        cell.detailLabel.text = selectedDate;
    }
    BOOL fromCellSelected = NO;
    BOOL toCellSelected = NO;
    BOOL isChecked;
    NSIndexPath *fromCellIndexPath = nil;
    fromCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 2 inSection:0];
    if ([[self.doctorAndFamilyTableView cellForRowAtIndexPath:fromCellIndexPath] isKindOfClass:[DateTableViewCell class] ]) {
        selectedEndDate = selectedDate;
        DateTableViewCell *fromCell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:fromCellIndexPath];
        if(![fromCell.detailLabel.text isEqualToString:@"Select"])
        {
            fromCellSelected = YES;
            permissionData.startDate = fromCell.detailLabel.text;
            permissionData.endDate = cell.detailLabel.text;
            if([[self.dateFormatter dateFromString:permissionData.startDate] compare:[self.dateFormatter dateFromString:permissionData.endDate]] == NSOrderedDescending )
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                               message:@"From Date cannot be greater than To Date!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      }];
                
                [alert addAction:firstAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            if([[self.dateFormatter dateFromString:permissionData.startDate] compare:[self.dateFormatter dateFromString:permissionData.endDate]] == NSOrderedSame )
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                               message:@"From Date cannot be equal to the To Date!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      }];
                
                [alert addAction:firstAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
        }
    }
    
    NSIndexPath *toCellIndexPath = nil;
    toCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row + 1 inSection:0];
    if ([[self.doctorAndFamilyTableView cellForRowAtIndexPath:toCellIndexPath] isKindOfClass:[DateTableViewCell class] ]) {
        DateTableViewCell *toCell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:toCellIndexPath];
        selectedStartDate = selectedDate;
        if(![toCell.detailLabel.text isEqualToString:@"Select"])
        {
            toCellSelected = YES;
            permissionData.endDate = toCell.detailLabel.text;
            permissionData.startDate = cell.detailLabel.text;
            if([[self.dateFormatter dateFromString:permissionData.startDate] compare:[self.dateFormatter dateFromString:permissionData.endDate]] == NSOrderedDescending)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                               message:@"From Date cannot be greater than To Date!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      }];
                
                [alert addAction:firstAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            if([[self.dateFormatter dateFromString:permissionData.startDate] compare:[self.dateFormatter dateFromString:permissionData.endDate]] == NSOrderedSame )
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                               message:@"From Date cannot be equal to the To Date!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      }];
                
                [alert addAction:firstAction];
                [self presentViewController:alert animated:YES completion:nil];
                return;
            }
            
        }
    }
    
    if([[self.doctorAndFamilyTableView cellForRowAtIndexPath:fromCellIndexPath] isKindOfClass:[DateTableViewCell class] ])
    {
        isChecked = fromCellSelected;
    }
    else
    {
        selectedStartDate = selectedDate;
        isChecked = toCellSelected;
    }
    permissionData.checked = isChecked;
    
    BOOL isPresent = NO;
    if(_segmentedControl.selectedSegmentIndex==0)
    {
        permissionData.firstName=@"";
        permissionData.LastName=@"";
        NSMutableArray *permissionCopyArray = [permissionsArray mutableCopy];
        for (PermissionData* permData in permissionCopyArray) {
            if (permData.index == permissionData.index) {
                NSLog(@"%@",[finalFamilyPermissionDataArray objectAtIndex:permissionData.index]);
                isPresent = YES;
                permissionData.userType=PROVIDER;
                [permissionsArray removeObject:permData];
                [permissionsArray addObject:permissionData];
                break;
            }
            
            //        }
        }
        if(!isPresent && isChecked)
        {
            permissionData.userType=PROVIDER;
            [permissionsArray addObject:permissionData];
            [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:permissionsArray]forKey:@"PermissionArray"];
        }
    }
    else
    {
        NSMutableArray *permissionCopyArray = [permissionsFamilyArray mutableCopy];
        for (PermissionData* permData in permissionCopyArray) {
            if (permData.index == permissionData.index) {
                NSLog(@"%@",[finalFamilyPermissionDataArray objectAtIndex:permissionData.index]);
                NSString *strData=finalFamilyPermissionDataArray[permissionData.index];
                NSArray *arrData=[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
                permissionData.firstName=arrData[0];
                permissionData.LastName=arrData[1];
               
                isPresent = YES;
                permissionData.userType=CAREGIVER;
                [permissionsFamilyArray removeObject:permData];
                [permissionsFamilyArray addObject:permissionData];
                break;
            }
            
            //        }
        }
        if(!isPresent && isChecked)
        {
            NSString *strData=finalFamilyPermissionDataArray[permissionData.index];
            NSArray *arrData=[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
            permissionData.firstName=arrData[0];
            permissionData.LastName=arrData[1];
            
            permissionData.userType=CAREGIVER;
            [permissionsFamilyArray addObject:permissionData];
            [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:permissionsFamilyArray] forKey:@"PermissionFamilyArray"];
        }
    }
    if(isChecked)
    {
        [self hidePermissionPanelForRowAtIndexPathWithPermissionData:permissionData];
    }
    else
    {
        [self removeInlinePicker];
    }
    //    if(isChecked && [permissionsArray count] == 0)
    //    {
    //        [permissionsArray addObject:permissionData];
    //    }
    
}
- (IBAction)cancelButtonTapped:(id)sender {
    DebugLog(@"");
    [self.doctorAndFamilyTableView beginUpdates];
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.doctorAndFamilyTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    [self.doctorAndFamilyTableView endUpdates];
}

-(void)hidePermissionPanelForRowAtIndexPathWithPermissionData:(PermissionData*)permData
{
    DebugLog(@"");
    [panelArray removeAllObjects];
    NSMutableArray *deleteIndexPaths;
    deleteIndexPaths = [NSMutableArray arrayWithObjects:
                        [NSIndexPath indexPathForRow:selectedIndex + 1 inSection:0],
                        [NSIndexPath indexPathForRow:selectedIndex + 2 inSection:0],
                        [NSIndexPath indexPathForRow:selectedIndex + 3 inSection:0],
                        [NSIndexPath indexPathForRow:selectedIndex + 4 inSection:0],
                        nil];
    self.datePickerIndexPath = nil;
    [self.doctorAndFamilyTableView beginUpdates];
    [self.doctorAndFamilyTableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [self.doctorAndFamilyTableView endUpdates];
    
    NSIndexPath *selectedCellIndexPath = nil;
    selectedCellIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    CustomCell *cell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:selectedCellIndexPath];
    // cell.checkImage.image = [UIImage imageNamed:@"Check"];
    [cell.checkButton setImage:[UIImage imageNamed:@"Check"] forState:UIControlStateNormal];
    cell.checkButton.userInteractionEnabled = YES;
    NSString *myString = [NSString stringWithFormat:@"From: %@  To: %@",permData.startDate,permData.endDate];
    //Create mutable string from original one
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
    
    //Fing range of the string you want to change colour
    //If you need to change colour in more that one place just repeat it
    NSRange range = [myString rangeOfString:permData.startDate];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range];
    NSRange range1 = [myString rangeOfString:permData.endDate];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:93.0/255.0 green:188.0/255.0 blue:210.0/255.0 alpha:1] range:range1];
    
    //Add it to the label - notice its not text property but it's attributeText
    cell.fromAndToLabel.attributedText = attString;
    [self enableBottomContainerView];
}

-(void)enableBottomContainerView
{
    DebugLog(@"");
    if([permissionsArray count] + [permissionsFamilyArray count] > 0)
    {
        _acceptButton.userInteractionEnabled = YES;
        _acceptButton.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:185.0/255.0 blue:200.0/255.0 alpha:1];
    }
    else
    {
        _acceptButton.userInteractionEnabled = NO;
        _acceptButton.backgroundColor = [UIColor lightGrayColor];
    }
}

- (IBAction)segmentedControlValueChanged:(id)sender
{
    DebugLog(@"");
    if(_segmentedControl.selectedSegmentIndex == 0)
    {
        [self.doctorAndFamilyTableView reloadData];
        if([panelArray count] > 0)
        {
            [self removePermissionPanel];
        }
        [self searchBar:self.searchBar textDidChange:searchString];
    }
    else
    {
        [self.doctorAndFamilyTableView reloadData];
        if([panelArray count] > 0)
        {
            [self removePermissionPanel];
        }
        [self searchBar:self.searchBar textDidChange:searchString];
    }
}

-(void)removePermissionPanel
{
    DebugLog(@"");
    [panelArray removeAllObjects];
    NSMutableArray *deleteIndexPaths;
    deleteIndexPaths = [NSMutableArray arrayWithObjects:
                        [NSIndexPath indexPathForRow:selectedIndex + 1 inSection:0],
                        [NSIndexPath indexPathForRow:selectedIndex + 2 inSection:0],
                        [NSIndexPath indexPathForRow:selectedIndex + 3 inSection:0],
                        nil];
    if ([self hasInlineDatePicker])
    {
        [deleteIndexPaths addObject:[NSIndexPath indexPathForRow:selectedIndex + 4 inSection:0]];
        self.datePickerIndexPath = nil;
    }
    
    [self.doctorAndFamilyTableView beginUpdates];
    [self.doctorAndFamilyTableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [self.doctorAndFamilyTableView endUpdates];
    
}

-(void)removeInlinePicker
{
    DebugLog(@"");
    NSMutableArray *deleteIndexPaths;
    
    if ([self hasInlineDatePicker])
    {
        deleteIndexPaths = [NSMutableArray arrayWithObjects:self.datePickerIndexPath,nil];
        self.datePickerIndexPath = nil;
    }
    
    [self.doctorAndFamilyTableView beginUpdates];
    [self.doctorAndFamilyTableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [self.doctorAndFamilyTableView endUpdates];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DebugLog(@"");
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PermissionSummaryViewController * summaryController = [segue destinationViewController];
    summaryController.permissionsArray = permissionsArray;
    summaryController.permissionsFamilyArray = permissionsFamilyArray;
    summaryController.finalFamilyPermissionDataArray = finalFamilyPermissionDataArray;
}
- (IBAction)checkButtonTapped:(id)sender {
    DebugLog(@"");
    UIButton * button = (UIButton *)sender;
    [button setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    if([panelArray count] > 0)
    {
        if([self hasInlineDatePicker])
        {
            NSIndexPath *targetedCellIndexPath = nil;
            targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];//    }
            DateTableViewCell *cell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:targetedCellIndexPath];
            cell.detailLabel.text = @"Select";
            
            NSIndexPath *fromCellIndexPath = nil;
            fromCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 2 inSection:0];
            if ([[self.doctorAndFamilyTableView cellForRowAtIndexPath:fromCellIndexPath] isKindOfClass:[DateTableViewCell class] ]) {
                DateTableViewCell *cell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:fromCellIndexPath];
                cell.detailLabel.text = @"Select";
                
            }
            
            NSIndexPath *toCellIndexPath = nil;
            toCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row + 1 inSection:0];
            if ([[self.doctorAndFamilyTableView cellForRowAtIndexPath:toCellIndexPath] isKindOfClass:[DateTableViewCell class] ]) {
                DateTableViewCell *cell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:toCellIndexPath];
                cell.detailLabel.text = @"Select";
                
            }
        }
        else
        {
            NSIndexPath *fromCellIndexPath = nil;
            fromCellIndexPath = [NSIndexPath indexPathForRow:button.tag + 2 inSection:0];
            if ([[self.doctorAndFamilyTableView cellForRowAtIndexPath:fromCellIndexPath] isKindOfClass:[DateTableViewCell class] ]) {
                DateTableViewCell *cell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:fromCellIndexPath];
                cell.detailLabel.text = @"Select";
                
            }
            
            NSIndexPath *toCellIndexPath = nil;
            toCellIndexPath = [NSIndexPath indexPathForRow:button.tag + 3 inSection:0];
            if ([[self.doctorAndFamilyTableView cellForRowAtIndexPath:toCellIndexPath] isKindOfClass:[DateTableViewCell class] ]) {
                DateTableViewCell *cell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:fromCellIndexPath];
                cell.detailLabel.text = @"Select";
                
            }
        }
    }
    
    if(_segmentedControl.selectedSegmentIndex==0)
    {
        NSMutableArray *permissionCopyArray = [permissionsArray mutableCopy];
        for (PermissionData* permData in permissionCopyArray) {
            if (permData.index == button.tag) {
                
                [permissionsArray removeObject:permData];
                [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:permissionsArray]forKey:@"PermissionArray"];
                break;
            }
            
            //        }
        }
    }
    else
    {
        NSMutableArray *permissionCopyArray = [permissionsFamilyArray mutableCopy];
        for (PermissionData* permData in permissionCopyArray) {
            if (permData.index == button.tag) {
                
                [permissionsFamilyArray removeObject:permData];
                [[NSUserDefaults standardUserDefaults]setObject:[NSKeyedArchiver archivedDataWithRootObject:permissionsFamilyArray]forKey:@"PermissionFamilyArray"];
                break;
            }
            
            //        }
        }
        
    }
    NSIndexPath *targetedCellIndexPath = nil;
    targetedCellIndexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];//    }
    CustomCell *cell = [self.doctorAndFamilyTableView cellForRowAtIndexPath:targetedCellIndexPath];
    cell.fromAndToLabel.text = @"";
}
- (IBAction)backButtonPressed:(id)sender {
    DebugLog(@"");
    [self.navigationController popViewControllerAnimated:YES];
}
@end

