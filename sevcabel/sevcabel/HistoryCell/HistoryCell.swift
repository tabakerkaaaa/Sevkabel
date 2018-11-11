//
//  HistoryCell.swift
//  sevcabel
//
//  Created by Никита Бабенко on 11/11/2018.
//  Copyright © 2018 Nikita Babenko. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewButton: UIButton!
    @IBAction func reviewButton(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewButton.backgroundColor = .clear
        reviewButton.layer.cornerRadius = 5
        reviewButton.layer.borderWidth = 1
        reviewButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
