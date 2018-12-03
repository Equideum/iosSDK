//
//  Config.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import Foundation
import UIKit

/// Config class - stores configurations of the code
struct Config {
    static var privateKey: SecKey? = nil;
    static var organizations = [Any?]()
    static var dcrResponse :[String:Any] = [:] //stores dcr response
    static var WebViewResponseList = [Any?]()
    static var InitialApiGroupGroupresponseList = [Any?]()
    static var GenerateKeyGroupResponseList = [Any?]()
    static var  ThirdGroupResponseList = [Any?]()
    static var  EulaGroupResponseList = [Any?]()
    static var PatientResourceGroupResponseList = [Any?]()
    static var ConsentGroupResponseList = [Any?]()
    static var ProvenancGroupResponseList = [Any?]()
    static var DemoDataGroupResponseList = [Any?]()
    static var AuditGroupResponseList = [Any?]()
    static var AssertionGroupResponseList = [Any?]()
    static var ToDictionaryArray : [[String: Any]] = []
    static var ConsentResponse : [String:Any] = [:]
    static var ProvenenceResponse : [String:Any] = [:]
    static var MultipleGroupData = [[Any?]]()
    static var InstitutionArrayName = [String]()
    static var JWTHeaderString = "{\"typ\":\"JWT\",\"alg\":\"ES256\"}"
    static var conformanceUrl = [String]()
    static var AppTitle = "Fhirblocks SDK Test App"
    static var ApiList = ["Ping","Get Time", "Get Nodes" , "Get Institutions", "Generate KeyPair", "Register Client with DCR" ,"Verify Crypto with Spook","Get FBC EULA", "Execute Oauth2 with IDP", "Authorize/Get token","Get Patient Resource","Write FBC Consent","Write FBC Provenance","Write FBC Audit"]
    static var ApiResposeItems = [false, false, false, false, false, false, false, false, false,false,false,false,false,false]
     static var ApiItems = [false, false, false, false, false, false, false, false, false,false,false,false,false,false]
    static var ApiActionItems = ["Reset", "View Badge", "View Logs", "Reset Logs"]
    static var PatientId = ""
    static var PatientName = ""
    static var FamilyName = ""
    static var consentId = ""
    static var AmazonURLEula = ""
    static var fhirIdentifier = ""
    static var SessionId = ""
    static var OrganizationId = ""
    static var AuthCode = ""
    static var AuthToken = ""
    static var EULaId = ""
    static var RedirectURI = "https://poc-node-1.fhirblocks.io/smoac/bind?"
    //static var executeAuthStaticURL = "http://192.168.0.226:9092"
    static var executeAuthStaticURL = "https://13.71.123.144:7001/login"
    static let appItunesID = "1274987036"
    static let errorDomainName = "com.DukeHealthiOSSDK.unknown"
    static let defaultError = NSError(domain:Config.errorDomainName, code: 10000, userInfo: ["error_msg":"UnknownError"])
    static let jsonDict = " { " +
        "organizationId" + ":" + "d5eaa749-7c5a-48e8-926f-cb047cb3a908" + "," +
        "resourceServerUrl" + ":" + "http://hapi.fhir.org/baseDstu3/" + "," +
        "commonName" + ":" + "Apollo" + "," +
        "idpUrl" + ":" +  "https://13.71.123.144:7001/login" + "," +
        "officialName" + ":" + "Apollo" + "," +
        "conformanceUrl" + ":" + "https://13.71.123.144:7001/login" + "," +
        "ehrType" + ":" + "epicTest" + "," +
        "ehrVersion" + ":" + "2018" + "}"
    static var Client_Id = ""
    static let oauthBearerToken = "Bearer 499f195d7dbc2c02c33054e2eb2ffc7d"
    static let authorizationHeaderName = "Authorization"
    static let apolloOrgJson = "{\"organizations\":[{\"organizationId\": \"d5eaa749-7c5a-48e8-926f-cb047cb3a908\",\"resourceServerUrl\": \"http://hapi.fhir.org/baseDstu3/\",\"commonName\": \"Apollo\",\"idpUrl\": \"https://13.71.123.144:7001/login\",\"officialName\": \"Apollo\",\"conformanceUrl\": \"https://13.71.123.144:7001/login\",\"ehrType\": \"epicTest\",\"ehrVersion\": \"2018\"}]}"
    
