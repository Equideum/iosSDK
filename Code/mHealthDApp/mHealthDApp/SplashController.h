//
//  SplashController.h
//  mHealthDApp
//
//  Created by Sonam Agarwal on 11/23/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIhandler.h"

@interface SplashController : UIViewController<Delegation>
@property(strong,nonatomic) NSDictionary *dic;
@end
