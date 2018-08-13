//
//  CateGory.swift
//  GG-Games
//
//  Created by Morshed Alam on 23/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit

struct Category {
    static let key = "gameItem"
    
    let title: String
    let image: UIImage
}

struct CategoryList {
    static let catergories = [
        
        Category(title: "All Games", image: #imageLiteral(resourceName: "all_game_icon")),
        Category(title: "Action", image: #imageLiteral(resourceName: "action_game_icon")),
        Category(title: "Arcade", image: #imageLiteral(resourceName: "arcade_game_icon")),
        Category(title: "Board", image: #imageLiteral(resourceName: "board_game_icon")),
        Category(title: "Cards", image: #imageLiteral(resourceName: "card_game_icon")),
        Category(title: "Casino", image: #imageLiteral(resourceName: "casino_game_icon")),
        Category(title: "Casual", image: #imageLiteral(resourceName: "casual_game_icon")),
        Category(title: "Racing", image: #imageLiteral(resourceName: "racing_game_icon")),
        Category(title: "Sports", image: #imageLiteral(resourceName: "sports_game_icon")),
        Category(title: "Word", image: #imageLiteral(resourceName: "words_game_icon"))

    ]
    
}
