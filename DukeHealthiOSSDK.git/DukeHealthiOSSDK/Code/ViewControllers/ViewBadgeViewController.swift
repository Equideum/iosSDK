//
//  ViewBadgeViewController.swift
//  DukeHealthiOSSDK
//
//  Created by Xenovex on 12/3/18.
//

import UIKit

class ViewBadgeViewController: UIViewController {

    @IBOutlet weak var BadgeNameText: UILabel!
    @IBOutlet weak var BadgeTitleText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
     if let Strcomonname =  UserDefaults.standard.string(forKey: "commonName")
     {
        BadgeTitleText.text = Strcomonname + " " + "Badge"
     }
         self.navigationItem.title = "Badge"
        
   BadgeNameText.text = Config.PatientName + " " + Config.FamilyName
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
