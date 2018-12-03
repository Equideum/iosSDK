//  DropDownListViewController
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//


import UIKit
protocol dropDownDelegate {
    func LoadDelegate(name:String,url:String)
}

/// Drop down list view controller
class DropDownListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var dropDownTableView: UITableView!
    var delegate:dropDownDelegate! = nil
    var selectedText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.title = "Select"
        dropDownTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 55
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Config.ToDictionaryArray.count
    }
    
    /// <#Description#>
    ///Assign the Custom cell and value binding
    /// - Parameters:
    ///   - tableView: <#tableView description#>
    ///   - indexPath: <#indexPath description#>
    /// - Returns: <#return value description#>
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownListCell") as! DropDownListCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.selectionStyle = .none
        let dict = Config.ToDictionaryArray[indexPath.row]
        let name = dict["commonName"]
        if selectedText == name as! String {
            cell.Clickimge.isHidden = false
            cell.Clickimge.image = UIImage(named: "correct" )
            let navigationBarColor = UIColor.colorWithHex(string: "#37B3FC")
            cell.InstitutionNameLbl.textColor = navigationBarColor
        }else{
            cell.Clickimge.isHidden = true
        }
        cell.InstitutionNameLbl.text = name as! String
        
        
        return cell
    }
    
    
    /// <#Description#>
    ///Trigger when select drop down list
    /// - Parameters:
    ///   - tableView: returns tablwview instance to access tableview
    ///   - indexPath: returns selected indexpath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = Config.ToDictionaryArray[indexPath.row]
        let comonname = dict["commonName"]
        let conformanceurl = dict["conformanceUrl"]
        let resourceServerURL = dict["resourceServerUrl"]
        UserDefaults.standard.set(comonname as! String, forKey:"commonName")
        UserDefaults.standard.set(conformanceurl as! String, forKey:"conformanceUrl")
        UserDefaults.standard.set(conformanceurl as! String,forKey:"resourceServerUrl")
        delegate.LoadDelegate(name: comonname as! String,url: conformanceurl as! String)
        navigationController?.popViewController(animated: true)
    }
}
