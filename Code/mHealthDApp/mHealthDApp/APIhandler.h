//
//  APIhandler.h
//  NSURLSessionDemo
//
//

#import <Foundation/Foundation.h>

@protocol Delegation<NSObject>;
-(void)handleData :(NSData*)data errr:(NSError*)error;
//-(void)success;
//-(void)failure;
@end

@interface APIhandler : NSObject

@property NSURLSession *session;
@property (nonatomic, weak) id<Delegation> delegate;

-(void)createSessionWithEndPoint:(NSString*)endPoint;
-(void)createSessionforCSIEndPoint:(NSString*)endPoint withModelDictionary:(NSDictionary *)modelDictionary;
-(void)createSessionforAuthEndPoint:(NSString*)endPoint withURLEncodedString:(NSString *)urlEncodedString;
-(void)createSessionforPermissionEndPoint:(NSString*)endPoint withModelDictionary:(NSDictionary *)modelDictionary;
-(void)createSessionforAccessEndPoint:(NSString*)endPoint withURLEncodedString:(NSString *)urlEncodedString;
-(void)createFHIRResourceConsumptionRequest:(NSString*)endPoint accessToken:(NSString*)accessToken;



@end

