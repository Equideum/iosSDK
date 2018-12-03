//
//  SpookApiHandler.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import Foundation
class SpookApiHandler {
    /**
     * Calls spook api
     **/
    class func sendSignedMessageToFBC(body:[String:String], completion:@escaping ([String: String]) -> Void) {
        print(body as Any)
        DukeHealthApiHandler.sendSignedMessageToFBC (parameters: body as [String : AnyObject]) { (response, error, data) in
            
            var responseMap : [String: String] = ["Api":"FBC Handshake Api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                print(error)
                
                responseMap["response"] = "\nResponse:\n" + error.debugDescription ?? ""
                print("in else")
                completion(responseMap)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "Params: \n" + Utilities.convertDictToJson(dictData:body)! + "\n Response: \n" +  (convertedString ?? "")
                responseMap["success"] = (data!["success"] as! String)
                print("response over")
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
}
