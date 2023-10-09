//
//  PlayerInfoCell.swift
//  JayneshProject
//
//  Created by Jaynesh Patel on 08/10/23.
//

import UIKit

class PlayerInfoCell: UITableViewCell {

    @IBOutlet weak var playerType: UILabel!
    @IBOutlet weak var playerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func configure(with player: Player) {
        playerName.text = "Name: \(player.nameFull)"
        playerType.text = "Batting: \(player.batting.style), Bowling: \(player.bowling.style)"
    }
}
