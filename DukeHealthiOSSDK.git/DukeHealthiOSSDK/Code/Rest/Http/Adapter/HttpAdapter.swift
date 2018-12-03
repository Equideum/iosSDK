//
//  HttpAdapter.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import Foundation
import Alamofire
import SwiftyJSON
//#if !os(OSX)
//import UIKit
//#endif


public protocol HttpAdapter
{
    func request(withBody: Bool , method: Alamofire.HTTPMethod, request: String, parameters: [String: AnyObject]?, completion: @escaping (AnyObject?, NSError?, [String: Any?]?) -> Void)
    
    func requestConsentBody(withBody: Bool ,method: Alamofire.HTTPMethod,Authorization:String,request: String, parameters: [String: AnyObject]?, completion: @escaping (AnyObject?, NSError?, [String: Any?]?) -> Void)
}
