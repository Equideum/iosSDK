//
//  LogHeaderView.m
//  mHealthDApp
//
//

#import "LogHeaderView.h"
#import "Constants.h"

@implementation LogHeaderView

- (IBAction)closeButtonTapped:(id)sender {
    DebugLog(@"");
    [self.delegate closeButtonTapped];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
