//
//  DirectClientRegistrationHandler.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//
import Foundation
class DirectClientRegistrationHandler {
    /**
     * Calls DCR api
     **/
    class func doRegister(pubKey: SecKey, clientJwk:[String:String], userName: String , completion:@escaping ([String: String]) -> Void) {
        let base64PubKey = DirectClientRegistrationHandler.convertKeyToDerBase64(key: pubKey)
        let dcrBody = getDcrBodyObject(pubKey: base64PubKey, clientJwk: clientJwk, userName: userName)
        print("dcr body")
        print(dcrBody as Any)
        DukeHealthApiHandler.doRegister (parameters: dcrBody as [String : AnyObject]) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Client Registration api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                let dataDic = json as? NSDictionary
                let client_id = dataDic!["client_id"] as? String ?? ""
                Config.Client_Id = client_id
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "Params: \n" + Utilities.convertDictToJson(dictData:dcrBody)! + "\nResponse:\n" + (convertedString ?? "")
                responseMap["success"] = (data!["success"] as! String)
                Config.dcrResponse = response as! [String : Any];
                print("dcr data")
                print(Config.dcrResponse)
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
    
    /**
     * Prepares DCR static body.
     **/
    class func getDCRStaticBody() -> ([String: Any]) {
        return ["client_id" : nil,"client_secret":nil,"redirect_uris":["http://foo.com"],"client_name":nil,"client_uri":nil,"logo_uri":nil,"contacts":["user@example.com"],"tos_uri":nil,"token_endpoint_auth_method":"client_secret_basic","scope":"patient/patient.read consent.write provenance.write openid profile email address phone","grant_types":["authorization_code"],"response_types":["code"],"policy_uri":nil,"jwks_uri":nil,"jwks":nil,"jwksType":"URI","sector_identifier_uri":nil,"request_object_signing_alg":nil,"userinfo_signed_response_alg":nil,"userinfo_encrypted_response_alg":nil,"userinfo_encrypted_response_enc":nil,"id_token_signed_response_alg":nil,"id_token_encrypted_response_alg":nil,"id_token_encrypted_response_enc":nil,"default_max_age":60000,"require_auth_time":nil,"default_acr_values":[],"initiate_login_uri":nil,"post_logout_redirect_uris":[],"claims_redirect_uris":[],"request_uris":[],"software_statement":nil,"software_id":nil,"software_version":nil,"code_challenge_method":nil,"registration_access_token":nil,"registration_client_uri":nil,"softwareId":nil,"softwareVersion":nil,"token_endpoint_auth_signing_alg":nil] as [String : Any?]
    }
    
    /**
     * Prepares dcr body object
     **/
    class func getDcrBodyObject(pubKey: String, clientJwk: [String: String], userName: String) -> [String: Any] {
        var dcrBody: [String: Any] = DirectClientRegistrationHandler.getDCRStaticBody()
        var ja  = [String]()
        ja.append(userName)
        dcrBody["contacts"] = ja
        dcrBody["software_id"] = "sdk"
        
        
        
        var keys = [Any?]()
        keys.append(clientJwk);
        
        var addtionalMembers  = [String: Any] ()
        addtionalMembers["z"] = pubKey
        
        var jwks = [String: Any] ()
        jwks["keys"] = keys
       // jwks["additionalMembers"] = addtionalMembers
        jwks["z"] = pubKey
        dcrBody["jwks"] = jwks
        return dcrBody
    }
    
    /**
     * converts key to DER then encodes in base64
     **/
    class func convertKeyToDerBase64(key: SecKey) -> String {
        // converting public key to DER format
        var error: Unmanaged<CFError>?
        let publicKeyDataAPI = SecKeyCopyExternalRepresentation(key, &error)! as Data
        let exportImportManager = CryptoExportImportManager.init()
        let exportableDERKey = exportImportManager.exportPublicKeyToDER((publicKeyDataAPI as NSData) as Data, keyType: kSecAttrKeyTypeEC as String, keySize: 256)
        let publicKeyDerKeyString = exportableDERKey?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print("public key der string")
        print(publicKeyDerKeyString)
        return publicKeyDerKeyString!
    }
    
}
