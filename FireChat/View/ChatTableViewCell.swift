//
//  ChatTableViewCell.swift
//  FireChat
//
//  Created by Khairul Bashar on 2019-07-20.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
