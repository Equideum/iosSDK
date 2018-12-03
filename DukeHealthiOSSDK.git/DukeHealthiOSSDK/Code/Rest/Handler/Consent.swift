//
//  Consent.swift
//  DukeHealthiOSSDK
//
//  Created by  on 11/21/18.
//

import Foundation
class Consent {
    var resourceType: String
    var status: String
    var category: CategoryCode[]
    
    Consent consent = Consent()
    consent.setResourceType("Consent")
    consent.setStatus("active")
    
    Encoder encoder = JSONEncoder()
    String jsong = encoder.encode(consent)
    
}
