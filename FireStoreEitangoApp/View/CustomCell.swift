//
//  CustomCell.swift
//  FireStoreEitangoApp
//
//  Created by 下川勇輝 on 2020/11/03.
//  Copyright © 2020 Yuki Shimokawa. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var learnedNumberLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
