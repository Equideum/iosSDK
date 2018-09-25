//
//  ApiItemTableViewCell.swift
//  DukeHealthiOSSDK
//
//  Created by Swathi on 12/09/18.
//  Copyright © 2018 Swathi. All rights reserved.
//

import UIKit

class ApiItemTableViewCell: UITableViewCell {

    @IBOutlet weak var apiNameLabel: UILabel!
    @IBOutlet weak var apiResponseImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
