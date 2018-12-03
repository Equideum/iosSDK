//
//  DukeHealthApiHandler.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import UIKit
import UICKeyChainStore
import Foundation

class DukeHealthApiHandler {
    
    /**
     * Request ping api
     **/
    class func ping(Url:String,completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        // let url = Config.WebAPI.Util.pingPath
        let adapter = HttpAdapterImpl()
        adapter.request(method: .get, request: Url, parameters: nil) { (info, error,data) in
            completion(info, error,data)
        }
    }
    /**
     * Request getTime api
     **/
    class func getTime(Url:String,completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        // let url = Config.WebAPI.Util.getTimePath
        let adapter = HttpAdapterImpl()
        adapter.request(method: .get, request: Url, parameters: nil) { (info, error, data) in
            completion(info, error,data)
        }
    }
    /**
     * Request getNodes api
     **/
    class func getNodes(completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        let url = Config.WebAPI.Util.getNodes
        let adapter = HttpAdapterImpl()
        adapter.request(method: .get, request: url, parameters: nil) { (info, error,data) in
            completion(info, error,data)
        }
    }
    /**
     * Request getInstitutions api
     **/
    class func getInstitutions(Url:String,completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        let adapter = HttpAdapterImpl()
        adapter.request(method: .get, request: Url, parameters: nil) { (info, error,data) in
            completion(info, error,data)
        }
    }
    
