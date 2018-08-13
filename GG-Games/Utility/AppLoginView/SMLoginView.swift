//
//  SMLoginView.swift
//  GG-Games
//
//  Created by Rumana Rahman on 1/17/18.
//  Copyright © 2018 Morshed Alam. All rights reserved.
//

import UIKit

class SMLoginView: UIView, NibOwnerLoadable {

    @IBOutlet weak var fbBtn: UIButton!
    
    @IBOutlet weak var gmailBtn: UIButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
    
}
