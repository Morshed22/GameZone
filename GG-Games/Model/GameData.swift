//
//  GameData.swift
//  GG-Games
//
//  Created by Morshed Alam on 21/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import RxSwift



struct GameData {
   // static let  key = "game"
    
    
    var game: [Game]? {

        get {
            guard let gameData = UserDefaults.standard.value(forKey:UserDefaultsKeys.game.rawValue) as? Data else {
                return nil
            }
            let decoder = JSONDecoder()
            guard  let games = try? decoder.decode([Game].self, from: gameData) else { return  nil }
            return games
        }
        set {
            let encoder = JSONEncoder()
            guard let userEncodeData = try? encoder.encode(newValue) else {
                return
            }
            self.userDefaults.setValue(userEncodeData, forKey: UserDefaultsKeys.game.rawValue)
            self.userDefaults.set(0, forKey: Category.key)
        }
    }
    var recentGame:[Game]?{
        get {
            guard let gameData = UserDefaults.standard.value(forKey:UserDefaultsKeys.recentGame.rawValue) as? Data else {
                return nil
            }
            let decoder = JSONDecoder()
            guard  let games = try? decoder.decode([Game].self, from: gameData) else { return  nil }
            return games
        }
        set {
            let encoder = JSONEncoder()
            guard let userEncodeData = try? encoder.encode(newValue) else {
                return
            }
            self.userDefaults.setValue(userEncodeData, forKey: UserDefaultsKeys.recentGame.rawValue)
        }
    }
   //var favouriteGame:PublishSubject<[Game]>
    
    
    var gameExists: Bool {
        guard let _ = game else {
            return false
        }
        return true
    }
    
    private let userDefaults: UserDefaults
    
    private enum UserDefaultsKeys: String {
        case game = "game"
        case recentGame = "recentGame"
    }
    
    init() {
        self.userDefaults = UserDefaults.standard

    }
    
    
}



