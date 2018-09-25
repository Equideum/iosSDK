//
//  SpookApiHandler.swift
//  DukeHealthiOSSDK
//
//  Created by Swathi on 24/09/18.
//  Copyright © 2018 Swathi. All rights reserved.
//

import Foundation
class SpookApiHandler {
    /**
     * Calls spook api
     **/
    class func sendSignedMessageToFBC(body:[String:String], completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.sendSignedMessageToFBC (parameters: body as [String : AnyObject]) { (response, error, data) in
            var responseMap : [String: String] = ["api":"FBC Handshake api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = (data!["url"] as! String)
                 responseMap["response"] = error.debugDescription ?? ""
                print("in else")
                completion(responseMap)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                responseMap["url"] = (data!["url"] as! String)
                responseMap["response"] = convertedString ?? ""
                responseMap["success"] = (data!["success"] as! String)
                print("response over")
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
}
