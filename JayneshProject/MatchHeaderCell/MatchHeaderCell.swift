//
//  MatchHeaderCell.swift
//  JayneshProject
//
//  Created by Jaynesh Patel on 07/10/23.
//

import UIKit

class MatchHeaderCell: UITableViewCell {

    @IBOutlet weak var seriesLbl: UILabel!
    @IBOutlet weak var teamALbl: UILabel!
    @IBOutlet weak var teamBLbl: UILabel!
    @IBOutlet weak var dateAndTimeLbl: UILabel!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var moreDetailsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
