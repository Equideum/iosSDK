//
//  LaunchViewController.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        Config.InitialApiGroupGroupresponseList.removeAll()
        Config.GenerateKeyGroupResponseList.removeAll()
        Config.ThirdGroupResponseList.removeAll()
        Config.EulaGroupResponseList.removeAll()
        Config.MultipleGroupData.removeAll()
        Config.ToDictionaryArray.removeAll()
        Config.WebViewResponseList.removeAll()
        Config.ConsentGroupResponseList.removeAll()
        Config.PatientResourceGroupResponseList.removeAll()
        Config.AuditGroupResponseList.removeAll()
        Config.ProvenancGroupResponseList.removeAll()
        Config.DemoDataGroupResponseList.removeAll()
        Config.PatientId = ""
        Config.PatientName = ""
        Config.FamilyName = ""
        Config.AssertionGroupResponseList.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "showAPIListScreen", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
