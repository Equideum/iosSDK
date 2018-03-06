//
//  HeaderView.h
//  mHealthDApp
//
//

#import <UIKit/UIKit.h>

@protocol HeaderViewDelegate<NSObject>
@required
-(void)closeButtonTapped;
@end
@interface HeaderView : UIView
@property(weak,nonatomic) id <HeaderViewDelegate> delegate;
@end
