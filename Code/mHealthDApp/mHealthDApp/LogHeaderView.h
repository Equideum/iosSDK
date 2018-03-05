//
//  LogHeaderView.h
//  mHealthDApp
//
//  Created by bhavesh devnani on 12/01/18.
//  Copyright © 2018 Sonam Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegate<NSObject>
@required
-(void)closeButtonTapped;
@end
@interface LogHeaderView : UIView
@property(weak,nonatomic) id <HeaderViewDelegate> delegate;
@end
