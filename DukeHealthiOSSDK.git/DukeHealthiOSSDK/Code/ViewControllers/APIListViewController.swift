//
//  APIListViewController.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import UIKit
import ZAlertView
import base64url
import Toast_Swift


var clientKey: SecKey? = nil;
var privateKey: SecKey? = nil;
var clientJwk: [String: String] = [:]
var apiResponseItems = [Bool]()
var apiItems = [Bool]()
var dynamicClientRegistration : [String: AnyObject] = [:]
var temp = [String: Any] ()
var bodyDict = [String: Any] ()
var insertDemoData = false
var  reloadStr =  String()
/// API List view controller class. This class handles all the actions on the UI
/// and links it to the corresponding handlers.
class APIListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var apiListTableView: UITableView!
    @IBOutlet weak var actionButtonsCollectionView: UICollectionView!
    
    var apiList:[String]?
    var actionItems:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor =  UIColor(red: 37/255, green: 110/255, blue: 145/255, alpha: 1.0)
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.navigationBar.tintColor = Config.AppColor.navigationTintColor
        self.navigationItem.title = Config.AppTitle
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        // Do any additional setup after loading the view.
        apiList = Config.ApiList
        apiResponseItems = Config.ApiResposeItems
        actionItems = Config.ApiActionItems
        apiItems = Config.ApiItems
        alertViewCofig()
    }
    
    /// Alert view configurations
    func alertViewCofig() {
        ZAlertView.positiveColor            = UIColor.color("#669999")
        ZAlertView.negativeColor            = UIColor.color("#CC3333")
        ZAlertView.blurredBackground        = true
        ZAlertView.showAnimation            = .bounceBottom
        ZAlertView.hideAnimation            = .bounceBottom
        ZAlertView.initialSpringVelocity    = 0.9
        ZAlertView.duration                 = 2
        ZAlertView.textFieldTextColor       = UIColor.brown
        ZAlertView.textFieldBackgroundColor = UIColor.color("#EFEFEF")
        ZAlertView.textFieldBorderColor     = UIColor.color("#669999")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Number of APIs
    ///
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: section
    /// - Returns: Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiList?.count ?? 0
    }
    
    /// Populate each row in the table view
    ///
    /// - Parameters:
    ///   - tableView: Table view
    ///   - indexPath: Index path
    /// - Returns: UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "APIListCell") as! ApiItemTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.ApiListIndicator.isHidden = true
        cell.ApiListIndicator.stopAnimating()
        let currentCell = "\(indexPath.row)"
        if  reloadStr == currentCell
        {
            // reloadStr = ""
            cell.ApiListIndicator.isHidden = false
            cell.ApiListIndicator.startAnimating()
        }else
        {
            cell.ApiListIndicator.isHidden = true
            cell.ApiListIndicator.stopAnimating()
        }
        if apiResponseItems[indexPath.row] {
           
            cell.apiResponseImage.image = #imageLiteral(resourceName: "radioOn")
        } else {
            cell.apiResponseImage.image = #imageLiteral(resourceName: "radioOff")
        }
        cell.apiNameLabel.text = apiList?[indexPath.row]
       
        return cell
    }
    /// Triggered when user selects a row
    ///
    /// - Parameters:
    ///   - tableView: Table view
    ///   - indexPath: Selected row's index
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        //Ping API Call
           
        case ApiListConstants.PING_API_CALL:
             reloadStr = "\(indexPath.row)"
            let indexPath = IndexPath(item: 0, section:0)
            self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            UtilApiHandler.doPing { (pingResponse) in
                
                if pingResponse["success"] == "true" {
                    reloadStr = ""
                    apiResponseItems[0] = true
                } else {
                     reloadStr = ""
                     apiResponseItems[0] = false
                }
               
                Config.InitialApiGroupGroupresponseList.append(pingResponse)
                let indexPath = IndexPath(item: 0, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case ApiListConstants.GET_TIME:
             reloadStr = "\(indexPath.row)"
             let indexPath = IndexPath(item: 1, section:0)
             self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            UtilApiHandler.getTime { (getTimeResponse) in
               // reloadStr = ""
                if getTimeResponse["success"] == "true" {
                     reloadStr = ""
                    apiResponseItems[1] = true
                } else {
                    reloadStr = ""
                    apiResponseItems[1] = false
                }
                Config.InitialApiGroupGroupresponseList.append(getTimeResponse)
                let indexPath = IndexPath(item: 1, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case ApiListConstants.GET_NODES:
            reloadStr = "\(indexPath.row)"
           // bIsreload = true
            let indexPath = IndexPath(item: 2, section:0)
            self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            UtilApiHandler.getNodes { (nodesResponse) in
                //reloadStr = ""
                if nodesResponse["success"] == "true" {
                   reloadStr = ""
                    apiResponseItems[2] = true
                } else {
                    reloadStr = ""
                    apiResponseItems[2] = false
                }
                Config.InitialApiGroupGroupresponseList.append(nodesResponse)
                Config.MultipleGroupData.append(Config.InitialApiGroupGroupresponseList)
                let indexPath = IndexPath(item: 2, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case ApiListConstants.GET_INSTITUTIONS:
            reloadStr = "\(indexPath.row)"
            let indexPath = IndexPath(item: 3, section:0)
            self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            UtilApiHandler.getInstitutions { (institutionsResponse) in
                //reloadStr = ""
                if institutionsResponse["success"] == "true" {
                  reloadStr = ""
                    apiResponseItems[3] = true
                } else {
                   reloadStr = ""
                    apiResponseItems[3] = false
                }
                
                Config.InitialApiGroupGroupresponseList.append(institutionsResponse)
                let indexPath = IndexPath(item: 3, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case ApiListConstants.GEN_KEY_PAIR:
           reloadStr = "\(indexPath.row)"
            apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            let keys = KeyUtils.generateKeys()
            clientKey = keys.publicKey
            Config.privateKey = keys.privateKey
            clientJwk = KeyUtils.convertSecKeyToJwk(key: clientKey!)
            var mapData = [String: String] ()
            mapData["Api"] = "KeyPair Generation"
            mapData["url"] = ""
            mapData["response"] = convertDictToJson(dictData: clientJwk)
            mapData["success"] = "true"
            //bIsreload = false
            Config.GenerateKeyGroupResponseList.append(mapData)
            apiResponseItems[4] = true
            let indexPath = IndexPath(item: 4, section:0)
           reloadStr = ""
            self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            break;
        case ApiListConstants.REG_DCR:
            print("client jwk")
            print(clientJwk)
            reloadStr = "\(indexPath.row)"
            if(clientKey != nil)
            {
               // bIsreload = true
                let indexPath = IndexPath(item: 5, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                DirectClientRegistrationHandler.doRegister(pubKey: clientKey!, clientJwk: clientJwk, userName: "fhir") { (dcrResponse) in
                    //reloadStr = ""
                    if dcrResponse["success"] == "true" {
                       reloadStr = ""
                    
                        apiResponseItems[5] = true
                    } else {
                        
                       reloadStr = ""
                        apiResponseItems[5] = false
                    }
                    Config.GenerateKeyGroupResponseList.append(dcrResponse)
                    let indexPath = IndexPath(item: 5, section:0)
                    self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }else{
                let alertController = UIAlertController(title: "Alert", message:
                    "Please click on Generate KeyPair to proceed", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
               reloadStr = ""
                self.present(alertController, animated: true, completion: nil)
            }
            break;
        case ApiListConstants.CRYPTO_SPOOK:
            if (clientJwk == nil || clientJwk.count == 0) {
            }else {
                reloadStr = "\(indexPath.row)"
               // bIsreload = true
                let indexPath = IndexPath(item: 6, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                let dialog = ZAlertView(title: "", message: "Enter message to sign", closeButtonText: "Ok") { alertView in
                    alertView.dismissAlertView()
                    let textfield = alertView.getTextFieldWithIdentifier("Message")
                    print("message")
                    print(textfield?.text)
                    let (jwsPayload, resultList) = KeyUtils.signMessage(message: (textfield?.text)!, privateKey: Config.privateKey!, publicKey: clientKey!)
                    for item in resultList {
                        Config.ThirdGroupResponseList.append(item)
                    }
                    let z = KeyUtils.convertKeyToDerBase64(key: clientKey!)
                    let jwkString = "{\"kty\":\"EC\", \"crv\":\"P-256\", \"x\":\"" + clientJwk["x"]! + "\", \"y\":\"" + clientJwk["y"]! + "\", \"z\":\"" + z + "\"}"
                    let tempString = "{\"keys\":[{\"key_type\":{\"requirement\":\"RECOMMENDED\",\"value\":\"EC\"},\"crv\":\"P-256\",\"kid\":\"ID1\",\"x\":\"" + clientJwk["x"]! + "\",\"required_params\":{\"kty\":\"EC\",\"crv\":\"P-256\",\"x\":\"" + clientJwk["x"]! + "\",\"y\":\"" + clientJwk["y"]! + "\"},\"y\":\"" + clientJwk["y"]! + "\",\"key_Type\":{\"requirement\":\"RECOMMENDED\",\"value\":\"EC\"}}],\"z\":\"" + z + "\"}";
                    //let jwkString = "{\"kty\":\"EC\", \"crv\":\"P-256\", \"x\":\"" + clientJwk["x"]! + "\", \"y\":\"" + clientJwk["y"]! + "\"}"
                    let jwkPayload = (tempString.data(using: String.Encoding.utf8))?.base64urlEncodedString()
                    print("jwo payload")
                    print(jwsPayload)
                    print("jwk payload")
                    print(jwkPayload)
                    SpookApiHandler.sendSignedMessageToFBC(body: ["jwo" : jwsPayload, "jwks": jwkPayload!]) { (fbcResponse) in
                        print("fbc response")
                        print(fbcResponse)
                        //reloadStr = ""
                        if fbcResponse["success"] == "true" {
                           reloadStr = ""
                            apiResponseItems[6] = true
                        } else {
                          reloadStr = ""
                            apiResponseItems[6] = false
                            print("fbc false")
                        }
                        
                        Config.ThirdGroupResponseList.append(fbcResponse)
                        let indexPath = IndexPath(item: 6, section:0)
                        self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                    
                }
                dialog.addTextField("Message", placeHolder: "Message")
                dialog.show()
            }
            break;
        case ApiListConstants.FBC_EULA:
            let EulaResourceObject = DemoDataUtils.getDemoEulaResource()
            var EulajsonData = ConsentUtils.json(from: EulaResourceObject)
            print(EulajsonData)
            reloadStr = "\(indexPath.row)"
           // bIsreload = true
            let indexPath = IndexPath(item: 7, section:0)
            self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            UtilApiHandler.InsertDemoEulaResource(parameter:EulaResourceObject)
            { (DemoEulaResource) in
                if DemoEulaResource["success"] == "true" {
                    UtilApiHandler.getEula{(EulaResponse) in
                        DispatchQueue.main.async {
                            if EulaResponse["success"] == "true" {
                                Config.EulaGroupResponseList.append(EulaResponse)
                                let response =  EulaResponse["response"]
                                UtilApiHandler.getEulaResponse(dic: response!, completion: { (json) in
                                   // bIsreload = false
                                    apiResponseItems[7] = true
                                   reloadStr = ""
                                    Config.EulaGroupResponseList.append(json)
                                    
                                })
                                
                            } else {
                                //reloadStr = ""
                               reloadStr = ""
                                apiResponseItems[7] = false
                                Config.EulaGroupResponseList.append(EulaResponse)
                            }
                            let indexPath = IndexPath(item: 7, section:0)
                           reloadStr = ""
                            self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                    
                }
            }
            break;
        case ApiListConstants.OAUTH_IDP:
           reloadStr = "\(indexPath.row)"
            if(Config.ToDictionaryArray.count > 0)
            {
               // bIsreload = true
                 let indexPath = IndexPath(item: 8, section:0)
                apiListTableView.reloadRows(at: [indexPath], with: .fade)
                apiResponseItems[8] = true
                let myVC = storyboard?.instantiateViewController(withIdentifier: "ExecuteAuthViewController") as! ExecuteAuthViewController
                navigationController?.pushViewController(myVC, animated: true)
                //reloadStr = ""
               reloadStr = ""
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            } else{
                let alertController = UIAlertController(title: "Alert", message:
                    "Please click on Get Institutions to proceed", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
           //reloadStr = ""
            break;
        case ApiListConstants.AUTHORIZE_TOKEN:
            reloadStr = "\(indexPath.row)"
            if(Config.privateKey != nil)
            {
                var Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
                if(Strcomonname != "Apollo")
                {
                    let FHIRBody = AssertionUtils.getFhirIdentifier()
                    let headerString = Config.JWTHeaderString
                    var jwt = KeyUtils.getJwt(header:headerString,message: FHIRBody)
                    print(jwt)
                    let parameters: [String: Any] = ["token" : jwt]
                    let jsonData =  ConsentUtils.json(from: parameters)
                    print(jsonData)
                 //   bIsreload = true
                    let indexPath = IndexPath(item: 9, section:0)
                    self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                    UtilApiHandler.GetFHIRIdentifier(parameter:parameters)
                    { (FHIRIdentifierResponse) in
                        Config.AssertionGroupResponseList.append(FHIRIdentifierResponse)
                        DispatchQueue.main.async {
                            if FHIRIdentifierResponse["success"] == "true" {
                                let BeginassertionBody = AssertionUtils.doBeginAssertion(patientId: Config.PatientId,organizationId: Config.OrganizationId)
                                UtilApiHandler.BeginAssertionApi(parameter:BeginassertionBody)
                                {
                                    (BeginassertionResponse) in
                                    Config.AssertionGroupResponseList.append(BeginassertionResponse)
                                    if BeginassertionResponse["success"] == "true" {
                                        let FinishAssertionBody = AssertionUtils.FinishAssertion(BeginAssertionResponse:BeginassertionResponse["response"]!)
                                        let headerString = Config.JWTHeaderString
                                        var jwt = KeyUtils.getJwt(header:headerString,message: FinishAssertionBody)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                        Date().millisecondsSince1970
                                        let parameters:[String: Any] = ["signedJWT" : jwt, "id" : Config.SessionId, "type" : "wanish","timeSent": "1543244917" ]
                                        let jsonData =  ConsentUtils.json(from: parameters)
                                        print(jsonData as Any)
                                        UtilApiHandler.FinishAssertionApi(parameter:parameters)
                                        {
                                            (FinishAssertionResponse) in
                                            Config.AssertionGroupResponseList.append(FinishAssertionResponse)
                                            if FinishAssertionResponse["success"] == "true" {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 9) { // change 2 to desired number of seconds
                                                    UtilApiHandler.Getthetoken{(TokenResponse) in
                                                        Config.AssertionGroupResponseList.append(TokenResponse)
                                                        if TokenResponse["success"] == "true" {
                                                          reloadStr = ""
                                                            apiResponseItems[9] = true
                                                            let indexPath = IndexPath(item: 9, section:0)
                                                            self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                                                            
                                                        }
                                                    }
                                                }
                                            }else
                                            {
                                               reloadStr = ""
                                            }
                                        }
                                    }else{
                                        reloadStr = ""
                                        let indexPath = IndexPath(item: 9, section:0)
                                        self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                                    }
                                }
                                
                            }
                        }
                    }
                }else{
                    reloadStr = ""
                  if let Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
                  {
                    let alertController = UIAlertController(title: "Alert", message:
                        "Authtoken can't be fetched from " + Strcomonname, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                }
            }else{
                reloadStr = ""
                let alertController = UIAlertController(title: "Alert", message:
                    "Please click on Register Client with DCR to proceed", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            //reloadStr = ""
            break;
        case ApiListConstants.GET_PATIENT_RESOURCE:
            var Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
            let name = Strcomonname?.replacingOccurrences(of: " ", with: "")
            var comapare = "DukeRsTest"
           reloadStr = "\(indexPath.row)"
            if name?.lowercased() == comapare.lowercased()
                // For a real IDP the handling needs to consider auth token.
            {
               // bIsreload = true
                let indexPath = IndexPath(item: 10, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                UtilApiHandler.getPatientResource(Authorization:Config.AuthToken){(PatientResourceResponse) in
                    DispatchQueue.main.async {
                        if PatientResourceResponse["success"] == "true" {
                            apiResponseItems[10] = true
                           reloadStr = ""
                        } else {
                            apiResponseItems[10] = false
                            reloadStr = ""
                        }
                        Config.PatientResourceGroupResponseList.append(PatientResourceResponse)
                        let indexPath = IndexPath(item: 10, section:0)
                        self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }else
            {
                // No token required. We're interacting with the HAPI FHIR server.
                let PatientResourceObject =   DemoDataUtils.getPatientResourceDeoObject()
                var jsonData =  ConsentUtils.json(from: PatientResourceObject)
                print(jsonData)
               // bIsreload = true
                let indexPath = IndexPath(item: 10, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                DispatchQueue.main.async {
                    
                    UtilApiHandler.InsertDemoPatientResource(parameter:PatientResourceObject)
                    { (DemoPatientResource) in
                        
                        if DemoPatientResource["success"] == "true" {
                            UtilApiHandler.getPatientResource(Authorization:Config.AuthToken){(PatientResourceResponse) in
                                
                                if PatientResourceResponse["success"] == "true" {
                                 reloadStr = ""
                                    apiResponseItems[10] = true
                                } else {
                                  reloadStr = ""
                                    apiResponseItems[10] = false
                                }
                                Config.PatientResourceGroupResponseList.append(PatientResourceResponse)
                                
                                let indexPath = IndexPath(item: 10, section:0)
                                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                    }
                }
                
                // Get patient resource
                
                
                
            }
            //reloadStr = ""
            break;
        case ApiListConstants.WRITE_FBC_CONSENT:
            reloadStr = "\(indexPath.row)"
            let PatientObject =   ConsentUtils.getPatientObject(patientId : Config.PatientId,patientName: "Vendortesttwo Fhir")
            let periodObject = ConsentUtils.getPeriodObject(startTime : "2018-11-22T18:36:36Z",endTime : "2018-12-27T18:36:36Z")
            var consents = [String]()
            consents.append("Organization")
            consents.append("Eula")
            consents.append("FBC")
            let ConsentBody = ConsentUtils.prepareConsentBody(consentType: "FBC", patientObject: PatientObject, periodObject: periodObject, dateTime: "2018-11-30T06:04:18.517Z", status: "active", reference: "Device/15555", display: "Don Stone1", code: "disclose", organizationDisplay: "Duke University Health", sourceReference: "Patient/22782", docReferenceId: "510799", sourceDisplay: "FBC", eulaUrl: Config.AmazonURLEula, eulaTitle: "FBC", thirdPartyConsents: consents, consentId: "510799")
            
            var jsonData =  ConsentUtils.json(from: ConsentBody)
            print(jsonData)
            print(Config.AuthToken)
         //   bIsreload = true
            let indexPath = IndexPath(item: 11, section:0)
            self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            ConsentApiHandler.RequestConsentBody(Authorization:Config.AuthToken,parameter: ConsentBody)
            { (ConsentBodyResponse) in
                DispatchQueue.main.async {
                    if ConsentBodyResponse["success"] == "true" {
                        let str = ConsentBodyResponse["url"]!
                        var urlPatient = ""
                        var filename = ""
                        var Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
                        var compare = "DukeRsTest"
                        let name = Strcomonname?.replacingOccurrences(of: " ", with: "")
                        if(name?.lowercased() == compare.lowercased())
                        {
                            let fileUrl = NSURL(fileURLWithPath: str)
                            filename = fileUrl.lastPathComponent!
                            Config.consentId = filename
                            print(filename)
                        }else
                        {
                            let newString = str.replacingOccurrences(of: "/_history/1", with: "")
                            let fileUrl = NSURL(fileURLWithPath: newString)
                            filename = fileUrl.lastPathComponent!
                            Config.consentId = filename
                        }
                        if name?.lowercased() == compare.lowercased()
                        {
                            urlPatient = "https://test.health-apis.duke.edu/FHIRBLOCKS/pilot/Consent/" + filename
                        }else{
                            urlPatient = Config.WebAPI.Util.ConsentPostURL + "/" + filename
                        }
         ConsentApiHandler.GetBodyResponse(Authorization:Config.AuthToken,url:urlPatient)
                        { (ConsentResponse) in
                            Config.ConsentGroupResponseList.append(ConsentResponse)
                            if ConsentResponse["success"] == "true" {
                                apiResponseItems[11] = true
                            reloadStr = ""
                                let indexPath = IndexPath(item: 11, section:0)
                                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                    } else {
                        reloadStr = ""
                        apiResponseItems[11] = false
                    }
                }
            }
            //reloadStr = ""
            break;
        case ApiListConstants.WRITE_FBC_PROVENANCE:
            if(Config.privateKey != nil)
            {
                let headerString = Config.JWTHeaderString
                let jwt = KeyUtils.getJwt(header:headerString,message: Config.ConsentResponse)
                print(jwt)
                let csiGuid = ProvenanccUtils.getClientCsiGuid()
                let PatientObject =   ProvenanccUtils.getProvenanceObject(consentId:Config.consentId, signatureString:jwt, fhirIdentifier: Config.PatientId, patientName:Config.PatientName, csiGuid: csiGuid)
                let jsonData =  ConsentUtils.json(from: PatientObject)
                print(jsonData as Any)
                 reloadStr = "\(indexPath.row)"
                let indexPath = IndexPath(item: 12, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            ProvenanceApiHandler.RequestProvenanceBody(Authorization:Config.AuthToken, parameter:PatientObject)
                { (ProvenanceBodyResponse) in
                    DispatchQueue.main.async {
                        if ProvenanceBodyResponse["success"] == "true" {
                            let str = ProvenanceBodyResponse["url"]!
                            var filename = ""
                            var provinenceurl = ""
                            let Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
                            var compare = "DukeRsTest"
                            let name = Strcomonname?.replacingOccurrences(of: " ", with: "")
                            if(name?.lowercased() == compare.lowercased()){
                                let fileUrl = NSURL(fileURLWithPath: str)
                                filename = fileUrl.lastPathComponent!
                                print(filename)
                            }else{
                                let newString = str.replacingOccurrences(of: "/_history/1", with: "")
                                let fileUrl = NSURL(fileURLWithPath: newString)
                                filename = fileUrl.lastPathComponent!
                            }
                            if name?.lowercased() == compare.lowercased()
                            {
                                provinenceurl = "https://test.health-apis.duke.edu/FHIRBLOCKS/pilot/Provenance/" + filename
                            }else{
                                provinenceurl = Config.WebAPI.Util.ProvenenceURL + "/" + filename
                            }
 ProvenanceApiHandler.GetProvinenceBodyResponse(Authorization:Config.AuthToken,url:provinenceurl)
                            { (ProvinenceResponse) in
                                Config.ProvenancGroupResponseList.append(ProvinenceResponse)
                                if ProvinenceResponse["success"] == "true" {
                                    apiResponseItems[12] = true
                                   reloadStr = ""
                                    let indexPath = IndexPath(item: 12, section:0)
                                    self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                                }
                            }
                            
                        } else {
                            reloadStr = ""
                            let indexPath = IndexPath(item: 12, section:0)
                            self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                            
                            apiResponseItems[12] = false
                        }
                        
                    }
                    
                }
                
            }else{
                let alertController = UIAlertController(title: "Alert", message:
                    "Please click on Register Client with DCR to proceed", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            //reloadStr = ""
            break;
        case ApiListConstants.WRITE_FBC_AUDIT:
            if(Config.privateKey != nil)
            {
                let headerString = Config.JWTHeaderString
                var jwt = KeyUtils.getJwt(header:headerString,message: Config.ProvenenceResponse)
                print(jwt)
                var csiGuid = ProvenanccUtils.getClientCsiGuid()
                let auditObject = AuditUtils.getAuditObject(csiGuid: csiGuid, signatureString: jwt)
                var jsonData =  ConsentUtils.json(from: auditObject)
                print(jsonData)
                reloadStr = "\(indexPath.row)"
                
                let indexPath = IndexPath(item: 13, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                UtilApiHandler.RequestAuditBody(parameter:auditObject)
                { (AuditBodyResponse) in
                    DispatchQueue.main.async {
                        if AuditBodyResponse["success"] == "true" {
                            apiResponseItems[13] = true
                            reloadStr = ""
                            
                        } else {
                            reloadStr = ""
                            apiResponseItems[13] = false
                        }
                        
                        Config.AuditGroupResponseList.append(AuditBodyResponse)
                        let indexPath = IndexPath(item: 13, section:0)
                        self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            //reloadStr = ""
            break;
        default:
            print("No action assigned")
        }
        //reloadStr = ""
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    /// Convert dictionary to JSON
    ///
    /// - Parameter dictData: Data as dictionary
    /// - Returns: JSON String
    func convertDictToJson(dictData: [String: Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictData, options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            return ""
        }
    }
}

extension APIListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return actionItems!.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "ActionButtonCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ActionButtonCollectionViewCell
        cell.actionButtonLabel.text = actionItems?[indexPath.row]
        //cell.actionButtonLabel.lineBreakMode = .byWordWrapping
        cell.actionButtonLabel.numberOfLines = 0
        cell.actionButtonLabel.layer.cornerRadius = 5.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.resetTapped()
        case 1:
            self.viewBadgeTapped()
           
        case 2:
            self.viewLogsTapped()
        case 3:
            self.resetLogsTapped()
        default:
            print("No action assigned")
        }
    }
}

// MARK: - APIListview controller extension
extension APIListViewController {
    
    /// Triggered when user taps on reset
    func resetTapped () {
        apiResponseItems = Config.ApiResposeItems
        apiListTableView.reloadData()
        self.view.makeToast("App has been reset")
        print("reset tapped")
    }
    
    
    /// Triggered when user taps on view logs
    func viewLogsTapped () {
        print("viewLogsTapped tapped")
        if(Config.MultipleGroupData.count > 0)
        {
            Config.MultipleGroupData.removeAll()
        }
        if(Config.InitialApiGroupGroupresponseList.count > 0)
        {
            Config.MultipleGroupData.append(Config.InitialApiGroupGroupresponseList  as! [[String : Any?]])
           
        }
        if(Config.GenerateKeyGroupResponseList.count > 0)
        {
            Config.MultipleGroupData.append((Config.GenerateKeyGroupResponseList as! [[String : Any?]]))
           
        }
        if( Config.ThirdGroupResponseList.count > 0)
        {
            Config.MultipleGroupData.append((Config.ThirdGroupResponseList as! [[String : Any?]]))
           
        }
        if(Config.EulaGroupResponseList.count > 0)
        {
            Config.MultipleGroupData.append(( Config.EulaGroupResponseList as! [[String : Any?]]))
           
        }
        if(Config.WebViewResponseList.count > 0)
        {
            Config.MultipleGroupData.append(Config.WebViewResponseList)
        }
        if(Config.AssertionGroupResponseList.count>0)
        {
            Config.MultipleGroupData.append(Config.AssertionGroupResponseList)
        }
        if(Config.DemoDataGroupResponseList.count>0)
        {
            Config.MultipleGroupData.append(Config.DemoDataGroupResponseList)
        }
        if(Config.PatientResourceGroupResponseList.count > 0)
        {
            Config.MultipleGroupData.append(Config.PatientResourceGroupResponseList)
        }
        if(Config.ConsentGroupResponseList.count > 0)
        {
            Config.MultipleGroupData.append(Config.ConsentGroupResponseList)
        }
        if(Config.ProvenancGroupResponseList.count>0)
        {
            Config.MultipleGroupData.append(Config.ProvenancGroupResponseList)
        }
        if(Config.AuditGroupResponseList.count > 0)
        {
            Config.MultipleGroupData.append(Config.AuditGroupResponseList)
        }
        print(Config.MultipleGroupData.count)
        if(Config.MultipleGroupData.count) > 0
        {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ShowLogListViewController") as! ShowLogListViewController
        myVC.PageType = "FirstPage"
        myVC.nextI = 0
        navigationController?.pushViewController(myVC, animated: true)
        }else{
            self.view.makeToast("No logs to view.")
        }
    }
    
    /// Trigger When user tapped View badge
    func viewBadgeTapped () {
        if(Config.PatientName.isEmpty && Config.FamilyName.isEmpty)
        {
            let alertController = UIAlertController(title: "Alert", message:
                "Insert Consent and Provenance to view Badge.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ViewBadgeController") as! ViewBadgeViewController
            navigationController?.pushViewController(myVC, animated: true)
        }
        
    }
    
    /// Insert demo data into the system
    func InsertDemoData() {
        let PatientResourceObject =   DemoDataUtils.getPatientResourceDeoObject()
        var jsonData =  ConsentUtils.json(from: PatientResourceObject)
        print(jsonData)
        UtilApiHandler.InsertDemoPatientResource(parameter:PatientResourceObject)
        { (DemoPatientResource) in
            DispatchQueue.main.async {
                if DemoPatientResource["success"] == "true" {
                    Config.DemoDataGroupResponseList.append(DemoPatientResource)
                    insertDemoData = true
                }
            }
        }
        
        let EulaResourceObject = DemoDataUtils.getDemoEulaResource()
        var EulajsonData = ConsentUtils.json(from: EulaResourceObject)
        print(EulajsonData)
        UtilApiHandler.InsertDemoEulaResource(parameter:EulaResourceObject)
        { (DemoEulaResource) in
            DispatchQueue.main.async {
                if DemoEulaResource["success"] == "true" {
                    Config.DemoDataGroupResponseList.append(DemoEulaResource)
                    
                }
            }
        }
    }
    /// Triggered when user taps on reset logs.
    func resetLogsTapped ()
    {
        Config.InitialApiGroupGroupresponseList.removeAll()
        Config.GenerateKeyGroupResponseList.removeAll()
        Config.ThirdGroupResponseList.removeAll()
        Config.EulaGroupResponseList.removeAll()
        Config.MultipleGroupData.removeAll()
        Config.WebViewResponseList.removeAll()
        Config.ToDictionaryArray.removeAll()
        Config.WebViewResponseList.removeAll()
        Config.PatientResourceGroupResponseList.removeAll()
        Config.ConsentGroupResponseList.removeAll()
        Config.AuditGroupResponseList.removeAll()
        Config.ProvenancGroupResponseList.removeAll()
        Config.DemoDataGroupResponseList.removeAll()
        Config.AssertionGroupResponseList.removeAll()
        Config.PatientId = ""
        Config.PatientName = ""
        Config.FamilyName = ""
        self.view.makeToast("Logs have been reset")
        print("resetLogsTapped tapped")
    }
}
//Extension for Date Class
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
