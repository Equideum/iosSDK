//
//  UtilApiHandler
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//
import Foundation
import Alamofire
import SwiftyJSON

/// The Utilities/Housekeeping API handlers.
class UtilApiHandler {
    
    /// Ping the FBC server Api call Handler
    ///
    /// - Parameter completion: completion description
    class func doPing(completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.ping(Url:Config.WebAPI.Util.pingPath) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Ping Api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                responseMap["success"] = (data!["success"] as! String)
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
    
    
    /// Invoke the GetTime API call Handler
    ///
    /// - Parameter completion: <#completion description#>
    class func getTime(completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.getTime(Url:Config.WebAPI.Util.getTimePath) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Get Time Api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (convertedString ?? "")
                responseMap["success"] = (data!["success"] as! String)
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
    
    
    /// Get the FBC Nodes Api call Handler
    ///
    /// - Parameter completion: completion description
    class func getNodes(completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.getNodes { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Get Nodes Api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                return;
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" +  (convertedString ?? "")
                responseMap["success"] = (data!["success"] as! String)
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
    /// Get the getEulaResponse Api call Handler
    ///
    /// - Parameter completion: completion description
    class func getEulaResponse(dic:String, completion: @escaping ([String: String])-> Void)-> Void{
        
        let dict =  dic
        
        var responseMap : [String: String] = ["Api":"Eula Api", "response":"{}", "success":"false", "url":""]
        
        let converted = dict.replacingOccurrences(of: "\nResponse:\n", with: "")
        var dictonary:NSDictionary?
        // let data = dict.data(using: String.Encoding.utf8)
        
        let data = converted.data(using: String.Encoding.utf8)
        
        do {
            let jsonResponse = try JSONSerialization.jsonObject(with:
                data!, options: []) as! [String: AnyObject]
            print(jsonResponse)
            let dataDic = jsonResponse as? NSDictionary
            let content = dataDic!["content"] as? NSArray
            
            for infoarray in content!
            {
                //  let resource = dataDic!["resource"] as? NSDictionary
                
                let dataDic = infoarray as? NSDictionary
                let attachment = dataDic!["attachment"] as? NSDictionary
                let url = attachment!["url"] as? String
                print(url!)
                let myURLString = attachment!["url"] as? NSString
                Config.AmazonURLEula = myURLString! as String
                print(Config.AmazonURLEula)
                guard let myURL = URL(string: myURLString! as String) else {
                    print("Error: \(myURLString) doesn't seem to be a valid URL")
                    return
                }
                do {
                    let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
                    
                    let convertedString = myHTMLString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                    responseMap["url"] = "\nUrl:\n" + url!
                    responseMap["response"] = "\nResponse:\n" + "{" + (convertedString ?? "\n" + "}")
                    responseMap["success"] = "true"
                    
                    
                    completion(responseMap)
                    
                } catch let error {
                    print("Error: \(error)")
                }
                
            }
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    /// Get the FBC EULA from the FHIR server Api call Handler
    ///
    /// - Parameter completion: Returns response from the server
    class func getEula(completion:@escaping ([String: String]) -> Void) {
        
        var responseMap : [String: String] = ["Api":"Eula Api", "response":"{}", "success":"false", "url":""]
        
        guard let url = URL(string: Config.WebAPI.Util.getEula + Config.EULaId)
            else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: []) as! [String: AnyObject]
                //   let stringurl = "\nUrl:\n" + Config.WebAPI.Util.getEula as? NSString
                let dict = jsonResponse as? NSDictionary
                let data1 =  try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let convertedString = String(data: data1, encoding: String.Encoding.utf8)
                responseMap["url"] = "\nUrl:\n" + Config.WebAPI.Util.getEula+Config.EULaId
                responseMap["response"] = "\nResponse:\n" +  (convertedString ?? "")
                responseMap["success"] = "true"
                completion(responseMap)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        }
        task.resume()
    }
    /// Get the Institutions from FHIR Server Api Call Handler
    ///
    /// - Parameter completion: Parse and get the response of InstitutionData
    
    class func ParseInsitutionName(Institution: String) -> String {
        
        if Config.ToDictionaryArray.count > 0
        { Config.ToDictionaryArray.removeAll()
            
        }
        
        
        do {
            let data = Institution.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            // print(json)
            let dataDic = json as? NSDictionary
            let resource = dataDic!["organizations"] as? NSArray
            
            for infoarray in resource!
            {
                let dataDic = infoarray as? NSDictionary
                
                let commonName = dataDic!["commonName"] as? String ?? ""
                let conformanceUrl = dataDic!["conformanceUrl"] as? String ?? ""
                let resourceServerURL = dataDic!["resourceServerUrl"] as? String ?? ""
                let  dict = ["commonName": commonName ,"conformanceUrl":conformanceUrl,"resourceServerUrl":resourceServerURL]
                Config.ToDictionaryArray.append(dict)
                
                
            }
            
            
            
        }catch let parsingError {
            print("Error", parsingError)
        }
        return Institution
    }
    
    /// <#Description#>
    ///Get Patient Resource Api call Handler
    /// - Parameters:
    ///   - Authorization: Bearer token from the server
    
    class func getPatientResource(Authorization:String,completion:@escaping ([String: String]) -> Void) {
        var Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
        var urlPatient = ""
        var comapare = "DukeRsTest"
        let name = Strcomonname?.replacingOccurrences(of: " ", with: "")
        if name?.lowercased() == comapare.lowercased()
        {
            let ResourceServerURL =  UserDefaults.standard.string(forKey: "resourceServerUrl")
            if (ResourceServerURL != nil)
            {
                let newString = ResourceServerURL!.replacingOccurrences(of: "metadata", with: "")
                urlPatient = newString + "Patient/" + Config.PatientId
                
            }
            
        }
            
        else{
            urlPatient = Config.WebAPI.Util.getpatientResource  + Config.PatientId
        }
        DukeHealthApiHandler.PatientResource(Url:urlPatient, Authorization:Authorization) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Get Patient Resource", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (data!["response"] as! String) + "\n"
                responseMap["success"] = (data!["success"] as! String)
                return completion(responseMap)
            }
            do {
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                if let dataDic = json as? NSDictionary
                {
                    if  let nameArr = dataDic["name"] as? NSArray
                    {
                        if nameArr.count > 0
                        {
                            for item in nameArr{
                                
                                if  let dataDict = item as? NSDictionary
                                {
                                    if  let extensionsList =  dataDict["given"] as? NSArray
                                    {
                                        
                                        if(extensionsList != nil )
                                        {
                                            Config.PatientName = extensionsList[0] as? NSString as! String
                                            
                                        }
                                        
                                    }
                                    if let commonName = dataDict["family"]  as? NSString
                                    {
                                        Config.FamilyName = commonName as! String
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                    responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                    responseMap["success"] = (data!["success"] as! String)
                    
                    
                    completion(responseMap)
                }
            } catch let myJSONError {
                print(myJSONError)
            }
            
        }
    }
    
    /// Get Institution Api call Handler
    ///
    /// - Parameter completion: Returns response of Institutions
    class func getInstitutions(completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.getInstitutions(Url:Config.WebAPI.Util.getInstitutions) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Get Institutions Api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (data!["response"] as! String) + "\n"
                responseMap["success"] = (data!["success"] as! String)
                return;
            }
            do {
                
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
                Config.organizations = response?["organizations"] as! [Any]
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                
                var allInstitutionsJson = JSON(parseJSON: convertedString ?? "")
                var apolloJsonObject = JSON(parseJSON: Config.apolloOrgJson)
                var finalInstitutionJson = addApolloInstitution(allInstitutionsJson: allInstitutionsJson, apolloJsonObject: apolloJsonObject)
                
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (finalInstitutionJson?.rawString() ?? "" )
                responseMap["success"] = (data!["success"] as! String)
                print(convertedString!)
                ParseInsitutionName(Institution: finalInstitutionJson?.rawString()! ?? "")
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
    
    class func addApolloInstitution(allInstitutionsJson: JSON , apolloJsonObject: JSON ) -> JSON? {
        // Loop through the array and add apollo
        var allInstitutionWithApollo : JSON? = nil
        do {
            allInstitutionWithApollo = try allInstitutionsJson.merged(with: apolloJsonObject)
        } catch let myJSONError {
            print(myJSONError)
        }
        return allInstitutionWithApollo
    }
    
    /// <#Description#>
    ///Audit Api Call Handler
    /// - Parameters:
    ///   - parameter: <#parameter description#>
    ///   - completion: <#completion description#>
    class func RequestAuditBody(parameter: [String:Any], completion:@escaping ([String: String]) -> Void) {
        
        DukeHealthApiHandler.RequestAuditBody(parameters: parameter,Url:Config.WebAPI.Util.AuditURL) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Write FBC Audit Api", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (data!["response"] as! String) + "\n"
                responseMap["success"] = (data!["success"] as! String)
                return completion(responseMap)
            }
            do {
                //Config.ProvenenceResponse = response as! [String : Any]
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                // first of all convert json to the data
                
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                let dataDic = json as? NSDictionary
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                responseMap["success"] = (data!["success"] as! String)
                // responseMap["data"] = response
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
        
    }
    
    /// <#Description#>
    ///Insert Demo data Api Call Handler for FHIR Server
    /// - Parameters:
    ///   - parameter: <#parameter description#>
    ///   - completion: <#completion description#>
    class func InsertDemoPatientResource(parameter: [String:Any], completion:@escaping ([String: String]) -> Void) {
        
        DukeHealthApiHandler.InsertDemoData(parameters: parameter,Url:Config.WebAPI.Util.DemoPatientResourceURL) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Demo Patient Resource", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (data!["response"] as! String) + "\n"
                responseMap["success"] = (data!["success"] as! String)
                return completion(responseMap)
            }
            do {
                //Config.ProvenenceResponse = response as! [String : Any]
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                // first of all convert json to the data
                
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                if let dataDic = json as? NSDictionary
                {
                    
                    Config.PatientId = dataDic["id"] as! String
                    responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                    responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                    responseMap["success"] = (data!["success"] as! String)
                    completion(responseMap)
                }
                
                // responseMap["data"] = response
            } catch let myJSONError {
                print(myJSONError)
            }
            
        }
    }
    
    class func InsertDemoEulaResource(parameter: [String:Any], completion:@escaping ([String: String]) -> Void) {
        
        DukeHealthApiHandler.InsertDemoData(parameters: parameter,Url:Config.WebAPI.Util.DemoEulaResourceURL) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Demo Eula Resource", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (data!["response"] as! String) + "\n"
                responseMap["success"] = (data!["success"] as! String)
                return completion(responseMap)
            }
            do {
                //Config.ProvenenceResponse = response as! [String : Any]
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                // first of all convert json to the data
                
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                if let dataDic = json as? NSDictionary
                {
                    Config.EULaId = dataDic["id"] as! String
                    responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                    responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                    responseMap["success"] = (data!["success"] as! String)
                    completion(responseMap)
                }
                
            } catch let myJSONError {
                print(myJSONError)
            }
            
        }
    }
    class func GetFHIRIdentifier(parameter: [String:Any], completion:@escaping ([String: String]) -> Void) {
        
        DukeHealthApiHandler.FhirIdentifierAssertion(parameters: parameter,Url:Config.WebAPI.Util.FHIRIdentifierURL) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Get FHIRIdentifier", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (data!["response"] as! String) + "\n"
                responseMap["success"] = (data!["success"] as! String)
                return completion(responseMap)
            }
            do {
                
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                // first of all convert json to the data
                
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                if  let dataDic = json as? NSDictionary
                {
                    let extensionsList =  dataDic["fhirIdentifiers"] as? NSArray
                    
                    if(extensionsList!.count > 0)
                    {
                        for info in extensionsList!
                        { let Datavalue = info as? NSDictionary
                            Config.PatientId = Datavalue!["fhirIdentifier"] as! String
                            Config.OrganizationId = Datavalue!["organization"] as! String
                        }
                    }
                    responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                    responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                    responseMap["success"] = (data!["success"] as! String)
                    
                }
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
    
    class func BeginAssertionApi(parameter: [String:Any], completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.FhirIdentifierAssertion(parameters:parameter,Url:Config.WebAPI.Util.BeginAssertion) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Begin Assertion", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (data!["response"] as! String) + "\n"
                responseMap["success"] = (data!["success"] as! String)
                return completion(responseMap)
            }
            do {
                //Config.ProvenenceResponse = response as! [String : Any]
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                let dataDic = json as? NSDictionary
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                responseMap["success"] = (data!["success"] as! String)
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
    class func FinishAssertionApi(parameter: [String:Any], completion:@escaping ([String: String]) -> Void) {
        DukeHealthApiHandler.FinishAssertion(parameters:parameter,Url:Config.WebAPI.Util.FinishAssertion) { (response, error, data) in
            var responseMap : [String: String] = ["Api":"Finish Assertion", "response":"{}", "success":"false", "url":""]
            guard error == nil else {
                /* error handler */
                
                responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                responseMap["response"] = "\nResponse:\n" + (data!["response"] as! String) + "\n"
                responseMap["success"] = (data!["success"] as! String)
                return completion(responseMap)
            }
            do {
                //Config.ProvenenceResponse = response as! [String : Any]
                let data1 =  try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
                // first of all convert json to the data
                let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                if  let dataDic = json as? NSDictionary
                {
                    Config.AuthCode = dataDic["authCode"] as! String
                    responseMap["url"] = "\nUrl:\n" + (data!["url"] as! String)
                    responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                    responseMap["success"] = (data!["success"] as! String)
                }
            } catch let myJSONError {
                print(myJSONError)
            }
            completion(responseMap)
        }
    }
    
    class func Getthetoken(completion:@escaping ([String: String]) -> Void)
    { var responseMap : [String: String] = ["Api":"Get Token", "response":"{}", "success":"false", "url":""]
        var headers = [String:String]()
        headers["Accept"] = "application/json"
        headers["Accept-Encoding"] = "gzip"
        headers["Content-Type"] = "application/fhir+json;charset=UTF-8"
        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(Config.AuthCode.data(using: .utf8)!, withName: "code")
            multipart.append("code".data(using: .utf8)!, withName :"grant_type")
        }, to: Config.WebAPI.Util.GetAuthToken, method: .post, headers: headers) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    let JSON = response.result.value as? NSDictionary
                    do {
                        //Config.ProvenenceResponse = response as! [String : Any]
                        let data1 =  try JSONSerialization.data(withJSONObject: response.result.value, options: JSONSerialization.WritingOptions.prettyPrinted)
                        // first of all convert json to the data
                        let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
                        let dataJson = convertedString?.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        let json = try JSONSerialization.jsonObject(with: dataJson!, options: [])
                        if let dataDic = json as? NSDictionary
                        {
                            Config.AuthToken = dataDic["token"] as! String
                            responseMap["url"] = "\nUrl:\n" + Config.WebAPI.Util.GetAuthToken
                            responseMap["response"] = "\nResponse:\n" + ( convertedString ?? "") + "\n"
                            responseMap["success"] = "true"
                            completion(responseMap)
                        }
                    } catch let myJSONError {
                        print(myJSONError)
                    }
                    
                    
                }
                upload.uploadProgress { progress in
                    
                    //call progress callback here if you need it
                }
            case .failure(let encodingError):
                print("multipart upload encodingError: \(encodingError)")
            }
        }
      //  completion(responseMap)
    }
    
}

