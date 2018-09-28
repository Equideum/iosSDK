//
//  KeyUtils.swift
//  DukeHealthiOSSDK
//
//  Created by Swathi on 24/09/18.
//  Copyright © 2018 Swathi. All rights reserved.
//

import Foundation
import UICKeyChainStore
class KeyUtils {
    /**
     * generates keys with EC algorithm
     **/
    class func generateKeys() -> (publicKey:SecKey, privateKey:SecKey) {
        // Private Key Attributes Dictionary
        let privateKeyAttr = NSMutableDictionary.init()
        // Public Key Attributes Dictionary
        let publicKeyAttr = NSMutableDictionary.init()
        // Key Pair Attributes Dictionary
        let keyPairAttr = NSMutableDictionary.init()
        
        // Application Tags for Public & private
        let publicTag = "EC".data(using: .utf8)
        
        let privateTag = "EC".data(using: .utf8)
        
        
        keyPairAttr.setObject(kSecAttrKeyTypeEC, forKey:kSecAttrKeyType as! NSCopying)
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
        
        KeyUtils.storeKeys(privateKey: privateKey!, publicKey: publicKey!) // store keys
        print(publicKey as Any)
        return (publicKey!, privateKey!)
    }
    
    /**
     *  stores private and public keys using UIKeyChain
     **/
    class func storeKeys(privateKey: SecKey, publicKey: SecKey) {
        var error: Unmanaged<CFError>?
        var error1: Unmanaged<CFError>?
        let publicKeyDataAPI = SecKeyCopyExternalRepresentation(publicKey, &error)! as Data
        let privateKeyDataAPI = SecKeyCopyExternalRepresentation(privateKey, &error1)! as Data
        
        UICKeyChainStore.setData(privateKeyDataAPI, forKey: "PrivateKey")
        UICKeyChainStore.setData(publicKeyDataAPI, forKey: "PublicKey")
    }
    
    /**
     * convert given key to jwk form
     **/
    class func convertSecKeyToJwk(key: SecKey) ->([String: String]){
        let attr = SecKeyCopyAttributes(key)
        var encodedX : String = ""
        var encodedY : String = ""
        var jwk : [String: String] = ["crv":"P-256", "kty":"EC", "x":"", "y":"", "z":""]
        if let dict = attr as? [String: AnyObject] {
            let xAndY = dict["v_Data"] as! NSData
            let stringData = (xAndY .description).replacingOccurrences(of: " ", with: "") as String
            let endIndex = stringData.index(stringData.endIndex, offsetBy: -1)
            let substringData = stringData[..<endIndex]
            let y = substringData.suffix(64)
            let x = substringData.replacingOccurrences(of: y, with: "").suffix(64)
            encodedX = KeyUtils.convertToServerEncodedData(hexData: String(x))
            encodedY = KeyUtils.convertToServerEncodedData(hexData: String(y))
            
            jwk["x"] = encodedX
            jwk["y"] = encodedY
            jwk["z"] = KeyUtils.convertKeyToDerBase64(key: key)
        }
        
        return jwk
    }    
    
    /**
     * Converts hexaDecimal data to base64encoded string
     **/
    class func convertToServerEncodedData(hexData : String) -> String {
        let base64 = hexData.data(using: .bytesHexLiteral)?.base64EncodedString()
        if let base64 = base64 {
            print(base64)
        }
        
        return base64!
    }
    
    /**
     * prepares spook api body
     **/
    class func getSpookBody(privateKey: SecKey, clientJwk: [String: String], base64EncodingOptions: Data.Base64EncodingOptions = []) {
        let signedMessage = KeyUtils.createSignature(privateKey: privateKey, value: "sample message")
        let signedMessageInBase64 = signedMessage?.base64EncodedString(options: base64EncodingOptions);
        
        let clientJwkString = KeyUtils.convertDictToJson(dictData: clientJwk);
        let encodedJwk = clientJwkString?.base64EncodedString(options: base64EncodingOptions);
        
        print(signedMessageInBase64)
        print(encodedJwk)
    }
    
