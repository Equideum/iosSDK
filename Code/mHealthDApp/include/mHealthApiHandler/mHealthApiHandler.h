//
//  mHealthApiHandler.h
//  mHealthApiHandler
//
//  Created by Akshay Aher on 3/12/18.
//  Copyright © 2018 Akshay Aher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol apiDelegate<NSObject>;
-(void)handleData :(NSData*)data errr:(NSError*)error;
@end

@interface mHealthApiHandler : NSObject

@property NSURLSession *session;
@property (nonatomic, weak) id<apiDelegate> delegate;

    
-(void)createSessionWithEndPoint:(NSString*)endPoint;
-(void)createSessionforCSIEndPoint:(NSString*)endPoint withModelDictionary:(NSDictionary *)modelDictionary;
-(void)createSessionforAuthEndPoint:(NSString*)endPoint withURLEncodedString:(NSString *)urlEncodedString;
-(void)createSessionforPermissionEndPoint:(NSString*)endPoint withModelDictionary:(NSDictionary *)modelDictionary;
-(void)createSessionforAccessEndPoint:(NSString*)endPoint withURLEncodedString:(NSString *)urlEncodedString;
-(void)createFHIRResourceConsumptionRequest:(NSString*)endPoint accessToken:(NSString*)accessToken;

@end
