//
//  ProvenanccUtils.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import Foundation

class ProvenanccUtils
{

    /// <#Description#>
    /// This function is to get provenence object.its returns the dictionary
    
    /// - Parameters:
    ///   - consentId:it returns from consent response
    ///   - signatureString: JWt
    ///   - fhirIdentifier: patient identifier
    ///   - patientName: patientName
    ///   - csiGuid: patient id
    /// - Returns: dictionary
    class func getProvenanceObject(consentId:String,signatureString:String,fhirIdentifier:String,patientName:String
        ,csiGuid:String) ->[String:Any]
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var date = "2018-11-21T12:24:26.000Z"
        var provenenceObeject = [String: Any]()
        
        let resourceType = "Provenance"
        
        var target = [Any?]()
        let targetItem = ["reference" : "Consent/"+consentId,"display" : "Consent Number "+consentId]
        target.append(targetItem)
        
        
        var agent = [Any?]()
        let OrgReference = ["display":"Duke University Health"]
        var provenanceAgentComponent = ["whoReference":OrgReference]
        agent.append(provenanceAgentComponent)
        
        var theSignature = [Any?]()
        var signatureType = [Any?]()
        var c = ["code" : "1.2.840.10065.1.12.1.7"]
        signatureType.append(c)
        let SignatureReference = ["display":"Don Stone1","reference":"Patient/"+Config.PatientId]
        var signature = [String: Any]()
        signature = ["when":"2019-11-21T12:24:26.000Z","whoReference":SignatureReference,"contentType":"application/jwt","blob":signatureString,"type" : signatureType]
        theSignature.append(signature)
        var csiGuid = getClientCsiGuid()
        var theEntity = [Any?]()
        var ref = ["id":"csi/" + csiGuid,"display":"FHIRBlocks CSI GUID cd080307-db1d-4fea-9596-e0cb227e0e5e"]
        
        var provenanceEntityComponent = [String: Any]()
        provenanceEntityComponent = ["role":"source","whatReference":ref]
        theEntity.append(provenanceEntityComponent)
        
        
        provenenceObeject["resourceType"] = resourceType
        provenenceObeject["recorded"] = date
        provenenceObeject["agent"] = agent
        provenenceObeject["signature"] = signature
        provenenceObeject["entity"] = theEntity
        provenenceObeject["target"] = target
        
        return provenenceObeject
        
    }
    class  func getClientCsiGuid() -> String {
        let dataDic = Config.dcrResponse as? NSDictionary
        return dataDic!["client_id"] as! String
    }
}
