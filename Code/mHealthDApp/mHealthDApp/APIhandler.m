//
//  APIhandler.m
//  NSURLSessionDemo
//
//  Created by Sonam Agarwal on 9/21/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import "APIhandler.h"
#import "Constants.h"

@implementation APIhandler
@synthesize delegate;
-(void)createSessionWithEndPoint:(NSString*)endPoint
{
    DebugLog(@"");
    //[requestLabel setText:[NSString stringWithFormat:@"%@%@",Base_URL,endpoint]];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    self.session=[NSURLSession sessionWithConfiguration:config];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Base_URL,endPoint]];
    NSURLSessionDataTask *task=[self.session dataTaskWithURL:url completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
{
        if ([self.delegate respondsToSelector:@selector(handleData:errr:)])
                                {
                                   // if err / call errHandler
                                    /// else if err in parsing call error handler
                                   // elkse// call suceess handel ansd send array ie. parse d data
                                    [self.delegate handleData:data errr:error];
                                }
    }];
    [task resume];
}

-(void)createFHIRResourceConsumptionRequest:(NSString*)endPoint accessToken:(NSString*)accessToken
{
    DebugLog(@"");
    //[requestLabel setText:[NSString stringWithFormat:@"%@%@",Base_URL,endpoint]];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    self.session=[NSURLSession sessionWithConfiguration:config];
    NSString *bearerToken=[NSString stringWithFormat:@"Bearer%@",accessToken];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@",endPoint]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:bearerToken forHTTPHeaderField:@"Authorization"];
    self.session=[NSURLSession sessionWithConfiguration:config];

    NSURLSessionDataTask *task=[self.session dataTaskWithRequest:request
                                               completionHandler:^(NSData *data,
                                                                   NSURLResponse *response,
                                                                   NSError *error)
                                {
                                    if ([self.delegate respondsToSelector:@selector(handleData:errr:)])
                                    {
                                        // if err / call errHandler
                                        /// else if err in parsing call error handler
                                        // elkse// call suceess handel ansd send array ie. parse d data
                                        [self.delegate handleData:data errr:error];
                                    }
                                }];
    [task resume];
}

-(void)createSessionforCSIEndPoint:(NSString*)endPoint withModelDictionary:(NSDictionary *)modelDictionary
{
    DebugLog(@"");
    // Convert the dictionary into JSON data.
    BOOL isValidJSON = [NSJSONSerialization isValidJSONObject:modelDictionary];
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:modelDictionary options:0 error:nil];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CSI_Base_URL,endPoint]];
    // Create a POST request with our JSON as a request body.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = JSONData;    //[requestLabel setText:[NSString stringWithFormat:@"%@%@",Base_URL,endpoint]];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    self.session=[NSURLSession sessionWithConfiguration:config];
    //NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CSI_Base_URL,endPoint]];
    NSURLSessionDataTask *task=[self.session dataTaskWithRequest:request
                                                                             completionHandler:^(NSData *data,
                                                                                                 NSURLResponse *response,
                                                                                                 NSError *error)
                                              {
        if ([self.delegate respondsToSelector:@selector(handleData:errr:)])
        {
            // if err / call errHandler
            /// else if err in parsing call error handler
            // elkse// call suceess handel ansd send array ie. parse d data
            [self.delegate handleData:data errr:error];
        }
    }];
    [task resume];
}

-(void)createSessionforAuthEndPoint:(NSString*)endPoint withURLEncodedString:(NSString *)urlEncodedString
{
    DebugLog(@"");
    // Convert the dictionary into JSON data.
//    BOOL isValidJSON = [NSJSONSerialization isValidJSONObject:modelDictionary];
//    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:modelDictionary options:0 error:nil];
    NSData *postData = [urlEncodedString dataUsingEncoding:NSDataBase64Encoding64CharacterLineLength];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Auth_Base_URL,endPoint]];
    // Create a POST request with our JSON as a request body.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = postData;    //[requestLabel setText:[NSString stringWithFormat:@"%@%@",Base_URL,endpoint]];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    self.session=[NSURLSession sessionWithConfiguration:config];
    //NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CSI_Base_URL,endPoint]];
    NSURLSessionDataTask *task=[self.session dataTaskWithRequest:request
                                               completionHandler:^(NSData *data,
                                                                   NSURLResponse *response,
                                                                   NSError *error)
                                {
                                    if ([self.delegate respondsToSelector:@selector(handleData:errr:)])
                                    {
                                        // if err / call errHandler
                                        /// else if err in parsing call error handler
                                        // elkse// call suceess handel ansd send array ie. parse d data
                                        [self.delegate handleData:data errr:error];
                                    }
                                }];
    [task resume];
}

-(void)createSessionforAccessEndPoint:(NSString*)endPoint withURLEncodedString:(NSString *)urlEncodedString
{
    DebugLog(@"");
    // Convert the dictionary into JSON data.
    //    BOOL isValidJSON = [NSJSONSerialization isValidJSONObject:modelDictionary];
    //    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:modelDictionary options:0 error:nil];
    
    NSString * modifiedString = [urlEncodedString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString * plusRemovedString = [modifiedString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSLog(@"URL Encoded String %@",plusRemovedString);
    NSData *postData = [plusRemovedString dataUsingEncoding:NSDataBase64Encoding64CharacterLineLength];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Access_Base_URL,endPoint]];
    // Create a POST request with our JSON as a request body.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = postData;    //[requestLabel setText:[NSString stringWithFormat:@"%@%@",Base_URL,endpoint]];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    self.session=[NSURLSession sessionWithConfiguration:config];
    //NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CSI_Base_URL,endPoint]];
    NSURLSessionDataTask *task=[self.session dataTaskWithRequest:request
                                               completionHandler:^(NSData *data,
                                                                   NSURLResponse *response,
                                                                   NSError *error)
                                {
                                    if ([self.delegate respondsToSelector:@selector(handleData:errr:)])
                                    {
                                        // if err / call errHandler
                                        /// else if err in parsing call error handler
                                        // elkse// call suceess handel ansd send array ie. parse d data
                                        [self.delegate handleData:data errr:error];
                                    }
                                }];
    [task resume];
}


-(void)createSessionforPermissionEndPoint:(NSString*)endPoint withModelDictionary:(NSDictionary *)modelDictionary
{
    DebugLog(@"");
    // Convert the dictionary into JSON data.
    BOOL isValidJSON = [NSJSONSerialization isValidJSONObject:modelDictionary];
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:modelDictionary options:0 error:nil];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Permission_Base_URL,endPoint]];
    // Create a POST request with our JSON as a request body.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    request.HTTPMethod = @"POST";
    request.HTTPBody = JSONData;    //[requestLabel setText:[NSString stringWithFormat:@"%@%@",Base_URL,endpoint]];
    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
    self.session=[NSURLSession sessionWithConfiguration:config];
    //NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CSI_Base_URL,endPoint]];
    NSURLSessionDataTask *task=[self.session dataTaskWithRequest:request
                                               completionHandler:^(NSData *data,
                                                                   NSURLResponse *response,
                                                                   NSError *error)
                                {
                                    if ([self.delegate respondsToSelector:@selector(handleData:errr:)])
                                    {
                                        NSString *responseStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                        DebugLog(@"response string==> %@",responseStr);
                                        // if err / call errHandler
                                        /// else if err in parsing call error handler
                                        // elkse// call suceess handel ansd send array ie. parse d data
                                        [self.delegate handleData:data errr:error];
                                    }
                                }];
    [task resume];
}

@end
