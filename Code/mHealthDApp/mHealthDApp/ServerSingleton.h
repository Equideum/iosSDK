//
//  ServerSingleton.h
//  mHealthDApp
//
//  Created by bhavesh devnani on 08/01/18.
//  Copyright © 2018 Sonam Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerSingleton : NSObject
@property(nonatomic) time_t timeOffset;
+ (id) sharedServerSingleton;
- (void)checkTimeWithDate:(NSString *)serverTime;
- (time_t)time;
@end
