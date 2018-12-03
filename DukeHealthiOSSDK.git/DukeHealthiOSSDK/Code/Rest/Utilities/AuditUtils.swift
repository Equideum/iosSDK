//
//  AuditUtils.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import Foundation
class AuditUtils {
    
    /// <#Description#>
    ///This function is to get Audit Object using the Provinence Signature response
    /// - Parameters:
    ///   - csiGuid: patient csiGuid
    ///   - signatureString: Signature of Provinence
    /// - Returns: dictionary object
    class func getAuditObject(csiGuid:String,signatureString:String)->[String:Any]
    {
        var auditObject = [String:Any]()
        auditObject =  ["signedJsonWebObject" : signatureString,"csiGuid" : csiGuid]
        return auditObject
        
    }
}