    /**
     * converts dictionary to jsonString
     **/
    class func convertDictToJson(dictData: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: JSONSerialization.WritingOptions.prettyPrinted)
            return jsonData
           // return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            
        }
        return nil
    }
    
    /**
     * creates signature with given private key
     **/
    class func createSignature(privateKey:SecKey, value: String, base64EncodingOptions: Data.Base64EncodingOptions = []) -> Data? {
        let algorithm = SecKeyAlgorithm.ecdsaSignatureMessageX962SHA256;
        let canSign = SecKeyIsAlgorithmSupported(privateKey, SecKeyOperationType.sign, algorithm)
        if(canSign) {
            let data = value.data(using: String.Encoding.utf8)!
            var error: Unmanaged<CFError>?
            guard let signedData = SecKeyCreateSignature(privateKey,
                                                         algorithm,
                                                         data as CFData,
                                                         &error) as Data? else
            {
                return nil
            }
            // print(signedData.base64EncodedString(options: base64EncodingOptions))
            return signedData
            //return signedData.base64EncodedString(options: base64EncodingOptions)
        }
        else {
            return nil
        }
    }
    
    class func verifySignature(privateKey: SecKey, signature: Data, value: String) {
        var error: Unmanaged<CFError>?
        guard let val = SecKeyVerifySignature(privateKey, SecKeyAlgorithm.ecdsaSignatureMessageX962SHA256,
                                              value.data(using: .utf8)! as! CFData, signature as CFData, &error) as Bool? else {
                print("in side")
                            
        }
        if (val) {
            print("true")
        } else {
            print("false")
        }
        
    }
    
    /**
     * Sign message .
     *  1. convert message to base64
     *  2. convert header to base64
     *  3. form payload with base64header + . + base64message.
     *  4. sign payload with ES256 algorithm.
     *  5. form jwo with base64header.base64message.signature
     **/
    class func signMessage(message: String, privateKey: SecKey, publicKey: SecKey) -> (String, [Any?]) {
        var responseList = [Any?]()
        
        
        let base64Header = KeyUtils.createJWsHeader()
        var base64HeaderPayload = [String:Any]()
        base64HeaderPayload["api"] = "Base64Url converted header";
        base64HeaderPayload["response"] = base64Header
        base64HeaderPayload["success"] = "true"
        base64HeaderPayload["url"] = ""
        responseList.append(base64HeaderPayload)
         print("base64urlEncoded header")
        print(base64Header)
        
        let messageInData = message.data(using: String.Encoding.utf8) // utf8 converted message
        let base64Payload = messageInData?.base64urlEncodedString()
        var messagePayload = [String:Any]()
        messagePayload["api"] = "Base64Url converted message";
        messagePayload["response"] = base64Payload
        messagePayload["success"] = "true"
        messagePayload["url"] = ""
        responseList.append(messagePayload)
        
        print("base64urlEncoded message")
        print(base64Payload)
        
        let signature = createSignature(privateKey: privateKey, value: base64Header + "." + base64Payload!)
         let base64Signature = signature?.base64urlEncodedString()
        var signaturePayload = [String:Any]()
        signaturePayload["api"] = "Base64Url converted message";
        signaturePayload["response"] = base64Signature
        signaturePayload["success"] = "true"
        signaturePayload["url"] = ""
        responseList.append(signaturePayload)
        
        print("base64urlEncoded signature")
        print(base64Signature)
        
        KeyUtils.verifySignature(privateKey: publicKey, signature: signature!, value: base64Header + "." + base64Payload!)
       
        
        var jwoPayload = [String:Any]()
        jwoPayload["api"] = "JWS object ";
        jwoPayload["response"] = base64Header + "." + base64Payload! + "." + base64Signature!
        jwoPayload["success"] = "true"
        jwoPayload["url"] = ""
        responseList.append(jwoPayload)
        
        return ((base64Header + "." + base64Payload! + "." + base64Signature!), responseList)
    }
    
    class func createJWsHeader() -> String {
        let header = "{\"alg\":\"ES256\"}"
        print((header.data(using: String.Encoding.utf8))?.base64urlEncodedString())
        return ((header.data(using: String.Encoding.utf8))?.base64urlEncodedString())!
    }
    
//    class func dictToBase64String(dictData: [String: String]) -> String? {
//         let jsonData = KeyUtils.convertDictToJson(dictData: dictData)
//        return jsonData!.base64EncodedString() as String
//    }
    
    /**
     * converts key to DER then encodes in base64
     **/
    class func convertKeyToDerBase64(key: SecKey) -> String {
        // converting public key to DER format
        var error: Unmanaged<CFError>?
        let publicKeyDataAPI = SecKeyCopyExternalRepresentation(key, &error)! as Data
        let exportImportManager = CryptoExportImportManager.init()
        let exportableDERKey = exportImportManager.exportPublicKeyToDER((publicKeyDataAPI as NSData) as Data, keyType: kSecAttrKeyTypeEC as String, keySize: 256)
        let publicKeyDerKeyString = exportableDERKey?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print("public key der string")
        print(publicKeyDerKeyString)
        return publicKeyDerKeyString!
    }
}

extension String {
    /// Expanded encoding
    ///
    /// - bytesHexLiteral: Hex string of bytes
    /// - base64: Base64 string
    enum ExpandedEncoding {
        /// Hex string of bytes
        case bytesHexLiteral
        /// Base64 string
        case base64
    }
    
    /// Convert to `Data` with expanded encoding
    ///
    /// - Parameter encoding: Expanded encoding
    /// - Returns: data
    func data(using encoding: ExpandedEncoding) -> Data? {
        switch encoding {
        case .bytesHexLiteral:
            guard self.characters.count % 2 == 0 else { return nil }
            var data = Data()
            var byteLiteral = ""
            for (index, character) in self.characters.enumerated() {
                if index % 2 == 0 {
                    byteLiteral = String(character)
                } else {
                    byteLiteral.append(character)
                    guard let byte = UInt8(byteLiteral, radix: 16) else { return nil }
                    data.append(byte)
                }
            }
            return data
        case .base64:
            return Data(base64Encoded: self)
        }
    }
}
