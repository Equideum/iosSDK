//
//  LogHeaderView.m
//  mHealthDApp
//
//  Created by bhavesh devnani on 12/01/18.
//  Copyright © 2018 Sonam Agarwal. All rights reserved.
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