    static let userNotLoggedInCode = -11111
    static let DefaultText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce tristique auctor urna quis fermentum. Nullam convallis justo ac auctor luctus. Curabitur fermentum luctus diam, ut convallis nisi viverra scelerisque. Vestibulum at neque ut purus imperdiet aliquam. Suspendisse posuere ligula a nisl lobortis, ac vulputate libero volutpat. Pellentesque egestas nisi ut lacus iaculis, non blandit felis venenatis. Sed aliquam purus in lacus iaculis, blandit pretium massa ullamcorper. \n" +
        
    " Nulla facilisi. Donec commodo eu odio in fermentum. Nunc varius ultricies suscipit. Aliquam eget neque eu augue tincidunt fermentum id nec dolor. Aliquam in tortor tristique, condimentum dolor rhoncus, finibus urna. Mauris tincidunt laoreet tincidunt. Nunc id diam accumsan, consectetur mauris id, molestie sapien."
    static let WrongCredentialsText = "User entered wrong UserId and Password, auth token cannot be given."
    static let SuccessfullyLoginText = "User entered correct UserId and Password but allowed access, auth token can be given."
    static let UserDeniedAccessText = "User entered correct UserId and Password and denied access, auth token cannot be given."
    
    struct AppColor {
        static let navigationBarColor = UIColor.colorWithHex(string: "#256E91")
        static let navigationTintColor = UIColor.colorWithHex(string: "#ffffff")
        // let navigationBarColor = UIColor.colorWithHex(string: "#256E91")
    }
    
}

// MARK: - Config extension to store WebAPI
extension Config {
    
    struct WebAPI {
        
        static let baseURL = "https://poc-node-1.fhirblocks.io/smoac"
        
        struct Util {
            
            static let URLComponent =  "\nURL:"
            
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
            static let getInstitutions = WebAPI.baseURL + "/organization"
            /// EULA
            static let getEula =  "https://hapi.fhir.org/baseDstu3/DocumentReference/"
            /// /test/securityTest
            static let sendMessageToFBC = WebAPI.baseURL + "/test/securityTest"
            
            /// DCR
            static let dcr = "https://mitre.fhirblocks.io:444/uma-server-webapp/register"
            
            /// Patient resource
            static let getpatientResource = "http://hapi.fhir.org/baseDstu3/Patient/"
            
            /// POST Consent
            static let ConsentPostURL = "http://hapi.fhir.org/baseDstu3/Consent"
            /// Provenance
            static let ProvenenceURL = "http://hapi.fhir.org/baseDstu3/Provenance"
            /// Audit
            static let AuditURL = WebAPI.baseURL + "/audit/signedResource?"
            
            /// Demo patient resource URL
            static let DemoPatientResourceURL = "http://hapi.fhir.org/baseDstu3/Patient"
            /// Demo EULA
            static let DemoEulaResourceURL = "http://hapi.fhir.org/baseDstu3/DocumentReference"
            /// FHIRIdentifier
            static let FHIRIdentifierURL = "https://poc-node-1.fhirblocks.io/smoac/csi/signedJwtMessage"
            /// Begin assertion
            static let BeginAssertion = "https://poc-node-1.fhirblocks.io/smoac/oauth2/beginGetAssertion"
            /// Finish assertion
            static let FinishAssertion = "https://poc-node-1.fhirblocks.io/smoac/oauth2/finishGetAssertion"
            /// Get auth token
            static let GetAuthToken = "https://poc-node-1.fhirblocks.io/smoac/oauth2/token"
        }
    }
    
}
