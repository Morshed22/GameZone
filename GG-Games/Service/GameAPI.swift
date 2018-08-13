//
//  GameAPI.swift
//  GG-Games
//
//  Created by Morshed Alam on 8/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import Moya

 

enum GameAPI{
    
    case login(params:[String:Any])
    case gameData(userID:String)
    case favorite(userid: String, gameid: Int, type:Int)
    case image(name:String)
    case transferPackagePoint(params:[String:Any])
}

extension GameAPI:TargetType{
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    
    var baseURL: URL {
        return URL(string: "http://game.gagagugu.com")!
    }
    
    var path: String{
        
        switch self {
        case .login:
            return "/api/v4/gameapp/gameappauth"
        case .gameData:
            return "/api/v4/gameapp/getallgameforapp/"
        case .favorite:
            return "/api/v4/gameapp/addorremovefavorite/"
        case .image(let name):
            return "/gameimages/\(name)"
        case .transferPackagePoint:
            return "/api/v4/gameapp/transferpackagepoint"
        }
        
    }
   
    
    var method: Moya.Method{
        switch self {
        case .login,.favorite, .transferPackagePoint:
            return .post
        case .gameData,.image:
            return .get
        
        }
        
    }
    
    var sampleData: Data {
        switch self {
        case .login,.gameData,.favorite,.image, .transferPackagePoint:
               return StubResponse.fromJSONFile(filePath:"")
        
        }
    }
    
    
    var task: Task {
        switch self {
    
        case .image:
            return .requestPlain
            
        case .gameData(let userID):
            
            return .requestCompositeData(bodyData: Data(), urlParameters: ["user_id":userID])
            
        case .login(let params),.transferPackagePoint(let params):
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .favorite(let user_id, let game_id,let type):
            
            let params = ["user_id":user_id,"game_id":game_id,"type":type] as [String : Any]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
}


class StubResponse {
    static func fromJSONFile(filePath:String) -> Data {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            fatalError("Invalid data from json file")
        }
        return data
    }
}

