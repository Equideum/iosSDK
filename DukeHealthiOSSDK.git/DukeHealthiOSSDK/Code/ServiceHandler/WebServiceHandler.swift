
//
//  WebServiceHandler.swift
//  Wishli
//
//  Created by Bharath Badam on 30/12/16.
//
//

import UIKit
import Alamofire
import SwiftyJSON

typealias SuccessBlock = (Any) -> Void
typealias FailureBlock = (Error) -> Void

class WebServiceHandler: NSObject, RequestRetrier {
    
    let sessionManager = Alamofire.SessionManager.default
    
    func parseResponse(response:DataResponse<Any>, completion:@escaping(NSObject?, NSError?, [String: Any?]?) -> Void) {
        var errorObj:NSError? = response.result.error as NSError? ?? Config.defaultError //response.result.error as NSError?
        var info:NSDictionary?
        let responseData = response.data
        
        print(response)
        var data = [String: Any?]()
        data["url"] = response.request?.url?.absoluteString as! String
        
        let string = NSString(data: responseData!, encoding: String.Encoding.utf8.rawValue)
        debugPrint(string ?? "NO API RESPONSE")
        
        if response.result.isSuccess == true || response.response?.statusCode == 200 {
            do {
                info =  try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary
                errorObj = nil
                data["success"] = "true"
                data["response"] = info
            }
            catch {
                //need to handle exception
                
                if response.request!.httpMethod!.lowercased() == "delete" {
                    info = ["success":"true"]
                    errorObj = nil
                    data["success"] = "true"
                    data["response"] = info
                    
                }
                else if response.request!.httpMethod!.lowercased() == "post" {
                    info = ["success":"true"]
                    errorObj = nil
                    data["success"] = "true"
                    data["response"] = info
                }
                else if response.request!.httpMethod!.lowercased() == "put" {
                    info = ["success":"true"]
                    errorObj = nil
                    data["success"] = "true"
                    data["response"] = info
                }
                else {
                    errorObj = error as NSError?;
                    data["success"] = "false"
                    data["response"] = errorObj
                }
            }
        }
        else if responseData != nil && errorObj == nil {
            
            do {
                info =  try JSONSerialization.jsonObject(with: responseData!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? NSDictionary
                data["success"] = "true"
                data["response"] = info
                if (info!.object(forKey: "success") as AnyObject).intValue == 0 {
                    errorObj = NSError.init(domain: "HealthSpace", code:response.response!.statusCode, userInfo: info as? [String : Any]);
                    data["success"] = "false"
                    data["response"] = errorObj
                }
            }
            catch {
                //Some error occured
                errorObj = error as NSError?;
                data["success"] = "false"
                data["response"] = errorObj
            }
        }
        else {
            //Some error occured
        }
       
        completion(info, errorObj,data)
    }
    
    
    func request(withBody: Bool = false, method: Alamofire.HTTPMethod, request: String, parameters: [String: AnyObject]?, completion: @escaping (AnyObject?, NSError?, [String: Any?]?) -> Void)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var headers = WebServiceHandler.appDefaultURLRequestHeaders()
        if (request == Config.WebAPI.Util.sendMessageToFBC) {
            headers["Accept"] = "application/json"
        }

        var parameterEncoding:ParameterEncoding = URLEncoding.default
        if(method == .get) {
            parameterEncoding = URLEncoding.methodDependent
        } else if (withBody) {
            parameterEncoding = URLEncoding.httpBody
        } else {
            parameterEncoding = JSONEncoding.default
        }
        sessionManager.retrier = self
        sessionManager.request(request, method: method, parameters: parameters, encoding: parameterEncoding, headers:headers).validate(statusCode: 200..<600).responseJSON { response in            self.parseResponse(response: response, completion: completion)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            debugPrint(response)
        }
    }
    
    class func appDefaultURLRequestHeaders() -> [String:String] {
        var headers = [String:String]()
        headers["Content-Type"] = "application/json"
        headers["Accept-Encoding"] = "application/json"
        headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8,application/json"
        
//        if let userSession = UserDefaults.standard.string(forKey: Config.UserDefaultConstants.userSessionKey) {
//            headers["X-Auth-Token"] = userSession
//        }
        return headers
    }
    
   
    
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        print("request = \(request)")
        guard request.retryCount == 0 else { return completion(false, 0) }
        print("request.task error = \(request.task?.error?.localizedDescription ?? "")")
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode >= 500 {
            completion(true, 1.0) // retry after 1 second
        } else {
            
            if let nserror = request.task?.error as NSError? , (nserror.code <= -998 && nserror.code >= -1009) {
                completion(true, 1.0)
            }
            else {
                completion(false, 0.0) // don't retry
            }
        }
    }
    
    
}
