//
//  CateGoryTableViewCell.swift
//  GG-Games
//
//  Created by Morshed Alam on 24/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit


class CateGoryTableViewCell: UITableViewCell,NibReusable {

    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    
   
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
