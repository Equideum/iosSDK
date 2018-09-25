//
//  LogItemCollectionViewCell.swift
//  DukeHealthiOSSDK
//
//  Created by Swathi on 14/09/18.
//  Copyright © 2018 Swathi. All rights reserved.
//

import UIKit

class LogItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var apiNameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var responseTextField: UITextField!
    @IBOutlet weak var endApiTextFiled: UITextField!
    
//    lazy var width: NSLayoutConstraint = {
//        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
//        width.isActive = true
//        return width
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        setupViews()
//    }
//    
//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        width.constant = bounds.size.width
//        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    fileprivate func setupViews(){
//        //contentView.addSubview(label)
//        responseTextField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        responseTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        responseTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
//        
//        //contentView.addSubview(customView)
//        contentView.topAnchor.constraint(equalTo: responseTextField.bottomAnchor, constant: 10).isActive = true
//        contentView.leftAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
//        contentView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        contentView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//       // contentView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: 10).isActive = true
//    }
}
