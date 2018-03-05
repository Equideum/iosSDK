//
//  TimelineViewController.m
//  MHealthApp
//
//  Created by Sonam Agarwal on 11/15/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//
#import "GrayCell.h"
#import "TimelineViewController.h"
#import "TimeLineHeader.h"
#import "TimelineCollectionViewCell.h"
#import "GraphViewController.h"
#import<QuartzCore/QuartzCore.h>
#import "SelectMemberViewController.h"
#import "Constants.h"
#import "APIhandler.h"
#import "ServerSingleton.h"



@interface TimelineViewController ()
{
    NSArray *levelArray;
    NSArray *percentageArray;
    NSArray *mg_dlArray;
    NSArray *exerciseArray;
    NSArray *dietArray;
    NSArray *medicineArray;
    NSArray *exerciseImageArray;
    NSArray *dietImageArray;
    NSArray *medicineImageArray;
    NSArray *noteArray;
    NSArray *imageArray;
    NSArray *datelabelArray;
    NSArray *monthlabelArray;
    NSNumber *isCaregiver;
    BOOL isCaregiverBool;
    
    NSArray * publicClaims;
    
    SecKeyRef privateKey;
    SecKeyAlgorithm algorithm;
    NSDictionary *request_dic;



}


@property (strong, nonatomic) IBOutlet UIButton *profileImage;
@property (strong, nonatomic) IBOutlet UIButton *list;

//added changes for fetch permission call
@property (nonatomic) BOOL isFetchPermissions;
@property(nonatomic) NSString *endpoint;


@end

