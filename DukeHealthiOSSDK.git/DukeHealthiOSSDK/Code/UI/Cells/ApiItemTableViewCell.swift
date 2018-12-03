//
//  ApiItemTableViewCell.swift
//  DukeHealthiOSSDK
//
//  Confidential & Proprietary Information of BBM Health, LLC - Not for disclosure without written permission.
//  Copyright 2018 BBM Health, LLC - All rights reserved.
//  FHIR is registered trademark of HL7 Intl
//

import UIKit

/// API List cell
class ApiItemTableViewCell: UITableViewCell {

    @IBOutlet weak var ApiListIndicator: UIActivityIndicatorView!
    @IBOutlet weak var apiNameLabel: UILabel!
    @IBOutlet weak var apiResponseImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
