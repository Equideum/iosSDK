//
//  mHealthApiHandler.h
//  mHealthApiHandler
//
//  Copyright © 2018 FHIRBlocks Project. All rights reserved.
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
