//
//  HeaderView.m
//  mHealthDApp
//
//  Created by Sonam Agarwal on 11/17/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (IBAction)closeButtonTapped:(id)sender {
    [self.delegate closeButtonTapped];
}

@end
