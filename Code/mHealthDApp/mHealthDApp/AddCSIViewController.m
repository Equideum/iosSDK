//
//  AddCSIViewController.m
//  mHealthDApp
//
//

#import "AddCSIViewController.h"
#import "Constants.h"

@interface AddCSIViewController ()
{
    UIView          *pickerContainerView;
    UIPickerView    *pickrForGender;
    BOOL    isPickerShown;
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    int selpikrIndex;
    NSArray *arrGender;

}
@end

@implementation AddCSIViewController
@synthesize txtCSI,txtFirstName,txtLastName,txtGender;
@synthesize btnback;
@synthesize strFromScreen;
- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    arrGender=[[NSArray alloc]initWithObjects:@"Male",@"Female",@"Other", nil];

    self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"Add CSI";
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    //[self addPickerOnContainerView];
    // Do any additional setup after loading the view.
    txtGender.inputView=pickerContainerView;
    if([strFromScreen isEqualToString:@"CaregiverFlow"])
    {
        btnback.hidden=NO;
    }
    
    UIPasteboard *thePasteboard = [UIPasteboard generalPasteboard];
    NSString *pasteboardString = thePasteboard.string;
    NSLog(@"%@", pasteboardString);
    NSArray *arrData =[pasteboardString componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
    if(arrData.count == 4)
    {
        txtFirstName.text=[NSString stringWithFormat:@"%@",[arrData[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        txtLastName.text=[NSString stringWithFormat:@"%@",[arrData[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        txtGender.text=[NSString stringWithFormat:@"%@",[arrData[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        txtCSI.text=[NSString stringWithFormat:@"%@",[arrData[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
      
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showAlertWithMessage:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    
    [alert addAction:firstAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(BOOL)isIpad{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return YES; /* Device is iPad */
    }
    else
    {
        return NO;
    }
}
- (IBAction)dbtnBackTapped:(id)sender {
    DebugLog(@"");
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)doneButtonTapped:(id)sender {
    DebugLog(@"");
    if([txtFirstName.text isEqualToString:@""])
    {
        [self showAlertWithMessage:@"Please enter first name"];
        return;
    }
    if([txtLastName.text isEqualToString:@""])
    {
        [self showAlertWithMessage:@"Please enter last name"];
        return;
    }
    
    
    NSMutableArray * array;
    if([[NSUserDefaults standardUserDefaults]valueForKey:FINALFAMILYDATAARRAY] == nil)
    {
        array = [[NSMutableArray alloc]init];
    }
    else
    {
        array = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:FINALFAMILYDATAARRAY]];
    }
  
    NSString *newDataStr=[NSString stringWithFormat:@"%@#%@#%@#%@",txtFirstName.text,txtLastName.text,txtGender.text,txtCSI.text];
    BOOL isDataUpated=NO;
    if (array.count > 0)
    {
        for (int iCount=0; iCount<[array count]; iCount++)
        {
            NSString *existingDataStr= [array objectAtIndex:iCount];
            NSArray *existingDataArray=[existingDataStr componentsSeparatedByString:COMPONENTS_SEPERATED_STRING];
            
            NSString *existingFName=[NSString stringWithFormat:@"%@",[existingDataArray objectAtIndex:0]];
            NSString *existingLName=[NSString stringWithFormat:@"%@",[existingDataArray objectAtIndex:1]];
            
            if(([existingFName.uppercaseString isEqualToString:txtFirstName.text.uppercaseString]&&[existingLName.uppercaseString isEqualToString:txtLastName.text.uppercaseString]))
            {
                
                NSString *strFinalData = [NSString stringWithFormat:@"%@#%@#%@#%@#%@",[existingDataArray objectAtIndex:0],[existingDataArray objectAtIndex:1],[existingDataArray objectAtIndex:2],txtCSI.text,[existingDataArray objectAtIndex:4]];
                
                //update
                [array replaceObjectAtIndex:iCount withObject:strFinalData];
                isDataUpated=YES;
                break;

            }
            
            
        }
        if(!isDataUpated)
        {
            newDataStr=[newDataStr stringByAppendingString:@"#NA"];
            [array addObject:newDataStr];
        }
        
    }
    else
    {
        [array addObject:newDataStr];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:FINALFAMILYDATAARRAY];

    if([strFromScreen isEqualToString:@"CaregiverFlow"])
    {
        [self dbtnBackTapped:nil];
    }
    else if([strFromScreen isEqualToString:@"PatientFlow"])
    {
        [self dbtnBackTapped:nil];
    }
    else
    [self.navigationController popViewControllerAnimated:YES];
    
    //if array contains CSI then update it
    
    //else add it with all data
    
    /*if([array count] < 4)
    {
        NSMutableArray * array1 = [NSMutableArray arrayWithArray:array];
        [array1 addObject:self.pastedCSITextfield.text];
        self.pastedCSITextfield.text = nil;
        [[NSUserDefaults standardUserDefaults] setObject:array1 forKey:@"csiFamilyArray"];
    }*/
}
#pragma mark -
#pragma mark ==============================
#pragma mark Textfield Delegate
#pragma mark ==============================
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    DebugLog(@"");
    [textField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    DebugLog(@"");
    if(textField == txtGender)
    {
        [self.view endEditing:YES];
       // [txtGender resignFirstResponder];
        [txtFirstName resignFirstResponder];
        [txtLastName resignFirstResponder];
        [txtCSI resignFirstResponder];
        
        [self performSelector:@selector(showPicker) withObject:nil afterDelay:1.0];
        //[self showPicker];
    }
    else
    {
        [self cancelPicker:nil];
        
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // Implement your Date Time Picker initial Code here
    if (textField == txtGender)
    {
        [self showPicker];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    DebugLog(@"");
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark ==============================
#pragma mark UIPicker Delagate
#pragma mark ==============================
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrGender.count;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    if([self isIpad])
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    else
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [arrGender objectAtIndex:row];
    return label;
}
// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 320;
}

-(void)showPicker
{
    DebugLog(@"");
    [self addPickerOnContainerView];
    [UIView beginAnimations:nil context:nil];
    pickerContainerView.frame = CGRectMake(0, screenHeight - 300, screenWidth, 300);
    [UIView commitAnimations];
    isPickerShown = YES;
    [pickrForGender selectRow:selpikrIndex inComponent:0 animated:YES];
}

-(void)addPickerOnContainerView
{
    DebugLog(@"");
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtCSI resignFirstResponder];
    
    if (isPickerShown) {
        return;
    }
    
    CGRect pickerFrame;
    
    pickerFrame = CGRectMake(0, screenHeight , screenWidth, 300);
    
    
    pickerContainerView = [[UIView alloc] initWithFrame:pickerFrame];
    
    // Create picker toolbar
    float tooLBarHt = 44;
    UIToolbar *pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tooLBarHt)];
    pickerToolBar.barStyle = UIBarStyleBlack;
    pickerToolBar.tintColor =[UIColor whiteColor];
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPicker:)];
    pickerToolBar.items = @[btnCancel,
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePickertapped:)]];
    
    
    // [pickerToolBar sizeToFit];
    
    [pickerContainerView addSubview:pickerToolBar];
    
    pickrForGender   = [[UIPickerView alloc] initWithFrame:CGRectMake(0, tooLBarHt, screenWidth, (300-tooLBarHt))];
    
    pickrForGender.delegate = self;
    pickrForGender.dataSource = self;
    
    //[pickrForEffDate selectRow:0 inComponent:0 animated:NO];
    
    pickrForGender.showsSelectionIndicator = YES;
    pickrForGender.backgroundColor=[UIColor whiteColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickr:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [pickrForGender addGestureRecognizer:tapGesture];
    [pickerContainerView addSubview:pickrForGender];
    [pickrForGender reloadAllComponents];
    [self.view addSubview:pickerContainerView];
}

-(void)donePickertapped:(id)sender
{
    
    selpikrIndex = (int)[pickrForGender selectedRowInComponent:0];
    txtGender.text = [arrGender objectAtIndex:selpikrIndex];
    // Remove picker
    [self cancelPicker:nil];
}
-(void)cancelPicker:(id)sender
{
    // remove picker from view
    
    [UIView animateWithDuration:0.5 animations:^{
        
        pickerContainerView.frame = CGRectMake(0, screenHeight, screenWidth, 300);
    }completion:^(BOOL finished){
        if (finished) {
            
            [pickerContainerView removeFromSuperview];
            pickrForGender = nil;
            pickerContainerView = nil;
            isPickerShown = NO;
        }
    }];
    
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
