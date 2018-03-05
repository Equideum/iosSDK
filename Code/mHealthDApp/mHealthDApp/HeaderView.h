//
//  HeaderView.h
//  mHealthDApp
//
//  Created by Sonam Agarwal on 11/17/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegate<NSObject>
@required
-(void)closeButtonTapped;
@end
@interface HeaderView : UIView
@property(weak,nonatomic) id <HeaderViewDelegate> delegate;
@end
