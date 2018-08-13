//
//  UserData.swift
//  GG-Games
//
//  Created by Morshed Alam on 8/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation

struct UserData {
    
    var user: User? {
        get {
          guard let userDecodedData = UserDefaults.standard.value(forKey:UserDefaultsKeys.User.rawValue) as? Data else {
                return nil
                }
            let decoder = JSONDecoder()
            guard  let userData = try? decoder.decode(User.self, from: userDecodedData) else { return  nil }
            return userData
        }
        set {
            let encoder = JSONEncoder()
            guard let userEncodeData = try? encoder.encode(newValue) else {
                return
            }
            self.userDefaults.setValue(userEncodeData, forKey: UserDefaultsKeys.User.rawValue)
        }
    }
    
    
    var userExists: Bool {
        guard let _ = user else {
            return false
        }
        return true
    }
    
    private let userDefaults: UserDefaults
    
    private enum UserDefaultsKeys: String {
        case User = "user"
    }
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    
}



