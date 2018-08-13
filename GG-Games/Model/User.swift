//
//  User.swift
//  GG-Games
//
//  Created by Morshed Alam on 8/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import  SwiftyJSON

struct User:Codable{
    
    var userName: String
    var internalIdentifier: Int
    var totalCoin: Int
    var totoalPlayed:Int
    var userId: String
    var accessToken: String
    var userPicture: String?
    var gplusId: String?
    var password: String?
    var fbId: String?
    var email: String?
    var userDefinedId: String?
    
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case userName = "user_name"
        case userPicture = "user_picture"
        case internalIdentifier = "id"
        case gplusId = "gplus_id"
        case fbId = "fb_id"
        case totalCoin = "total_coin"
        case userId = "user_id"
        case accessToken = "access_token"
        case userDefinedId = "user_defined_id"
        case email = "email"
        case password = "password"
        case totoalPlayed = "total_played"
        
    }
    
}

extension User {
    
    init?(json:JSON){
        guard let userName =  json[CodingKeys.userName.rawValue].string,
            let internalIdentifier = json[CodingKeys.internalIdentifier.rawValue].int,
            let totalCoin =  json[CodingKeys.totalCoin.rawValue].int,
            let userId =  json[CodingKeys.userId.rawValue].string,
            let accessToken =  json[CodingKeys.accessToken.rawValue].string,
            let totalPlayed =  json[CodingKeys.totoalPlayed.rawValue].int
            else {
                return nil
        }
        self.init(userName:userName, internalIdentifier: internalIdentifier, totalCoin: totalCoin,totoalPlayed:totalPlayed,userId:userId, accessToken: accessToken, userPicture: json[CodingKeys.userPicture.rawValue].string, gplusId: json[CodingKeys.gplusId.rawValue].string, password: json[CodingKeys.password.rawValue].string, fbId: json[CodingKeys.fbId.rawValue].string, email: json[CodingKeys.email.rawValue].string, userDefinedId: json[CodingKeys.userDefinedId.rawValue].string)
    }
}
