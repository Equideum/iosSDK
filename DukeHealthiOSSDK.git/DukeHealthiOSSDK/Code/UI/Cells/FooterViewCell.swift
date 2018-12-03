//
//  FooterViewCellCollectionViewCell.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import UIKit

/// Footer view cell for Next, Back buttons
class FooterViewCell: UICollectionViewCell {
        
        @IBOutlet weak var NextBtn: UIButton!
        @IBAction func Action(_ sender: Any) {
            
            print("Clicked")
        }
    }

