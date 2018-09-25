//
//  APIListViewController.swift
//  DukeHealthiOSSDK
//
//  Created by Swathi on 12/09/18.
//  Copyright © 2018 Swathi. All rights reserved.
//

import UIKit
import ZAlertView


var responseList = [Any?]()
var clientKey: SecKey? = nil;
var privateKey: SecKey? = nil;
var clientJwk: [String: String] = [:]
var apiResponseItems = [Bool]()
var dynamicClientRegistration : [String: AnyObject] = [:]
var temp = [String: Any] ()
var bodyDict = [String: Any] ()
class APIListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var apiListTableView: UITableView!
    @IBOutlet weak var actionButtonsCollectionView: UICollectionView!
    
    var apiList:[String]?
    var actionItems:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false

        // Do any additional setup after loading the view.
        apiList = ["Ping","get Time", "Get Nodes" , "get Institutions", "Generate KeyPair", "Register Client with DCR" ,"Verify crypto with spook", "Execute Oauth2 with IDP", "Consent to use Badge"]
        apiResponseItems = [false, false, false, false, false, false, false, false, false]
        actionItems = ["Reset", "View Badge", "View Logs", "Reset Logs"]
        
        responseList = [Any]()
        
        
        // ZAlertView setup
         alertViewCofig()
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (apiList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "APIListCell") as! ApiItemTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        if apiResponseItems[indexPath.row] {
            cell.apiResponseImage.image = #imageLiteral(resourceName: "radioOn")
        } else {
            cell.apiResponseImage.image = #imageLiteral(resourceName: "radioOff")
        }
        cell.apiNameLabel.text = apiList?[indexPath.row]
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 0:
            HouseKeepingCallsHandler.doPing { (pingResponse) in
                if pingResponse["success"] == "true" {
                    apiResponseItems[0] = true
                } else {
                    apiResponseItems[0] = false
                }
                responseList.append(pingResponse)
                let indexPath = IndexPath(item: 0, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break
        case 1:
            HouseKeepingCallsHandler.getTime { (getTimeResponse) in
                if getTimeResponse["success"] == "true" {
                    apiResponseItems[1] = true
                } else {
                    apiResponseItems[1] = false
                }
                responseList.append(getTimeResponse)
                let indexPath = IndexPath(item: 1, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case 2:
            HouseKeepingCallsHandler.getNodes { (nodesResponse) in
                if nodesResponse["success"] == "true" {
                    apiResponseItems[2] = true
                } else {
                    apiResponseItems[2] = false
                }
                responseList.append(nodesResponse)
                let indexPath = IndexPath(item: 2, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case 3:
            HouseKeepingCallsHandler.getInstitutions { (institutionsResponse) in
                if institutionsResponse["success"] == "true" {
                    apiResponseItems[3] = true
                } else {
                    apiResponseItems[3] = false
                }
                responseList.append(institutionsResponse)
                let indexPath = IndexPath(item: 3, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case 4:
            let keys = KeyUtils.generateKeys()
            clientKey = keys.publicKey
            privateKey = keys.privateKey
            clientJwk = KeyUtils.convertSecKeyToJwk(key: clientKey!)
            var mapData = [String: String] ()
            mapData["api"] = "KeyPair Generation"
            mapData["url"] = ""
            mapData["response"] = convertDictToJson(dictData: clientJwk)
            mapData["success"] = "true"
            responseList.append(mapData)
            apiResponseItems[4] = true
            let indexPath = IndexPath(item: 4, section:0)
            self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            break;
        case 5:
            DirectClientRegistrationHandler.doRegister(clientJwk: clientJwk, userName: "ios sdk") { (dcrResponse) in
                if dcrResponse["success"] == "true" {
                    apiResponseItems[5] = true
                } else {
                    apiResponseItems[5] = false
                }
                responseList.append(dcrResponse)
                let indexPath = IndexPath(item: 5, section:0)
                self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case 6:
           // KeyUtils.getSpookBody(privateKey: privateKey!, clientJwk: clientJwk, base64EncodingOptions: [])
            if (clientJwk == nil || clientJwk.count == 0) {
                
            } else {
                let dialog = ZAlertView(title: "", message: "Enter message to sign", closeButtonText: "Ok") { alertView in
                    alertView.dismissAlertView()
                    let textfield = alertView.getTextFieldWithIdentifier("Message")
                    
                    let (jwsPayload, resultList) = KeyUtils.signMessage(message: (textfield?.text)!, privateKey: privateKey!, publicKey: clientKey!)
                    for item in resultList {
                        responseList.append(item)
                    }
                    let jwkString = "{\"kty\":\"EC\", \"crv\":\"P-256\", \"x\":\"" + clientJwk["x"]! + "\", \"y\":\""+clientJwk["y"]! + "\"}"
                    let jwkPayload = (jwkString.data(using: String.Encoding.utf8))?.base64EncodedString() as! String
                    //let jwkPayload = KeyUtils.dictToBase64String(dictData: clientJwk) as! String
                    print(jwsPayload)
                    print(jwkPayload)
                    SpookApiHandler.sendSignedMessageToFBC(body: ["jwo" : jwsPayload, "jwk": jwkPayload]) { (fbcResponse) in
                        print("dcr response")
                        print(fbcResponse)
                        if fbcResponse["success"] == "true" {
                            apiResponseItems[6] = true
                        } else {
                            apiResponseItems[6] = false
                             print("dcr false")
                        }
                       
                        responseList.append(fbcResponse)
                        let indexPath = IndexPath(item: 6, section:0)
                        self.apiListTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                    
                }
                dialog.addTextField("Message", placeHolder: "Message")
                dialog.show()
            }
            break;
        default:
            print("No action assigned")
        }
      tableView.reloadRows(at: [indexPath], with: .none)
    }
    
   /**
     * converts dictionary to jsonString
     **/
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

extension APIListViewController {
    
    func resetTapped () {
        print("reset tapped")
    }
    
    func viewLogsTapped () {
        print("viewLogsTapped tapped")
        let myVC = storyboard?.instantiateViewController(withIdentifier: "showLogStoryboard") as! ShowLogCollectionViewController
        myVC.data = (responseList as! [[String : Any?]])
        navigationController?.pushViewController(myVC, animated: true)
        
        //self.performSegue(withIdentifier: "showLogSeque", sender: self)
    }
    
    func viewBadgeTapped () {
        print("viewBadgeTapped tapped")
    }
    
    func resetLogsTapped () {
        print("resetLogsTapped tapped")
    }
}
