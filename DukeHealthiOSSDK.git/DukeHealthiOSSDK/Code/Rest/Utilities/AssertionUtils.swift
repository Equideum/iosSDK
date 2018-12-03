//
//  AssertionUtils.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import Foundation
class AssertionUtils {
   
   class func getOrganizationId() -> String {
      //  print("organization name");
       // print(organizationName)
        print(Config.organizations)
        for infoarray in Config.organizations {
            let dataDic = infoarray as? NSDictionary
            print("organizations");
            print(dataDic)
            let name = dataDic!["commonName"] as! String;
           // if (name == organizationName) {
                return dataDic!["organizationId"] as! String;
           // }
        }
        return "";
    }
    
class func getHeaderString() -> String  {
    return Config.JWTHeaderString
    }
    
  class  func getClientId() -> String {
        let dataDic = Config.dcrResponse as? NSDictionary
        return dataDic!["client_id"] as! String
    }
    
  class  func getParamsObject(organizationId:String,clientId:String,patientId:String,scope:String,
       state:String,aud:String,redirect_uri:String,responseType:String) -> [String:Any]{
     var ParamsObject = [String:Any]()
       ParamsObject["patient_id"] = patientId
       ParamsObject["organization_id"] = organizationId
       ParamsObject["scope"] = scope
       ParamsObject["state"] = state
       ParamsObject["aud"] = aud
       ParamsObject["redirect_uri"] = redirect_uri
       ParamsObject["response_type"] = responseType
       ParamsObject["client_id"] = clientId
        return ParamsObject
    }
    
    class func getFhirIdentifier() ->[String:Any]
    {
        var clientId = getClientId()
        var tokenParams = ["csiGuid" : clientId,"command" : "getFhirIdentifier"]
        return tokenParams
    }
    
    class func doBeginAssertion(patientId:String,organizationId:String) ->[String:Any]{
       // var organizationId = getOrganizationId()
        var clientId = getClientId()
        let params = getParamsObject(organizationId: organizationId, clientId: clientId,patientId:patientId, scope: "patient/patient.read consent.write provenance.write openid profile email address phone", state: "2312321",
                                     aud: "238123", redirect_uri: "", responseType: "wanish")
        return params
    }
    
    class func FinishAssertion(BeginAssertionResponse:String) ->[String:Any]{
        let dict =  BeginAssertionResponse
        var SessionObject = [String:Any]()
        var id = ""
        var challenge = ""
        var state = ""
        var origin = ""
        let converted = dict.replacingOccurrences(of: "\nResponse:\n", with: "")
        var dictonary:NSDictionary?
        // let data = dict.data(using: String.Encoding.utf8)
        let data = converted.data(using: String.Encoding.utf8)
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with:
                data!, options: []) as! [String: AnyObject]
            print(jsonResponse)
                        let dataDic = jsonResponse["session"] as? NSDictionary
                         id = dataDic!["id"] as? String ?? ""
                        Config.SessionId = id
                         challenge = dataDic!["challenge"] as? String ?? ""
                         state = dataDic!["state"] as? String ?? ""
                         origin = dataDic!["origin"] as? String ?? ""
            
            SessionObject["id"] = id
            SessionObject["authCode"] = ""
            SessionObject["challenge"] = challenge
            SessionObject["origin"] = origin
            SessionObject["state"] = state
           
            }
            catch let error as NSError {
            print(error)
        }
         return SessionObject
    }
}
