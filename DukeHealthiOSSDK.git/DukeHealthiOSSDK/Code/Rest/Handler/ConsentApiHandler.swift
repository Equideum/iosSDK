//
//  ConsentApiHandler.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//


import Foundation

class ConsentApiHandler
{
    class func RequestConsentBody(Authorization:String,parameter: [String:Any], completion:@escaping ([String: String]) -> Void) {
        //print(body as Any)
        var Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
        var urlPatient = ""
        var comapare = "DukeRsTest"
        let name = Strcomonname?.replacingOccurrences(of: " ", with: "")
        
        if name?.lowercased() == comapare.lowercased()
        {
            let ResourceServerURL =  UserDefaults.standard.string(forKey: "resourceServerUrl")
            if (ResourceServerURL != nil)
            {
                let newString = ResourceServerURL!.replacingOccurrences(of: "metadata", with: "")
                urlPatient = newString + "Consent/" 
            }
        }else{
            urlPatient = Config.WebAPI.Util.ConsentPostURL
        }
        DukeHealthApiHandler.RequestBody(Authorization:Authorization,parameters: parameter,Url:urlPatient) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Write FBC Consent Api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                if(data!["url"] != nil)
                {
                    responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                    responseMap["success"] = "true"
                    var locationURL = data!["url"] as! String
                    completion(responseMap)
                }
                
            } catch let myJSONError {
                print(myJSONError)
            }
        }
        
    }
    
    class func GetBodyResponse(Authorization:String,url:String, completion:@escaping ([String: String]) -> Void) {
        var responseMap : [String: String] = ["Api":"Write FBC Consent Api", "response":"{}", "success":"false", "url":""]
        DukeHealthApiHandler.GetConsentBody(Authorization:Authorization,Url:url) { (response, error, data) in
            
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                Config.ConsentResponse = response as! [String : Any]
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                // first of all convert json to the data
                
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                if  let dataDic = json as? NSDictionary
                {
                    responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                    responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                    responseMap["success"] = (data!["success"] as! String)
                    completion(responseMap)
                }
                
            }catch let myJSONError {
                print(myJSONError)
            }
            
        }
    }
    
    
}

