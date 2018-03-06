//
//  LogViewController.m
//  FHIRBlocks
//

//

#import "LogViewController.h"
#import "Constants.h"

@interface LogViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UILabel *label5;
@property (strong, nonatomic) IBOutlet UILabel *label6;
@property (strong, nonatomic) IBOutlet UILabel *label7;
@property (strong, nonatomic) IBOutlet UILabel *label8;


@end

@implementation LogViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    DebugLog(@"");
  //  NSMutableString *attributedString;
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults]valueForKey:@"LogArray1"];
    NSString * s1=[array objectAtIndex:0];
    _label1.text=s1;
    NSString * s2=[array objectAtIndex:1];
    _label2.text=s2;
    NSString * s3=[array objectAtIndex:2];
    _label3.text=s3;
    NSString * s4=[array objectAtIndex:3];
    _label4.text=s4;
    NSString * s5=[array objectAtIndex:4];
    _label5.text=s5;
    NSString * s6=[array objectAtIndex:5];
    _label6.text=s6;
    NSString * s7=[array objectAtIndex:6];
    _label7.text=s7;
    NSString * s8=[array objectAtIndex:7];
    _label8.text=s8;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width - 8, self.label7.frame.size.height * 2);
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:128.0/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"Logs";
//    attributedString = [NSMutableString stringWithFormat: @"%@",array];
//    NSString *stringWithoutLeftBrackets = [attributedString
//                                     stringByReplacingOccurrencesOfString:@"(" withString:@" "];
//
//    NSString * stringWithoutRightBrackets = [stringWithoutLeftBrackets stringByReplacingOccurrencesOfString:@")" withString:@" "];
//     NSString * stringWithoutRightBrackets1 = [stringWithoutRightBrackets stringByReplacingOccurrencesOfString:@"\\n" withString:@" "];
//    NSString *string=[stringWithoutRightBrackets1 stringByReplacingOccurrencesOfString:@"\\" withString:@" "];
//
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:stringWithoutRightBrackets];
//    
//    //Fing range of the string you want to change colour
//    //If you need to change colour in more that one place just repeat it
//    NSRange range = [stringWithoutRightBrackets rangeOfString:@"Request:"];
//    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
//    
//    NSRange range1 = [stringWithoutRightBrackets rangeOfString:@"Response:"];
//    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range1];
//    
//    NSRange range2 = [stringWithoutRightBrackets rangeOfString:@"error:"];
//    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
//   
//    self.label.attributedText = attString;
    self.navigationController.navigationBar.topItem.title = @"";
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonTapped:(id)sender {
    DebugLog(@"");
    [self dismissViewControllerAnimated:YES completion:nil];
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