    /**
     * Request getPatientResource api
     **/
    
    
    /**
     * Request getEula api
     **/
    class func getEula(completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void)
    {
        // let url = Config.WebAPI.Util.getEula
        guard let url = URL(string: Config.WebAPI.Util.getEula)
            else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return
                    
            }
            completion(data as AnyObject, response as! Error,error as! [String : Any?])
        }
    }
    /**
     * Request sendSignedMessageToFBC api
     **/
    class func sendSignedMessageToFBC(parameters:[String:AnyObject], completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        let url = Config.WebAPI.Util.sendMessageToFBC
        let adapter = HttpAdapterImpl()
        adapter.request(method: .post, request: url, parameters: parameters) { (info, error,data) in
            completion(info, error,data)
        }
    }
    /**
     * Request doRegister api
     **/
    class func doRegister(parameters:[String:AnyObject] , completion:@escaping (AnyObject?, Error?, [String: Any?]?) -> Void) {
        let url = Config.WebAPI.Util.dcr
        let adapter = HttpAdapterImpl()
        adapter.request(method: .post, request: url, parameters: parameters) { (info, error,data) in
            completion(info, error,data)
        }
    }
    /**
     * Request getGUID api
     **/
    class func getGUID(completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        let url = Config.WebAPI.Util.getGUIDPath
        let adapter = HttpAdapterImpl()
        adapter.request(method: .get, request: url, parameters: nil) { (info, error, data) in
            completion(info, error, data)
        }
    }
    
    /**
     * Request getConformanceStatement api
     **/
    class func getConformanceStatement(parameters:String, completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        // let url = Config.WebAPI.Util.sendMessageToFBC
        let adapter = HttpAdapterImpl()
        adapter.request(method: .get, request: parameters, parameters: nil) { (info, error,data) in
            completion(info, error,data)
        }
    }
    
    /**
     * Request ConsentBody  api
     **/
    class func RequestBody(Authorization:String,parameters:[String:Any],Url:String, completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        // let url = Config.WebAPI.Util.ConsentPostURL
        let adapter = HttpAdapterImpl()
        adapter.requestConsentBody(method:.post,Authorization:Authorization,request: Url, parameters: parameters as [String : AnyObject]) { (info, error,data) in
            completion(info, error,data)
        }
        
    }
    class func GetConsentBody(Authorization:String,Url:String,completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        let adapter = HttpAdapterImpl()
        adapter.GetconsentBody(method:.get,Authorization:Authorization,request: Url, parameters:nil) { (info, error,data) in
            completion(info, error,data)
        }
    }
    class func RequestAuditBody(parameters:[String:Any],Url:String, completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        // let url = Config.WebAPI.Util.ConsentPostURL
        let adapter = HttpAdapterImpl()
        adapter.requestFhirIdentifier(method: .post, request: Url, parameters: parameters as [String : AnyObject]) { (info, error,data) in
            completion(info, error,data)
        }
        
    }
    
    class  func InsertDemoData(parameters:[String:Any],Url:String, completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        // let url = Config.WebAPI.Util.ConsentPostURL
        let adapter = HttpAdapterImpl()
        adapter.requestDemoBody(method: .post, request: Url, parameters: parameters as [String : AnyObject]) { (info, error,data) in
            completion(info, error,data)
        }
        
    }
    
    class  func FhirIdentifierAssertion(parameters:[String:Any],Url:String, completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        // let url = Config.WebAPI.Util.ConsentPostURL
        let adapter = HttpAdapterImpl()
        adapter.requestFhirIdentifier(method:.get, request: Url, parameters: parameters as [String : AnyObject]) { (info, error,data) in
            completion(info, error,data)
        }
        
    }
    
    class  func FinishAssertion(parameters:[String:Any],Url:String, completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        // let url = Config.WebAPI.Util.ConsentPostURL
        let adapter = HttpAdapterImpl()
        adapter.requestFhirIdentifier(method:.post, request: Url, parameters: parameters as [String : AnyObject]) { (info, error,data) in
            completion(info, error,data)
        }
        
    }
    
    class  func PatientResource(Url:String,Authorization:String,completion:@escaping (AnyObject? , Error?, [String: Any?]?) -> Void) {
        // let url = Config.WebAPI.Util.ConsentPostURL
        let adapter = HttpAdapterImpl()
        adapter.requestPatientResource(method:.get, Authorization:Authorization,request: Url, parameters:nil) { (info, error,data) in
            completion(info, error,data)
        }
        
    }
    
    /*
     
     SAMPLE REQUEST FOR GET WITH PARAMETERS
     
     class func getWishInfo(wishId:String, completion:@escaping (AnyObject? , Error?) -> Void){
     let url = Config.WebAPI.UserWishList.userWishPath.appending(wishId)
     WebServiceHandler.init().request(method: .get, request: url, parameters: nil) { (info, error) in
     completion(info, error)
     }
     }
     
     class func getOfferInfo(wishId:String, offerId:String, completion:@escaping (AnyObject? , Error?) -> Void){
     let url = Config.WebAPI.WishList.userNotificationsPath.appending(wishId).appending("/").appending(offerId)
     WebServiceHandler.init().request(method: .get, request: url, parameters: nil) { (info, error) in
     completion(info, error)
     }
     }
     
     SAMPLE REQUEST FOR DELETE WITH PARAMETERS
     
     class func deleteOffer(wishId:String,offerId:String, completion:@escaping (AnyObject? , Error?) -> Void){
     let url = Config.WebAPI.WishList.userNotificationsPath.appending(wishId).appending("/").appending(offerId)
     WebServiceHandler.init().request(method: .delete, request: url, parameters: nil) { (info, error) in
     completion(info, error)
     }
     }
     
     SAMPLE REQUEST FOR POST WITH PARAMETERS
     
     
     class func dislikeCategory(wishId:String, offerId:String, parameters:[String:String], completion:@escaping(AnyObject?,Error?)->Void) {
     let url = Config.WebAPI.WishList.userNotificationsPath + "\(wishId)" + "/\(offerId)"
     WebServiceHandler.init().request(method: .post, request: url, parameters:  parameters) { (response, error) in
     completion(response, error)
     }
     }
     
     class func editWishRequest(wishId:String, params:[String:Any], completion:@escaping (AnyObject? , Error?) -> Void){
     let url = Config.WebAPI.UserWishList.userWishPath.appending(wishId)
     WebServiceHandler.init().request(method: .post, request: url, parameters: params) { (info, error) in
     completion(info, error)
     }
     }
     
     class func updateWish(wishId:String, parameters:[String:String], completion:@escaping(AnyObject?,Error?)->Void) {
     let url = Config.WebAPI.UserWishList.userWishPath + "\(wishId)"
     WebServiceHandler.init().request(method: .post, request: url, parameters:  parameters) { (response, error) in
     completion(response, error)
     }
     }
     
     */
    
    class func generateKeys (base64EncodingOptions: Data.Base64EncodingOptions = []) -> String? {
        // Private Key Attributes Dictionary
        let privateKeyAttr = NSMutableDictionary.init()
        // Public Key Attributes Dictionary
        let publicKeyAttr = NSMutableDictionary.init()
        // Key Pair Attributes Dictionary
        let keyPairAttr = NSMutableDictionary.init()
        
        // Application Tags for Public & private
        let publicTag = "EC".data(using: .utf8)
        
        let privateTag = "EC".data(using: .utf8)
        
        
        keyPairAttr.setObject(kSecAttrKeyTypeECSECPrimeRandom, forKey:kSecAttrKeyType as! NSCopying)
        keyPairAttr.setObject(NSNumber.init(value:256), forKey:kSecAttrKeySizeInBits as! NSCopying)
        
        privateKeyAttr.setObject(NSNumber.init(value:true), forKey:kSecAttrIsPermanent as! NSCopying)
        privateKeyAttr.setObject(privateTag, forKey:kSecAttrApplicationTag as! NSCopying)
        
        publicKeyAttr.setObject(NSNumber.init(value:true), forKey:kSecAttrIsPermanent as! NSCopying)
        publicKeyAttr.setObject(publicTag, forKey:kSecAttrApplicationTag as! NSCopying)
        
        
        keyPairAttr.setObject(privateKeyAttr, forKey:kSecPrivateKeyAttrs as! NSCopying)
        keyPairAttr.setObject(publicKeyAttr, forKey:kSecPublicKeyAttrs as! NSCopying)
        
        var publicKey, privateKey: SecKey?
        // Keys Generation
        let err = SecKeyGeneratePair(keyPairAttr as CFDictionary, &publicKey, &privateKey);
        print(err);
        print("public key")
        print(publicKey as Any);
        print("private key")
        print(privateKey as Any);
        var error: Unmanaged<CFError>?
        
        let publicKeyDataAPI = SecKeyCopyExternalRepresentation(publicKey!, &error)! as Data
        var error1: Unmanaged<CFError>?
        
        let privateKeyDataAPI = SecKeyCopyExternalRepresentation(privateKey!, &error1)! as Data
        
        UICKeyChainStore.setData(privateKeyDataAPI, forKey: "PrivateKey")  // To store private key in keystore
        let signedMessage = createSignature(privateKey: privateKey!, value: "sample message")
        print("signed")
        print(signedMessage?.base64EncodedString(options: base64EncodingOptions));
        
        let data = SecKeyCopyExternalRepresentation(publicKey!, nil)
        struct myStruct {
            let firstString = "FirstValue"
            let secondString = "SecondValue"}
        
        let testStruct = myStruct()
        let mirror = Mirror(reflecting: publicKey)
        
        for case let (label?, value) in mirror.children {
            print (label + ":", value)
        }
        
        var mapData = [String: String] ()
        mapData["kty"] = "EC"
        mapData["crv"] = "P-256"
        mapData["x"] = "6D722A259364D4F7B86CD82FCF98A0CA32F74F4E98ED1285EDD6321212F00BE7"
        mapData["y"] = "CC59A3C00AC956998EDBA023901BE32CA3C399DD3E781CF205CF0F836AA82D62"
        let exportImportManager = CryptoExportImportManager.init()
        let e = exportImportManager.exportECPublicKeyToDER((publicKeyDataAPI as NSData) as Data, keyType: kSecAttrKeyTypeECSECPrimeRandom as String, keySize: 256)
        let derKeyString = e.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print("derkeystring")
        print(e)
        return derKeyString
       
        
    }
    
    class func getSignature(base64EncodingOptions: Data.Base64EncodingOptions = []) -> String? {
        let privateKeyData = UICKeyChainStore.data(forKey: "PrivateKey") as! Data
        
        let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                       kSecAttrApplicationTag as String: "EC".data(using: .utf8),
                                       kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                                       kSecReturnRef as String: true]
        
        let sizeInBits = privateKeyData.count * 8
        let keyDict: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
            kSecAttrKeySizeInBits: NSNumber(value: sizeInBits),
            kSecReturnPersistentRef: true
        ]
        
        var error: Unmanaged<CFError>?
        
        let privKey = SecKeyCreateWithData( privateKeyData as CFData, keyDict as CFDictionary, &error) as SecKey?
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else { print("error") ;return nil }
        let key = item as! SecKey
        print("private key")
        print(privKey as Any)
        let signedMessage = createSignature(privateKey: privKey!, value: "sample message")
        return signedMessage?.base64EncodedString(options: base64EncodingOptions);
    }
    
    
    class func createSignature(privateKey:SecKey, value: String, base64EncodingOptions: Data.Base64EncodingOptions = []) -> Data?
    {
        // Get private key by name using SecItemCopyMatching
        
        let algorithm = SecKeyAlgorithm.ecdsaSignatureMessageX962SHA256;
        
        let canSign = SecKeyIsAlgorithmSupported(privateKey, SecKeyOperationType.sign, algorithm)
        
        if(canSign) {
            let data = value.data(using: .utf8)!
            var error: Unmanaged<CFError>?
            guard let signedData = SecKeyCreateSignature(privateKey,
                                                         algorithm,
                                                         data as CFData,
                                                         &error) as Data? else
            {
                return nil
            }
            return signedData
        }
        else {
            return nil
        }
    }
    
    
}
