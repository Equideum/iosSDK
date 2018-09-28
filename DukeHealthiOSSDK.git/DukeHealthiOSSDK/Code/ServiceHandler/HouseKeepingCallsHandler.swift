//
//  HouseKeepingCallsHandler.swift
//  DukeHealthiOSSDK
//
//  Created by Swathi on 24/09/18.
//  Copyright © 2018 Swathi. All rights reserved.
//

import Foundation

class HouseKeepingCallsHandler {
    /**
     * calls ping service
     **/
    class func doPing(completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.ping { (response, error, data) in
            var responseMap : [String: String] = ["api":"Ping api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                responseMap["success"] = (data!["success"] as! String)
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
        
    }
    
    /**
     * calls Get Time service
     **/
    class func getTime(completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.getTime { (response, error, data) in
            var responseMap : [String: String] = ["api":"Get Time api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (convertedString ?? "")
                responseMap["success"] = (data!["success"] as! String)
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
    
    /**
     * calls Get Nodes service
     **/
    class func getNodes(completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.getNodes { (response, error, data) in
            var responseMap : [String: String] = ["api":"Get Nodes api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" +  (convertedString ?? "")
                responseMap["success"] = (data!["success"] as! String)
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
    
    /**
     * calls Get Institutions service
     **/
    class func getInstitutions(completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.getInstitutions { (response, error, data) in
            var responseMap : [String: String] = ["api":"Get Institutions api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (convertedString ?? "")
                responseMap["success"] = (data!["success"] as! String)
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
}
