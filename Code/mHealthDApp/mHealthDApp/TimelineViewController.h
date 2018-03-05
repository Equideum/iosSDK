//
//  TimelineViewController.h
//  MHealthApp
//
//  Created by Sonam Agarwal on 11/15/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import "ViewController.h"
#import "APIhandler.h"


@interface TimelineViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,Delegation>
@property (strong, nonatomic) IBOutlet UICollectionView *collection;

@end
