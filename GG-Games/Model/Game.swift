//
//  Game.swift
//  GG-Games
//
//  Created by Morshed Alam on 18/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import  SwiftyJSON

struct Game:Codable{
    
    var id: Int
    var icon: String
    var category: String
    var favorite: Int
    var description: String?
    var scoreType: String?
    var banner: String?
    var name: String?
    var popularity: Int
    var slider: String?
    var featured: Int?
    var largeIcon: String?
    var gameuid: String?
    var featuredOrder: Int?
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case icon = "icon"
        case category = "category"
        case favorite = "favorite"
        case description = "description"
        case scoreType = "score_type"
        case banner = "banner"
        case name = "name"
        case popularity = "popularity"
        case slider = "slider"
        case featured = "featured"
        case largeIcon = "large_icon"
        case gameuid = "gameuid"
        case featuredOrder = "featured_order"
        
    }
    
}

extension Game {
    
    init?(json:JSON){
        guard let id =  json[CodingKeys.id.rawValue].int,
            let icon = json[CodingKeys.icon.rawValue].string,
            let category =  json[CodingKeys.category.rawValue].string,
            let favorite =  json[CodingKeys.favorite.rawValue].int,
            let popularity =  json[CodingKeys.popularity.rawValue].int
            else {
                return nil
        }
        self.init(id: id, icon: icon, category: category, favorite: favorite, description: json[CodingKeys.description.rawValue].string, scoreType: json[CodingKeys.scoreType.rawValue].string, banner: json[CodingKeys.banner.rawValue].string, name: json[CodingKeys.name.rawValue].string, popularity: popularity, slider: json[CodingKeys.slider.rawValue].string, featured: json[CodingKeys.featured.rawValue].int, largeIcon: json[CodingKeys.largeIcon.rawValue].string, gameuid: json[CodingKeys.gameuid.rawValue].string, featuredOrder: json[CodingKeys.featuredOrder.rawValue].int)
        
        
    }
}
extension Game: Equatable {
    
    static func ==(lhs:Game, rhs:Game) -> Bool { // Implement Equatable
        return lhs.gameuid == rhs.gameuid
    }
}