@implementation TimelineViewController

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    [self.collection registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GrayCell"];
    levelArray=[NSArray arrayWithObjects:@"A1C Level",@"A1C Level",@"A1C Level",@"A1C Level",@"A1C Level", @"A1C Level",nil];
    percentageArray=[NSArray arrayWithObjects:@"6.1%",@"5.5%",@"5.8%",@"5.6%",@"5.2%",@"5%", nil];
    mg_dlArray=[NSArray arrayWithObjects:@"(128 mg/dl)",@"(110 mg/dl)",@"(128 mg/dl)",@"(110 mg/dl)",@"(110 mg/dl)",@"(90 mg/dl)", nil];
    exerciseArray=[NSArray arrayWithObjects:@"Exercise",@"Exercise",@"Exercise",@"Exercise",@"Exercise",@"Congratulations", nil];
    dietArray=[NSArray arrayWithObjects:@"Diet", @"Diet",@"Diet",@"Diet",@"",@"",nil];
    medicineArray=[NSArray arrayWithObjects:@"Medicine",@"", @"Medicine",@"",@"",@"",nil];
    exerciseImageArray=[NSArray arrayWithObjects:@"exercise", @"exercise",@"exercise",@"exercise",@"exercise",@"like",nil];
    dietImageArray=[NSArray arrayWithObjects:@"diet",@"diet",@"diet",@"diet",@"white",@"white", nil];
    medicineImageArray=[NSArray arrayWithObjects:@"medicine",@"white",@"medicine",@"white",@"white",@"white", nil];
    noteArray=[NSArray arrayWithObjects: @"Note:Above mentioned suggestions will have you to maintain blood sugar level",@"Note:Above mentioned suggestions will have you to maintain blood sugar level",@"Note:Above mentioned suggestions will have you to maintain blood sugar level",@"Note:Above mentioned suggestions will have you to maintain blood sugar level",@"Note:Above mentioned suggestions will have you to maintain blood sugar level",@"Note:Your blood sugar level is normal",nil];
    imageArray=[NSArray arrayWithObjects:@"red_box",@"orange_box",@"red_box",@"orange_box",@"orange_box",@"green_box", nil];
    datelabelArray=[NSArray arrayWithObjects:@"15",@"01",@"15",@"01",@"15",@"01",nil];
    monthlabelArray=[NSArray arrayWithObjects:@"NOV-2017",@"NOV-2017",@"OCT-2017",@"OCT-2017",@"SEP-2017",@"SEP-2017", nil];
    self.navigationController.navigationBar.topItem.title = @"";
    //set nav bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:15/255.00f green:105/255.00f blue:145/255.00f alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeProfileButtonWithNotification:) name:@"Selected_Index" object:nil];
    _profileImage.layer.cornerRadius=18.0;
    _profileImage.clipsToBounds=YES;
    NSNumber *number=[[NSUserDefaults standardUserDefaults]valueForKey:@"Selected_Index"];
    
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
  
    publicClaims = [[NSUserDefaults standardUserDefaults]valueForKey:@"PublicClaims"];

    
    if(isCaregiverBool)
    {
        [self.list setHidden:YES];
      
    }
    int index = [number intValue];
   /* if(!isCaregiverBool)
    {
    switch (index) {
        case 0:
           [self.profileImage setImage:[UIImage imageNamed:@"Patient"] forState:UIControlStateNormal];
            break;
            
        case 1:
            [self.profileImage setImage:[UIImage imageNamed:@"Mother"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.profileImage setImage:[UIImage imageNamed:@"Father"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.profileImage setImage:[UIImage imageNamed:@"Brother"] forState:UIControlStateNormal];
            break;
                  case 4:
                      [self.profileImage setImage:[UIImage imageNamed:@"Sister"] forState:UIControlStateNormal];
                       break;
        default:
            break;
    }
    }
    else
    {
        switch (index) {
           
            case 0:
                [self.profileImage setImage:[UIImage imageNamed:@"Mother"] forState:UIControlStateNormal];
                break;
            case 1:
                [self.profileImage setImage:[UIImage imageNamed:@"Father"] forState:UIControlStateNormal];
                break;
            case 2:
                [self.profileImage setImage:[UIImage imageNamed:@"Brother"] forState:UIControlStateNormal];
                break;
            case 3:
                [self.profileImage setImage:[UIImage imageNamed:@"Sister"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
   
       // [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithBool:NO] forKey:@"isCaregiver"];
    }*/
    
    if(isCaregiverBool)
    {
        //[self fetchPermission];
    }
    
    [self setGenericImage];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    DebugLog(@"");
      self.navigationController.navigationBar.hidden = YES;
    
    NSString *strData =[[NSUserDefaults standardUserDefaults] valueForKey:@"ProfileImageData"];
    if(strData!=nil)
    {
        NSArray *arrData =[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
        if(![arrData[4] isEqualToString:@"NA"])
        {
            [self.profileImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrData[4]]] forState:UIControlStateNormal];
        }
        else
        {
            NSString *gender = arrData[2];
            if([gender.lowercaseString isEqualToString:@"male"])
            {
                [self.profileImage setImage:[UIImage imageNamed:@"maledefault.png"] forState:UIControlStateNormal];
            }
            else if ([gender.lowercaseString isEqualToString:@"female"])
            {
                [self.profileImage setImage:[UIImage imageNamed:@"femaledefault.png"] forState:UIControlStateNormal];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ProfileImageData"];
        
    }
    
}
- (IBAction)profileBtnSelected:(id)sender {
    DebugLog(@"");
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectMemberViewController *selectController=[storyboard instantiateViewControllerWithIdentifier:@"SelectMember"];
    [self presentViewController:selectController animated:YES completion:nil];
    
    
}
-(void)setGenericImage
{
    DebugLog(@"");
    
    NSMutableArray *existingCaregiverDataArray=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:FINALFAMILYDATAARRAY]];
    
    NSString *firstName = [(NSDictionary *)[publicClaims objectAtIndex:1] valueForKey:@"value"];
    NSString *lastName = [(NSDictionary *)[publicClaims objectAtIndex:3] valueForKey:@"value"];
    BOOL isDataExisted=NO;
    NSString *gender;
    for (int iCount=0; iCount<existingCaregiverDataArray.count; iCount++)
    {
        NSString *strData=existingCaregiverDataArray[iCount];
        NSArray *arrData=[strData componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
        
        if([firstName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[0]].lowercaseString] && [lastName.lowercaseString isEqualToString:[NSString stringWithFormat:@"%@",arrData[1]].lowercaseString])
        {
            //set image for existing
            if(![arrData[4] isEqualToString:@"NA"])
            {
                [self.profileImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",arrData[4]]] forState:UIControlStateNormal];
            }
            else
            {
                gender = arrData[4];
                
            }
            isDataExisted=YES;
            break;
        }
    }
    if(!isDataExisted)
    {
        gender = [(NSDictionary *)[publicClaims objectAtIndex:4] valueForKey:@"value"];
    }
    if([gender.lowercaseString isEqualToString:@"male"])
    {
        [self.profileImage setImage:[UIImage imageNamed:@"maledefault.png"] forState:UIControlStateNormal];
    }
    else if ([gender.lowercaseString isEqualToString:@"female"])
    {
        [self.profileImage setImage:[UIImage imageNamed:@"femaledefault.png"] forState:UIControlStateNormal];
    }
   
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
            [self.profileImage setImage:[UIImage imageNamed:@"Patient"] forState:UIControlStateNormal];
            break;
            
        case 1:
            [self.profileImage setImage:[UIImage imageNamed:@"Mother"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.profileImage setImage:[UIImage imageNamed:@"Father"] forState:UIControlStateNormal];
            break;
        case 3:
            [self.profileImage setImage:[UIImage imageNamed:@"Brother"] forState:UIControlStateNormal];
            break;
        case 4:
            [self.profileImage setImage:[UIImage imageNamed:@"Sister"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    }
    else{
         switch (index) {
         case 0:
        [self.profileImage setImage:[UIImage imageNamed:@"Mother"] forState:UIControlStateNormal];
        break;
         case 1:
        [self.profileImage setImage:[UIImage imageNamed:@"Father"] forState:UIControlStateNormal];
        break;
         case 2:
        [self.profileImage setImage:[UIImage imageNamed:@"Brother"] forState:UIControlStateNormal];
        break;
         case 3:
        [self.profileImage setImage:[UIImage imageNamed:@"Sister"] forState:UIControlStateNormal];
        break;
         default:
        break;
    }
        
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    DebugLog(@"");
    if([segue.identifier isEqualToString:@"GraphSegue"])
   {
       UINavigationController *navController=[segue destinationViewController];
       GraphViewController * graphcontroller = (GraphViewController *)[navController viewControllers][0];
       graphcontroller.profileImage=_profileImage.currentImage;
   }
}
-(void)fetchPermission
{
        DebugLog(@"");
        _isFetchPermissions = YES;
        APIhandler *
        h=[[APIhandler alloc]init];
        h.delegate = self;
        _endpoint=@"fetchPermissionsGivenToMe";
        
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        dateformatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        time_t currentTime = [[ServerSingleton sharedServerSingleton]time];
        
        NSString *currentDate  = [dateformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
        NSString *guid = [[NSUserDefaults standardUserDefaults]valueForKey:@"dcsi"];
        NSString *nonce = [self genRandStringLength:36];
        
        NSLog(@"current Date :%@ ",currentDate);
        NSLog(@"%@",guid);
        NSLog(@"%@", nonce);
        
        NSString *payload=[NSString stringWithFormat:@"%@%@%@%@%@"
                           //                       %@%@"
                           //                       ,@"|",guid,
                           ,@"|",currentDate,@"|",nonce,@"|"];
        
        NSLog(@"%@", payload);
        
        NSData * dataForSignature = [payload dataUsingEncoding:NSUTF8StringEncoding];
        
        NSData * privateKeyData = [[NSUserDefaults standardUserDefaults]valueForKey:@"PrivateKey"];
        NSDictionary* options = @{(id)kSecAttrKeyType: (id)kSecAttrKeyTypeEC,
                                  (id)kSecAttrKeyClass: (id)kSecAttrKeyClassPrivate,
                                  (id)kSecAttrKeySizeInBits: @256,
                                  };
        CFErrorRef error = NULL;
        privateKey = SecKeyCreateWithData((__bridge CFDataRef)privateKeyData,
                                          (__bridge CFDictionaryRef)options,
                                          &error);
        if (!privateKey) {
            NSError *err = CFBridgingRelease(error);  // ARC takes ownership
            // Handle the error. . .
        } else {  }
        // Creation of Signature
        NSData *signature=[self createSignature:dataForSignature withKey:privateKey];
        NSString *signatureString = [signature base64EncodedStringWithOptions:0];
        request_dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"ecdsa",@"cipher",guid,@"csiGuid",currentDate,@"dateTime",nonce,@"nonce",signatureString,@"signature" ,nil];
        //picker
        
        //#if ISDEBUG
        //
        //#if ISENDSCREEN
        NSLog(@"in end screen debug mode");
        NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"PermissionsLogArray"];
        NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
       
        [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"PermissionsLogArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //    [debugView setHidden:true];
        [h createSessionforPermissionEndPoint:_endpoint withModelDictionary:request_dic];
    
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
        NSMutableArray * array1 = (NSMutableArray *)[[NSUserDefaults standardUserDefaults] valueForKey:@"PermissionsLogArray"];
        NSMutableArray * array2 = [NSMutableArray arrayWithArray:array1];
        [array2 addObject:[NSString stringWithFormat:@"%@%@%@",Permission_Base_URL,_endpoint,request_dic]];
        //    [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"LogArray"];
        [[NSUserDefaults standardUserDefaults]setObject:array2 forKey:@"PermissionsLogArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            //    [_debugView setHidden:true];
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
    //    indexArray = [[NSMutableArray alloc]init];
    //    indexFamilyArray = [[NSMutableArray alloc]init];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    

    
    
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
-(NSData*)createSignature:(NSData*)data2sign withKey:(SecKeyRef)privateKey
{
    DebugLog(@"");
    // Algorithm for keys Generation
    algorithm = kSecKeyAlgorithmECDSASignatureMessageX962SHA256;
    
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
- (void)didReceiveMemoryWarning {
    DebugLog(@"");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=@"Cell";
    
    if(indexPath.row%2==1)
    {
        TimelineCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImage *timeline_image=[UIImage imageNamed:[imageArray objectAtIndex:(indexPath.row-1)/2]];
    cell.timelineImage.image=timeline_image;
    cell.level_label.text=[levelArray objectAtIndex:(indexPath.row-1)/2];
        if(indexPath.row==1)
        {
            cell.percentage_label.textColor=[UIColor colorWithRed:244.0/255.0 green:66.0/255.0 blue:75.0/255.0 alpha:1];
        }
        else if(indexPath.row==3)
        {
            cell.percentage_label.textColor=[UIColor colorWithRed:244.0/255.0 green:128.0/255.0 blue:66.0/255.0 alpha:1];
        }
        else if(indexPath.row==5)
        {
            cell.percentage_label.textColor=[UIColor colorWithRed:244.0/255.0 green:66.0/255.0 blue:75.0/255.0 alpha:1];
        }
        else if(indexPath.row==7)
        {
            cell.percentage_label.textColor=[UIColor colorWithRed:244.0/255.0 green:128.0/255.0 blue:66.0/255.0 alpha:1];
        }
        else if(indexPath.row==9)
        {
           cell.percentage_label.textColor=[UIColor colorWithRed:244.0/255.0 green:128.0/255.0 blue:66.0/255.0 alpha:1];
        }
        else
        {
            cell.percentage_label.textColor=[UIColor colorWithRed:161.0/255.0 green:244.0/255.0 blue:66.0/255.0 alpha:1];
        }
    cell.percentage_label.text=[percentageArray objectAtIndex:(indexPath.row-1)/2];
        
    cell.mg_label.text=[mg_dlArray objectAtIndex:(indexPath.row-1)/2];
    UIImage *exercise_image=[UIImage imageNamed:[exerciseImageArray objectAtIndex:(indexPath.row-1)/2]];
    cell.exercise_image.image=exercise_image;
    UIImage *diet_image=[UIImage imageNamed:[dietImageArray objectAtIndex:(indexPath.row-1)/2]];
    cell.diet_image.image=diet_image;
    UIImage *med_image=[UIImage imageNamed:[medicineImageArray objectAtIndex:(indexPath.row-1)/2]];
    cell.medicineimage.image=med_image;
    cell.exercise_label.text=[exerciseArray objectAtIndex:(indexPath.row-1)/2];
    cell.diet_label.text=[dietArray objectAtIndex:(indexPath.row-1)/2];
    cell.medicine_label.text=[medicineArray objectAtIndex:(indexPath.row-1)/2];
    cell.note_label.text=[noteArray objectAtIndex:(indexPath.row-1)/2];
    cell.date_label.text=[datelabelArray objectAtIndex:(indexPath.row-1)/2];
    cell.month_label.text=[monthlabelArray objectAtIndex:(indexPath.row-1)/2];
        cell.layer.cornerRadius=8.0;
        cell.contentView.layer.cornerRadius = 8.0f;
        cell.contentView.layer.borderWidth = 1.0f;
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.contentView.layer.masksToBounds = YES;
        

        
        return cell;
    }
    else{
        
        GrayCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"GrayCell" forIndexPath:indexPath];
        UIImage *img=[UIImage imageNamed:@"gray_dot"];
        cell.grayimage.image=img;
        return cell;
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2==1)
    {
        return CGSizeMake(358.0, 212.0);
    }
    else
    {
        return CGSizeMake(358.0, 20.0);
    }
    
    }
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 0.0;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"");
    UICollectionReusableView *reusableview=nil;
    if(kind==UICollectionElementKindSectionHeader)
    {
        
      TimeLineHeader *headerview=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        UIImage *graph_image= [UIImage imageNamed:@"graph"];
        headerview.graph_image.image=graph_image;
        headerview.diabetestype_label.text=@"Diabetes Type:Mellitus";
        headerview.state_label.text=@"State:Active";
        reusableview=headerview;
        
    }
    return reusableview;
}


@end
