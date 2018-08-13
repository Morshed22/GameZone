//
//  FacebookSDK+Rx.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//


import Foundation
import RxSwift
import FacebookLogin
import FBSDKLoginKit
import FacebookCore
import SwiftyJSON

enum FacebookSDKError: Error {
    case tokenNotFound
}

extension LoginManager {
    
    func login(from: UIViewController?) -> Observable<AccessToken> {
        return Observable.create {  observer in
            self.logIn(readPermissions: [.publicProfile, .email, .userFriends,], viewController: from, completion: { loginResult in
                switch loginResult {
                case .failed(let error):
                    observer.on(.error(error))
                case .cancelled:
                    print("User cancelled login.")
                    observer.on(.completed)
                case .success( _, _, let token):
                    observer.on(.next(token))
                    observer.on(.completed)
                }
            })
            return Disposables.create()
        }
    }
}

extension Reactive where Base: FBSDKGraphRequest {
    
    
    static func fetchMe(appID:String) -> Observable<[String:Any]> {
        return Observable.create { observer in
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, email, birthday,picture.type(large)"])
            //parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"]
            let task = request?.start { connection, result, error in
                if let error = error {
                    observer.on(.error(error))
                    return
                }
//                print("******************************************")
//                print(result)
//                 print("******************************************")
                
                guard let result = result else {
                    observer.on(.error(FacebookSDKError.tokenNotFound))
                    return
                }
                let json = JSON(result)
                let name = json["name"].string
                let email = json["email"].string
                let profilePicUrl = json["picture"]["data"]["url"].string
                
                let response = ["login_type": "fb", "\(User.CodingKeys.userName.rawValue)": name!,"\(User.CodingKeys.fbId.rawValue)":appID,
                                         "\(User.CodingKeys.userPicture.rawValue)":profilePicUrl!,"\(User.CodingKeys.email.rawValue)": email!
                                         ]
                observer.on(.next(response))
                observer.on(.completed)
            }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
