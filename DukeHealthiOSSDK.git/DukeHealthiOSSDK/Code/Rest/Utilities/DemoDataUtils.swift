//
//  DemoDataUtils.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import Foundation

class DemoDataUtils{
    
    /// <#Description#>
    /// This function is to create the Patient Obejct using the Patient Resource
    /// - Returns: Dictionary of Patient Object
    class func getPatientResourceDeoObject()->[String:Any]
    {
        var PatientResourceObeject = [String: Any]()
        let resourceType = "Patient"
        let id = "530472"
        var meta = ["versionId": "1","lastUpdated": "2019-11-21T12:24:26.000Z"]
        var text = ["status" : "generated","div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><div class=\"hapiHeaderText\">Fhirblocks</div><table class=\"hapiPropertyTable\"><tbody></tbody></table></div>"]
        var telecom = ["system" : "phone","value":"56-555-1212","use":"home"]
        var telecomArr = [Any?]()
        telecomArr.append(telecom)
        var theName = [Any?]()
        var givenName = [Any?]()
        givenName.append("Fhirblocks")
        var familyComponent = [String: Any]()
        familyComponent = ["family":"Apollo"]
        var NameComponent = ["given" : givenName]
        theName.append(NameComponent)
        theName.append(familyComponent)
        PatientResourceObeject["resourceType"] = resourceType
        PatientResourceObeject["id"] = id
        PatientResourceObeject["meta"] = meta
        PatientResourceObeject["text"] = text
        PatientResourceObeject["name"] = theName
        PatientResourceObeject["telecom"] = telecomArr
        return PatientResourceObeject
    }
    
    class func getDemoEulaResource()->[String: Any]{
        
        var EulaResourceObeject = [String: Any]()
        let resourceType = "DocumentReference"
        let id = "fbceula"
        let status = "current"
        let docStatus = "final"
        let description = "FHIRBlocks EULA"
        
        var attachmentComponent = ["language" : "en-US", "url" : "https://s3-us-west-2.amazonaws.com/fhirblocksdocs/fbc/v1/doc.html","title":"EULA"]
        var attachment = ["attachment" : attachmentComponent]
        var attachementArr = [Any?]()
        attachementArr.append(attachment)
        EulaResourceObeject["resourceType"] = resourceType
        EulaResourceObeject["id"] = id
        EulaResourceObeject["status"] = status
        EulaResourceObeject["docStatus"] = docStatus
        EulaResourceObeject["description"] = description
        EulaResourceObeject["content"] = attachementArr
        return EulaResourceObeject
    }
}
