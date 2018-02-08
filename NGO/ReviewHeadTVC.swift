//
//  ReviewHeadTVC.swift
//  
//
//  Created by lanet on 02/02/18.
//

import UIKit

class ReviewHeadTVC: UITableViewCell {

    @IBOutlet weak var lblTotalReview: UILabel!
    @IBOutlet weak var lblTotalRating: UILabel!
    
    @IBOutlet weak var s5: UIImageView!
    @IBOutlet weak var s4: UIImageView!
    @IBOutlet weak var s3: UIImageView!
    @IBOutlet weak var s2: UIImageView!
    @IBOutlet weak var s1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setStar(i : Float) {
        switch Int(i)
        {
            case 5:
                s5.image=UIImage(named: "star")
                s4.image=UIImage(named: "star")
                s3.image=UIImage(named: "star")
                s2.image=UIImage(named: "star")
                s1.image=UIImage(named: "star")
            case 4:
                s4.image=UIImage(named: "star")
                s3.image=UIImage(named: "star")
                s2.image=UIImage(named: "star")
                s1.image=UIImage(named: "star")
            case 3:
                s3.image=UIImage(named: "star")
                s2.image=UIImage(named: "star")
                s1.image=UIImage(named: "star")
            case 2:
                s2.image=UIImage(named: "star")
                s1.image=UIImage(named: "star")
            case 1:
                s1.image=UIImage(named: "star")
            default: break
        }
    }
}
