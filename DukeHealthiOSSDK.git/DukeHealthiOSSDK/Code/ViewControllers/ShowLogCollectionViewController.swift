//
//  ShowLogCollectionViewController.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import UIKit

private let reuseIdentifier = "Cell"

class ShowLogCollectionViewController: UICollectionViewController {

    @IBOutlet var logsCollectionView: UICollectionView!
    var data :[[String: Any?]]?
    var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 10)
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        return layout
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.register(LogCell.self, forCellWithReuseIdentifier: "LogCell")
        collectionView?.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (data?.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> LogCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogCell", for: indexPath) as! LogCell

        
        cell.apiNameLbl.text  = "\n *** start of " + (data?[indexPath.row]["api"] as! String) + " *** "
        cell.urlTextLbl.text = (data?[indexPath.row]["url"] as? String)!
        cell.responseLbl.text = data?[indexPath.row]["response"] as? String
        cell.endApiLbl.text = " *** End of " + (data?[indexPath.row]["api"] as! String) + " ***\n"
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
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


class LogCell: UICollectionViewCell {
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.clear
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    fileprivate func setupViews() {
        contentView.addSubview(apiNameLbl)
        apiNameLbl.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        apiNameLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        
        contentView.addSubview(urlTextLbl)
        urlTextLbl.topAnchor.constraint(equalTo: apiNameLbl.bottomAnchor, constant: 5).isActive = true
        urlTextLbl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        urlTextLbl.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
       
        
        contentView.addSubview(responseLbl)
        responseLbl.topAnchor.constraint(equalTo: urlTextLbl.bottomAnchor, constant: 5).isActive = true
        responseLbl.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        responseLbl.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 15).isActive = true
        responseLbl.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        
        contentView.addSubview(endApiLbl)
        endApiLbl.topAnchor.constraint(equalTo: responseLbl.bottomAnchor, constant: 5).isActive = true

        endApiLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        contentView.addSubview(customView)
        customView.topAnchor.constraint(equalTo: endApiLbl.bottomAnchor, constant: 5).isActive = true
        customView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        customView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: 0).isActive = true
        
    }
    
    var apiNameLbl: UILabel = {
        let apiNameLbl = UILabel()
        apiNameLbl.backgroundColor = .clear
        apiNameLbl.numberOfLines = 0
        apiNameLbl.translatesAutoresizingMaskIntoConstraints = false
        return apiNameLbl
    }()
    
    
    var urlTextLbl: UILabel = {
        let urlTextLbl = UILabel()
        urlTextLbl.backgroundColor = .clear
        urlTextLbl.numberOfLines = 0
        urlTextLbl.translatesAutoresizingMaskIntoConstraints = false
        return urlTextLbl
    }()
    
    var responseLbl: UILabel = {
        let responseLbl = UILabel()
        responseLbl.backgroundColor = .clear
        responseLbl.numberOfLines = 0
        responseLbl.translatesAutoresizingMaskIntoConstraints = false
        return responseLbl
    }()
    
    
    var endApiLbl: UILabel = {
        let endApiLbl = UILabel()
        endApiLbl.backgroundColor = .clear
        endApiLbl.numberOfLines = 0
        endApiLbl.translatesAutoresizingMaskIntoConstraints = false

        return endApiLbl
    }()
    
    let customView: UIView = {
        let customView = UIView()
        customView.backgroundColor = .gray
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
}
