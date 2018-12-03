//
//  DropDownListViewController FHIR is registered trademark of HL7 IntlViewController.swift
//  DukeHealthiOSSDK
//
//  Created by Xenovex on 11/9/18.
//

import UIKit

class DropDownListViewControllerr: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var dropDownTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return Config.InstitutionArrayName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "APIListCell") as! ApiItemTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
            cell.apiResponseImage.image = #imageLiteral(resourceName: "radioOn")
       
        cell.apiNameLabel.text = Config.InstitutionArrayName[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
        case 0:
            
                let indexPath = IndexPath(item: 0, section:0)
                self.dropDownTableView.reloadRows(at: [indexPath], with: .automatic)
            
        break;
        case 1:
        
                self.dropDownTableView.reloadRows(at: [indexPath], with: .automatic)
            
            break;
        case 2:
            
                let indexPath = IndexPath(item: 2, section:0)
                self.dropDownTableView.reloadRows(at: [indexPath], with: .automatic)
            
            break;
        case 3:
            
                let indexPath = IndexPath(item: 3, section:0)
                self.dropDownTableView.reloadRows(at: [indexPath], with: .automatic)
             break;
        default:
            print("No action assigned")
        }
       
       dropDownTableView.reloadRows(at: [indexPath], with: .none)
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
