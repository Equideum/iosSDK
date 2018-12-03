//
//  LogItemCollectionViewCell.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import UIKit

/// Log item view cell
class LogItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var apiNameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var responseTextField: UITextField!
    @IBOutlet weak var endApiTextFiled: UITextField!
}
