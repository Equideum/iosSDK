//
//  DirectClientRegistrationHandler.swift
//  DukeHealthiOSSDK
//
//  Created by Swathi on 21/09/18.
//  Copyright © 2018 Swathi. All rights reserved.
//

import Foundation
class DirectClientRegistrationHandler {
    /**
     * Calls DCR api
     **/
    class func doRegister(clientJwk:[String:String], userName: String , completion:@escaping ([String: String]) -> Void) {
        let dcrBody = getDcrBodyObject(clientJwk: clientJwk, userName: userName)
        DukeHealthApiHandler.doRegister (parameters: dcrBody as [String : AnyObject]) { (response, error, data) in
            var responseMap : [String: String] = ["api":"Client Registration api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = (data!["url"] as! String)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                responseMap["url"] = (data!["url"] as! String)
                responseMap["response"] = convertedString ?? ""
                responseMap["success"] = (data!["success"] as! String)
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
        return ["client_id" : nil,"client_secret":nil,"redirect_uris":["http://foo.com"],"client_name":nil,"client_uri":nil,"logo_uri":nil,"contacts":["user@example.com"],"tos_uri":nil,"token_endpoint_auth_method":"client_secret_basic","scope":"openid profile email address phone","grant_types":["authorization_code"],"response_types":["code"],"policy_uri":nil,"jwks_uri":nil,"jwks":nil,"jwksType":"URI","sector_identifier_uri":nil,"request_object_signing_alg":nil,"userinfo_signed_response_alg":nil,"userinfo_encrypted_response_alg":nil,"userinfo_encrypted_response_enc":nil,"id_token_signed_response_alg":nil,"id_token_encrypted_response_alg":nil,"id_token_encrypted_response_enc":nil,"default_max_age":60000,"require_auth_time":nil,"default_acr_values":[],"initiate_login_uri":nil,"post_logout_redirect_uris":[],"claims_redirect_uris":[],"request_uris":[],"software_statement":nil,"software_id":nil,"software_version":nil,"code_challenge_method":nil,"registration_access_token":nil,"registration_client_uri":nil,"softwareId":nil,"softwareVersion":nil,"token_endpoint_auth_signing_alg":nil] as [String : Any?]
    }
    
    /**
     * Prepares dcr body object
     **/
    class func getDcrBodyObject(clientJwk: [String: String], userName: String) -> [String: Any] {
        var dcrBody: [String: Any] = DirectClientRegistrationHandler.getDCRStaticBody()
        var ja  = [String]()
        ja.append(userName)
        dcrBody["contacts"] = ja
        dcrBody["software_id"] = "sdk"
        
        dcrBody["jwks"] = ["keys":[clientJwk]]
        return dcrBody
    }
}
