//
//  ProvenanceApiHandler.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//


import Foundation
class ProvenanceApiHandler
{
    class func RequestProvenanceBody(Authorization:String,parameter: [String:Any], completion:@escaping ([String: String]) -> Void) {
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
                urlPatient = newString + "Provenance/"
        }
        }else{
            urlPatient = Config.WebAPI.Util.ProvenenceURL
        }
        DukeHealthApiHandler.RequestBody(Authorization:Authorization,parameters: parameter,Url:urlPatient) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Write FBC Provenance Api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                Config.ProvenenceResponse = response as! [String : Any]
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                // first of all convert json to the data
                
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
               let dataDic = json as? NSDictionary
                if(data!["url"] != nil)
                {
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                responseMap["success"] = (data!["success"] as! String)
                 completion(responseMap)
                }
                // responseMap["data"] = response
            } catch let myJSONError {
                print(myJSONError)
            }
          //  completion(responseMap)
        }
        
    }
    class func GetProvinenceBodyResponse(Authorization:String,url:String, completion:@escaping ([String: String]) -> Void) {
        var responseMap : [String: String] = ["Api":"Write FBC Provenance Api", "response":"{}", "success":"false", "url":""]
        DukeHealthApiHandler.GetConsentBody(Authorization:Authorization,Url:url) { (response, error, data) in
            
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                Config.ProvenenceResponse = response as! [String : Any]
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                // first of all convert json to the data
                
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                let dataDic = json as? NSDictionary
               
                //                let resource = dataDic!["id"] as? NSString
                //                Config.consentId = resource as! String
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                responseMap["success"] = (data!["success"] as! String)
                completion(responseMap)
                
                // responseMap["data"] = response as! String
            }catch let myJSONError {
                print(myJSONError)
            }
            
        }
       // completion(responseMap)
    }
}
