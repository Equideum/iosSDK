//
//  Config.swift
//  DukeHealthiOSSDK
//
//  Created by Swathi on 12/09/18.
//  Copyright © 2018 Swathi. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    
    static let appItunesID = "1274987036"
    static let errorDomainName = "com.DukeHealthiOSSDK.unknown"
    static let defaultError = NSError(domain:Config.errorDomainName, code: 10000, userInfo: ["error_msg":"UnknownError"])
    static let userNotLoggedInCode = -11111
    
    struct AppColor {
        static let navigationBarColor = UIColor.colorWithHex(string: "#3A6D8F")
    }
    
}

//MARK: -
//MARK: API endpoints

extension Config {
    
    struct WebAPI {
        
        static let baseURL = "http://poc-node-1.fhirblocks.io:3002"
        
        struct Util {
            
            /* util/ping
            GET */
            static let pingPath = WebAPI.baseURL + "/util/ping"
            
            /* util/getTime
             GET */
            static let getTimePath = WebAPI.baseURL + "/util/getTime"
            
            /* util/getGUID */
            static let getGUIDPath = WebAPI.baseURL + "/util/getGUID"
            
            /* util/getTopology
             GET */
            static let getNodes = WebAPI.baseURL + "/util/getTopology"
            
            /* /institution
             GET */
            static let getInstitutions = WebAPI.baseURL + "/institution"
            
            /* /test/securityTest*/
            static let sendMessageToFBC = WebAPI.baseURL + "/test/securityTest"
            
            /* dcr */
            static let dcr = "http://poc-node-1.fhirblocks.io:9080/uma-server-webapp/register"
            
        }
    }
}
