//
//  RestoTVC.swift
//  NGO
//
//  Created by lanet on 17/01/18.
//  Copyright © 2018 Vishnu. All rights reserved.
//

import UIKit

class RestoTVC: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgName: UIImageView!
    @IBOutlet weak var lblHint: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
