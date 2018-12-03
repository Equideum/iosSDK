//
//  ExecuteAuthViewController.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//


import UIKit
import WebKit

class ExecuteAuthViewController: UIViewController,dropDownDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler
{  var Strcomonname: String? = nil
    var Strconformanceurl: String? = nil
    var receivedMessage : String?
    var AuthString: String?
    var AllowString: String?
    
    @IBOutlet weak var continueButton: UIButton!
    var DictionaryArrayAuth : [[String: Any]] = []
    @IBOutlet weak var BtnText: UIButton!
    @IBOutlet  var DropDownPickerView: UIPickerView!
    var InstitutionNameArr = [String]()
    var resourceServerUrl = [String]()
    var myActivityIndicator = UIActivityIndicatorView()
    var conformanceUrl = [String]()
    @IBOutlet weak var webUIView: UIView!
    var Textlbl: UILabel?
    var ExecuteAuthWebview: WKWebView?
    var responseMap : [String: String] = ["Api":"Execute Oauth2 with IDP Api", "response":"{}", "success":"false", "url":""]
    let userContentController = WKUserContentController()
    @IBOutlet  var HeaderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// Function to initialize UI components
    func LoadUI()
    {
        navigationController?.navigationBar.tintColor = Config.AppColor.navigationTintColor
        let button1 = UIBarButtonItem(title: "ViewLog", style: .done, target: self,  action: #selector(ShowLog))
        button1.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        self.navigationItem.rightBarButtonItem  = button1
        myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        continueButton.titleLabel?.font  =  UIFont.boldSystemFont(ofSize: 19)
        continueButton.isHidden = true
        self.navigationItem.title = "Create Your Identity"
        // activityIndicatorWebview.startAnimating()
        let contentController = WKUserContentController()
        contentController.add(self, name: "access")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        self.ExecuteAuthWebview = WKWebView(frame: self.webUIView.bounds, configuration: configuration)
        self.webUIView.addSubview(self.ExecuteAuthWebview!)
        
        ExecuteAuthWebview!.navigationDelegate = self
        
        for infoarray in Config.ToDictionaryArray
        {
            let dataDic = infoarray as? NSDictionary
            var name = dataDic!["commonName"]
            let url = dataDic!["conformanceUrl"]
            let resourceServer = dataDic!["resourceServerUrl"]
            if(name as! String  == "Apollo")
            {
                InstitutionNameArr.insert(name as! String, at: 0)
                resourceServerUrl.insert(resourceServer as! String, at:0)
            }else{
                
                InstitutionNameArr.append(name as! String)
                resourceServerUrl.append(resourceServer as! String)
            }
            
            conformanceUrl.append(url as! String)
            print(name)
        }
        
        BtnText.setTitle(InstitutionNameArr[0], for: .normal)
        UserDefaults.standard.set(InstitutionNameArr[0] as! String, forKey:"commonName")
        UserDefaults.standard.set(resourceServerUrl[0] as! String, forKey:"resourceServerUrl")
        UserDefaults.standard.set(Config.executeAuthStaticURL, forKey:"conformanceUrl")
        let url = URL (string: Config.executeAuthStaticURL)
        let requestObj = URLRequest(url: url!)
        ExecuteAuthWebview!.load(requestObj)
        HeaderView.backgroundColor = UIColor.white
        HeaderView.layer.shadowOpacity = 0.5
    }
    
    /// <#Description#>
    ///Updates the value of drop down list
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - url: <#url description#>
    func LoadDelegate(name:String,url:String)
    {
        Textlbl?.isHidden = true
        ExecuteAuthWebview?.isHidden = false
        Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
        Strconformanceurl = UserDefaults.standard.string(forKey: "conformanceUrl")
        BtnText.setTitle(Strcomonname, for: .normal)
        if(Strcomonname == "Apollo")
        {
            let url = URL (string: Config.executeAuthStaticURL)
            let requestObj = URLRequest(url: url!)
            ExecuteAuthWebview!.load(requestObj)
        } else{
            let url = URL (string: Strconformanceurl!)
            let requestObj = URLRequest(url: url!)
            ExecuteAuthWebview!.load(requestObj)
            
        }
        
        print(name)
        print(url)
        self.prepareLoginUrl(url: url, name: name)
    }
    
    /// <#Description#>
    ///Conformance Body Response
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - name: <#name description#>
    func prepareLoginUrl(url: String, name: String) {
        ConformanceApiHandler.getConformanceStatement(url: url) { (dcrResponse) in
            print("conformance response")
            print(dcrResponse["data"])
            if dcrResponse["success"] as! String == "true" {
                let authEndPoint = ConformanceApiHandler.getAuthEndPoint(response: dcrResponse["data"] as! [String: Any]);
                print(authEndPoint)
                var loginUrl = url.replacingOccurrences(of : "/.metadata",with: "").replacingOccurrences(of : "/metadata", with: "");
                print(loginUrl)
                if (authEndPoint.contains("https")) {
                    loginUrl = authEndPoint
                } else {
                    loginUrl += authEndPoint;
                }
                print(loginUrl);
                let csiGuid = self.getOrganizationId(organizationName: name)
                let clientId = "f92f6c68-1882-4c79-a5a2-54f99ff90d4f"
                // let client_Id = Config.Client_Id
                let clientCsiGuid = self.getClientCsiGuid();
                var messageDict: [String: String]  = [:]
                messageDict["organizationCsiGuid"] = csiGuid
                messageDict["clientCsiGuid"] = clientCsiGuid
                let headerString = "{\"typ\":\"JWT\",\"alg\":\"ES256\"}"
                let jwt = KeyUtils.getJwt(header:headerString,message: messageDict)
                print("jwt")
                print(jwt)
                
                loginUrl += "?state=" + jwt + "&client_id=" + clientId
                    + "&response_type=" + "code" + "&redirect_uri=https%3A%2F%2Fpoc-node-1.fhirblocks.io%2Fsmoac%2Fbind"
                print(loginUrl)
                let finalUrl = URL (string: loginUrl)
                let requestObj = URLRequest(url: finalUrl!)
                self.ExecuteAuthWebview!.load(requestObj)
                apiResponseItems[5] = true
            } else {
                apiResponseItems[5] = false
            }
        }
    }
    
    /// <#Description#>
    ///Funtion to get the ClientCsiGuid
    /// - Returns: <#return value description#>
    func getClientCsiGuid() -> String {
        var id = ""
        if let dataDic = Config.dcrResponse as? NSDictionary
        {
            id = dataDic["client_id"] as! String
        }
        return id
    }
    
    /// <#Description#>
    ///Get Organization Id from Organization Response
    /// - Parameter organizationName:
    /// - Returns: Returns organizationName
    func getOrganizationId(organizationName:String) -> String {
        print("organization name");
        print(organizationName)
        print(Config.organizations)
        for infoarray in Config.organizations {
            let dataDic = infoarray as? NSDictionary
            print("organizations");
            print(dataDic)
            let name = dataDic!["commonName"] as! String;
            if (name == organizationName) {
                return dataDic!["organizationId"] as! String;
            }
        }
        return "";
    }
    
    /// <#Description#>
    ///Trigger when user clicks on continue button
    /// - Parameter sender: <#sender description#>
    @IBAction func ContinueClickAction(_ sender: Any) {
        
        ExecuteAuthWebview?.isHidden = true
        Textlbl = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 400))
        Textlbl!.textAlignment = .center //For center alignment
        Textlbl!.textColor = .black
        Textlbl!.lineBreakMode = .byWordWrapping
        Textlbl!.numberOfLines = 0
        self.webUIView.addSubview(Textlbl!)
        continueButton.isHidden = true
        Textlbl!.text = responseMap["response"]
    }
     // MARK: Webview Actions
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // show indicator
        myActivityIndicator.isHidden = false
        myActivityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        myActivityIndicator.isHidden = true
        myActivityIndicator.stopAnimating()
        //        var navigationres = navigationAction.request.url?.host
        print("------------------------------------------------------------------")
        print("The navigation is: " + (navigationAction.request.url?.absoluteString ?? "NO URL"))
        print("------------------------------------------------------------------")
        
        var navigationURL = navigationAction.request.url?.absoluteString
        if navigationURL!.contains(Config.RedirectURI) {
            decisionHandler(.allow)
            let newURL = URL(string: navigationURL!)!
            var token =  newURL.valueOf("code")
            continueButton.isHidden = false
            continueButton.backgroundColor = Config.AppColor.navigationBarColor
            Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
            Strconformanceurl =  UserDefaults.standard.string(forKey: "conformanceUrl")
            responseMap["url"] = "\nUrl:\n" + Strconformanceurl!
            responseMap["response"] = "\nResponse from " + ( Strcomonname! + ": "
                + " " + "Code Fetched from redirect URI " + "\n")
            responseMap["success"] = "false"
            Config.WebViewResponseList.append(responseMap)
            
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        myActivityIndicator.isHidden = true
        myActivityIndicator.stopAnimating()
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    }
    
    
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else { return completionHandler(.useCredential, nil) }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
        Strconformanceurl =  UserDefaults.standard.string(forKey: "conformanceUrl")
        continueButton.isHidden = false
        continueButton.backgroundColor = Config.AppColor.navigationBarColor
        print("Message received: \(message.name) with body: \(message.body)")
        do {
            var  receivedMessage = message.body as! NSDictionary
            let dict = message.body as? NSDictionary
            AuthString = dict!["auth"] as? String ?? ""
            AllowString = dict!["allow"] as? String ?? ""
            let data1 =  try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let convertedString = String(data: data1, encoding: String.Encoding.utf8)
            responseMap["url"] = "\nUrl:\n" + Strconformanceurl!
            responseMap["response"] = "\nResponse from " + ( Strcomonname! + ": "
                + " " + convertedString! ?? "\n")
            responseMap["success"] = "true"
            Config.WebViewResponseList.append(responseMap)
            
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
    
    /// Functions to show logs
    @objc func ShowLog()
    {
        
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
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ShowLogListViewController") as! ShowLogListViewController
        myVC.PageType = "FirstPage"
        myVC.nextI = 0
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    

    /// <#Description#>
    ///Trigger when dropdown list tapped
    /// - Parameter sender: <#sender description#>
    @IBAction func DropDownSelectAction(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "DropDownListViewControllerr") as! DropDownListViewController
        myVC.delegate = self
        myVC.selectedText = BtnText.titleLabel?.text
        navigationController?.pushViewController(myVC, animated: true)
    }
    
   
}

// MARK: - URL Extensions
extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}


