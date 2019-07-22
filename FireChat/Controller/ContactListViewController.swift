//
//  ContactListViewController.swift
//  FireChat
//
//  Created by Khairul Bashar on 2019-07-20.
//  Copyright © 2019 Jahid Bashar. All rights reserved.
//

import UIKit

class ContactListViewController: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarNameLabel: UILabel!
    @IBOutlet weak var avatarEmailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
