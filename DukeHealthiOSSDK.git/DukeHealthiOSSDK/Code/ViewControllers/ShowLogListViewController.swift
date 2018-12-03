//
//  ShowLogListViewController.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import UIKit

class ShowLogListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var i : Int = Int()
    var nextI : Int = Int()
    @IBOutlet weak var NextBtn: UIButton!
    @IBOutlet weak var FooterView: UIView!
    var PageType : String?
    var FilteredData = [[String: Any?]]()
    var FilteredGroupData = [[String: Any?]]()
    @IBOutlet weak var PreviousBtn: UIButton!
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        return layout
    }()
    @IBOutlet weak var ListColllectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       NextBtn.titleLabel?.font  =  UIFont.boldSystemFont(ofSize: 19)
         PreviousBtn.titleLabel?.font  =  UIFont.boldSystemFont(ofSize: 19)
        navigationController?.navigationBar.barTintColor = Config.AppColor.navigationBarColor
      self.navigationItem.title = "Api Log"
        ListColllectionView!.register(LogCell.self, forCellWithReuseIdentifier: "LogCell")
        ListColllectionView?.collectionViewLayout = layout
        if(Config.MultipleGroupData.count > nextI + 1)
        {

        }else{

            NextBtn.isHidden = true
        }
        PreviousBtn.isHidden = true
        if PageType == "FirstPage" {
            print("firstpage")
            print(FilteredData.count)
            
        if(Config.MultipleGroupData.count > 0)
            {
             for i in 0..<Config.MultipleGroupData.count
             {
               if(Config.MultipleGroupData[i].count > 0)
                  {
                    FilteredData = Config.MultipleGroupData[i] as! [[String : Any?]]
                      return
                  }
               }
            }
        else{
            FooterView.isHidden = true
            FooterView.removeFromSuperview()
            }
        }
        
        // Do any additional setup after loading the view.
    }

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (FilteredData.count)
    }
    
    /// <#Description#>
    ///Trigger when user tapped on Next Button
    /// - Parameter sender: <#sender description#>
    @IBAction func NextBtnAction(_ sender: Any) {
        if(nextI != 0)
        {
            PreviousBtn.isHidden = false
        }
        if(Config.MultipleGroupData.count > nextI + 1)
        {
        FilteredData = Config.MultipleGroupData[nextI+1] as! [[String : Any?]]
        if((FilteredData.count)>0)
        {
            nextI = nextI + 1
            ListColllectionView.reloadData()
            PreviousBtn.isHidden = false
        }
        }
        if(Config.MultipleGroupData.count > nextI + 1)
        {
            PreviousBtn.isHidden = false
        }else{
            NextBtn.isHidden = true
        }
    }
    
    /// <#Description#>
    ///Trigger when user clicks on Previous button
    /// - Parameter sender: <#sender description#>
    @IBAction func Previous_Btn_Click(_ sender: Any) {
        
        
       if(Config.MultipleGroupData.count > nextI)
       {
        NextBtn.isHidden == false
       }else{
         PreviousBtn.isHidden == false
        }
        if(nextI > 0)
        {
        if(Config.MultipleGroupData.count > nextI)
        {
          FilteredData = Config.MultipleGroupData[nextI - 1] as! [[String : Any?]]
          if((FilteredData.count)>0)
            {
          nextI = nextI - 1
          ListColllectionView.reloadData()
            NextBtn.isHidden = false
            }
        }
            if(nextI == 0)
            {
                PreviousBtn.isHidden = true
                NextBtn.isHidden = false
            }
        }
    }
    // Mark: CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogCell", for: indexPath) as! LogCell
        
        
        cell.apiNameLbl.text  = "\n *** " + (FilteredData[indexPath.row]["Api"] as! String) + " Call" + " *** "
        cell.urlTextLbl.attributedText = NSAttributedString(string: (FilteredData[indexPath.row]["url"] as? String)!, attributes:[NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        cell.responseLbl.text = FilteredData[indexPath.row]["response"] as? String
        cell.endApiLbl.text = " *** End of " + (FilteredData[indexPath.row]["Api"] as! String) + " Call" + " ***\n"
        return cell
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 10)
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 10)
        layout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    @objc func backTapped() {
        if self.navigationController != nil {
            navigationController?.popViewController(animated: true)
        }
        if self.tabBarController != nil {
            self.dismiss(animated: true, completion: nil)
        }
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
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
