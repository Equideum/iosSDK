//
//  ServerSingleton.h
//  mHealthDApp
//
//

#import <Foundation/Foundation.h>

@interface ServerSingleton : NSObject
@property(nonatomic) time_t timeOffset;
+ (id) sharedServerSingleton;
- (void)checkTimeWithDate:(NSString *)serverTime;
- (time_t)time;
@end
