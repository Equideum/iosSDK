//
//  Uitilities.swift
//  DukeHealthiOSSDK
//
//  Created by Swathi on 28/09/18.
//  Copyright © 2018 Swathi. All rights reserved.
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
