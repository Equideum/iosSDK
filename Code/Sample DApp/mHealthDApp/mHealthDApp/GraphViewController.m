//
//  GraphViewController.m
//  MHealthApp
//
/*
 * Copyright 2018 BBM Health, LLC - All rights reserved
 * Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission
 * FHIR is registered trademark of HL7 Intl
 *
 */

#import "GraphViewController.h"
#import "GraphCollectionViewCell.h"
#import "CollectionHeaderView.h"
#import "Constants.h"
@interface GraphViewController ()
{
    NSArray *dateArray;
    NSArray *typeDetectionArray;
    NSArray *array;
    NSArray *imageArray;
    NSNumber *isCaregiver;
    BOOL isCaregiverBool;
}
@property (strong, nonatomic) IBOutlet UIButton *profile_image;

@property (strong, nonatomic) IBOutlet UIButton *list;

@end

@implementation GraphViewController

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    dateArray=[NSArray arrayWithObjects:@"15 NOV 2017",@"01 NOV 2017",@"15 OCT 2017",@"01 OCT 2017",@"15 SEP 2017",@"01 SEP 2017",nil];
    typeDetectionArray=[NSArray arrayWithObjects:@"E10 Type 1 diabetes mellitus detected",@"E10 Type 1 diabetes mellitus detected",@"E10 Type 1 diabetes mellitus detected",@"E10 Type 1 diabetes mellitus detected",@"E10 Type 1 diabetes mellitus detected",@"No Diabetes detected", nil];
    array=[NSArray arrayWithObjects:@"Exercise    Diet    Medicine", @"Exercise    Diet",@"Exercise    Diet    Medicine",@"Exercise    Diet",@"Exercise",@"",nil];
    imageArray=[NSArray arrayWithObjects:@"red_dot",@"orange_dot",@"red_dot",@"orange_dot",@"orange_dot",@"green_dot", nil];
    self.navigationController.navigationBar.hidden = YES;
    [self.profile_image setImage:self.profileImage forState:UIControlStateNormal];
    self.profile_image.layer.cornerRadius=18.0;
    self.profile_image.clipsToBounds=YES;
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeProfileButtonWithNotification:) name:@"Selected_Index" object:nil];    // Do any additional setup after loading the view.
    NSString *isCaregiverFlow=[[NSUserDefaults standardUserDefaults]valueForKey:@"Flow"];

    if([isCaregiverFlow isEqualToString:@"Caregiver"])
    {
        isCaregiver=[NSNumber numberWithInt:1];
    }
    else
    {
        isCaregiver=[NSNumber numberWithInt:0];
        
    }
    
    //isCaregiver = [[NSUserDefaults standardUserDefaults]valueForKey:@"isCaregiver"];
    isCaregiverBool=[isCaregiver boolValue];
    if(isCaregiverBool)
    {
        [self.list setHidden:YES];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{DebugLog(@"");
    self.navigationController.navigationBar.hidden = YES;
    
}
//
//- (IBAction)timelineBtnTapped:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning {
    DebugLog(@"");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)changeProfileButtonWithNotification:(NSNotification*)notification
{
    DebugLog(@"");
    NSNumber * number=(NSNumber *)[notification object];
    int index = [number intValue];
    isCaregiver = [[NSUserDefaults standardUserDefaults]valueForKey:@"isCaregiver"];
    isCaregiverBool=[isCaregiver boolValue];
    if(!isCaregiverBool)
    {
        switch (index) {
            case 0:
                [self.profile_image setImage:[UIImage imageNamed:@"Patient"] forState:UIControlStateNormal];
                break;
                
            case 1:
                [self.profile_image setImage:[UIImage imageNamed:@"Mother"] forState:UIControlStateNormal];
                break;
            case 2:
                [self.profile_image setImage:[UIImage imageNamed:@"Father"] forState:UIControlStateNormal];
                break;
            case 3:
                [self.profile_image setImage:[UIImage imageNamed:@"Brother"] forState:UIControlStateNormal];
                break;
            case 4:
                [self.profile_image setImage:[UIImage imageNamed:@"Sister"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    else{
        switch (index) {
            case 0:
                [self.profile_image setImage:[UIImage imageNamed:@"Mother"] forState:UIControlStateNormal];
                break;
            case 1:
                [self.profile_image setImage:[UIImage imageNamed:@"Father"] forState:UIControlStateNormal];
                break;
            case 2:
                [self.profile_image setImage:[UIImage imageNamed:@"Brother"] forState:UIControlStateNormal];
                break;
            case 3:
                [self.profile_image setImage:[UIImage imageNamed:@"Sister"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
    }
    }

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"Cell";
    GraphCollectionViewCell *graphCell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    graphCell.dot_image.image=[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    graphCell.date_label.text=[dateArray objectAtIndex:indexPath.row];
    graphCell.detection_label.text=[typeDetectionArray objectAtIndex:indexPath.row];
    graphCell.exercise_label.text=[array objectAtIndex:indexPath.row];
    return graphCell;
}


-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    UICollectionReusableView *reusableview=nil;
    if(kind==UICollectionElementKindSectionHeader)
    {
        
CollectionHeaderView *headerview=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
       UIImage *graph_image= [UIImage imageNamed:@"graph_image"];
        headerview.graph_image.image=graph_image;
        headerview.diabetestype_label.text=@"Diabetes Type:Mellitus";
        headerview.statelabel.text=@"State:Active";
        UIImage *timeline_image= [UIImage imageNamed:@"timeline"];
        headerview.timeline_image.image=timeline_image;
        reusableview=headerview;
        
    }
    return reusableview;
}
@end
