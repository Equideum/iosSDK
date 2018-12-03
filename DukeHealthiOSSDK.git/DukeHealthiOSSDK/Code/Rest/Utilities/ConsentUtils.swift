//
//  ConsentUtils.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import Foundation

class ConsentUtils
{
    class func getPatientObject(patientId : String, patientName : String) ->[String : String] {
        
        var responseMap : [String: String] = ["reference":"Patient/" + patientId, "display":patientName]
        return responseMap
    }
    
    /// Description
    ///
    /// - Parameters:
    ///   - startTime: <#startTime description#>
    ///   - endTime: <#endTime description#>
    /// - Returns: <#return value description#>
    class func getPeriodObject(startTime : String, endTime : String) ->[String : String] {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let startDate = dateFormatter.date(from: startTime) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        guard let endDate = dateFormatter.date(from: endTime) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        let myStartDate = dateFormatter.string(from: startDate)
        let myEndDate = dateFormatter.string(from: endDate)
        var periodObject : [String: String] = ["start": "2018-11-30T06:04:18.517Z", "end": "2100-11-22T12:24:26.000Z"]
        return periodObject
    }
    
    class  func prepareConsentBody(consentType:String,patientObject:[String : String],periodObject:[String : String],dateTime: String,status:String,reference:String,display:String,code:String,organizationDisplay:String,sourceReference:String,docReferenceId:String,sourceDisplay:String,eulaUrl:String,eulaTitle:String,thirdPartyConsents:[String],consentId:String)->[String : Any]   {
        var consentObject = [String: Any]()
        var consentingParty = [Any?]()
        consentingParty.append(patientObject)
        var organization = [Any?]()
        let organizationItem = ["display" : organizationDisplay]
        organization.append(organizationItem)
        var codingList = [Any?]()
        let codeItem = ["code":code]
        codingList.append(codeItem)
        
        var actionList =  [Any?]()
        var actionItem = ["coding":codingList]
        actionList.append(actionItem)
        
        let referenceObject = ["reference":reference, "display":display]
        let actorItem = ["reference":referenceObject]
        var actorList = [Any?]()
        actorList.append(actorItem)
        
        var categoryCodingList = [Any?]()
        let display = ["display": consentType]
        categoryCodingList.append(display)
        var CategoryList = ["coding" : categoryCodingList]
        var categoryList = [Any?]()
        categoryList.append(CategoryList);
        var meta = ["versionId": "1","lastUpdated": "2019-11-30T06:04:18.517Z"]
        var sourceAttachment = ["url": eulaUrl,"title": eulaTitle]
        consentObject["resourceType"] = "Consent";
        consentObject["meta"] = meta
        consentObject["status"] = status
        consentObject["category"] = categoryList
        consentObject["patient"] = patientObject
        consentObject["period"] = periodObject
        consentObject["dateTime"] = dateTime
        consentObject["consentingParty"] = consentingParty
        consentObject["actor"] = actorList
        consentObject["action"] = actionList
        consentObject["organization"] = organization
        consentObject["sourceAttachment"] = sourceAttachment
        return consentObject;
    }
    
    
    class func asString(jsonDictionary: [String:String]) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    class func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
}
