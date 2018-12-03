//
//  ConformanceApiHandler.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//


import Foundation

class ConformanceApiHandler {
    /// - Parameter completion: completion description
    class func getConformanceStatement(url: String, completion:@escaping ([String: Any]) -> Void) {
        
        DukeHealthApiHandler.getConformanceStatement (parameters: url){ (response, error, data) in
            var responseMap : [String: Any] = ["Api":"Conformance Api", "response":"{}", "success":"false", "url":"",
                                               "data": {}]
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
                responseMap["data"] = response
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
        
    }
    
    class func getAuthEndPoint(response:[String:Any]) -> String {
        if (response["rest"] != nil) {
            let rest = response["rest"] as! [Any];
            if (rest.count > 0) {
                for restItem  in rest {
                    let restI = restItem as? [String: Any]
                    if (restI?["security"] != nil) {
                        let security = restI?["security"] as? [String: Any];
                        if (security?["extension"] != nil) {
                            let extensioN = security?["extension"] as! [Any];
                            if (extensioN.count > 0) {
                                for extensionItem in extensioN {
                                    let extensioNItem = extensionItem as? [String: Any];
                                    if (extensioNItem?["extension"] != nil) {
                                        let extensionsList = extensioNItem?["extension"] as! [Any] ;
                                        for extensionListItem in extensionsList {
                                            let extensioNListItem = extensionListItem as? [String: String];
                                            if (extensioNListItem?["url"] != nil) {
                                                if (extensioNListItem?["url"] == "authorize") {
                                                    return extensioNListItem?["valueUri"] ?? "";
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return "";
    }
}
