//
//  Uitilities.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import Foundation
class Utilities {
    /**
     * converts dictionary to jsonString
     **/
    class func convertDictToJson(dictData: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: JSONSerialization.WritingOptions.prettyPrinted)
            //return jsonData
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            
        }
        return nil
    }
}
