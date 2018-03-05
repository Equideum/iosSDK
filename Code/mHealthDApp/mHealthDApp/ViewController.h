//
//  ViewController.h
//  mHealthDAP
//
//  Created by bhavesh devnani on 09/11/17.
//  Copyright © 2017 bhavesh devnani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UILabel *label;
@property(strong,nonatomic) NSDictionary *dic;
@end

