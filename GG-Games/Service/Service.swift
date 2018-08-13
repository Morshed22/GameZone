//
//  Service.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import Moya
import Result
import RxSwift
import SwiftyJSON


protocol GameService {
    
    var GameServiceProvider:MoyaProvider<GameAPI> {get}
    func afterFbOrGmailSignIn(param:[String:Any])-> Single<Bool>
    func getAllGames()-> Single<[Game]>
    func gameDataFromLocal()-> Single<[Game]>
    func getImage(name:String)-> Observable<UIImage>
    func favoriteGame(userid: String, gameid: Int, type:Int)-> Observable<Void>
    func updateBalance(param:[String:Any])->Single<UserBalance>
}


struct Service:GameService {
    

    
    var GameServiceProvider = MoyaProvider<GameAPI>()
    
    init() {
//       self.GameServiceProvider = MoyaProvider<GameAPI>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
    }
    
    
    func getImage(name:String)->Observable<UIImage> {
        
        return GameServiceProvider.rx.request(.image(name: name))
                 .mapImage()
                .asObservable().map{$0!}
    }
    
    
    func gameDataFromLocal()-> Single<[Game]>{
        
        return Observable.of(GameData().game)
                .catchErrorJustReturn([])
                .filter { $0 != nil }
                .map { $0! }
               .asSingle()
    }
    
    func getAllGames() -> Single<[Game]>{
        
        return   Observable.of(UserData().user?.userId)
            .filter{ $0 != nil }
            .map{$0!}
            .asSingle()
            .flatMap { userID   in
                return self.GameServiceProvider.rx.request(.gameData(userID: userID))
            }
            .filter(statusCode: 200)
            .map([Game].self, atKeyPath: "data", using: JSONDecoder(), failsOnEmptyData: true)
            .flatMap { game  in
                var gameData = GameData()
                gameData.game = game
                ShareGameData.shared.updatedGames.accept(game)
                ShareGameData.shared.recentsGame.accept(gameData.recentGame ?? [])
                return Single.just(game)
            }.catchError{   _ in
                return self.gameDataFromLocal()
        }
    }
    
    func afterFbOrGmailSignIn(param:[String:Any])-> Single<Bool>{

        return  GameServiceProvider.rx.request(.login(params:param))
            .mapJSON()
            .observeOn(MainScheduler.instance)
            .flatMap({ data -> Single<Bool> in
                let json = JSON(data)
                if let user = User(json:json["user_data"]){
                    var userData = UserData()
                    userData.user = user
                    return Single.just(true)
                }else{
                    return Single.just(false)
                }
            })
    }
    
    func updateBalance(param: [String : Any]) -> PrimitiveSequence<SingleTrait, UserBalance> {
        
          return GameServiceProvider.rx
                   .request(.transferPackagePoint(params: param))
                   .map(UserBalance.self)
                    .catchError{ _ -> PrimitiveSequence<SingleTrait, UserBalance> in
                      return Single.just(UserBalance(status: false, total_balance: 0))
                   }
        
        
    }
    
    
    func favoriteGame(userid: String, gameid: Int, type: Int) -> Observable<Void> {
        return GameServiceProvider.rx.request(.favorite(userid: userid, gameid: gameid, type: type)).asObservable().map{ _ in }
    }
    
    
    private func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data // fallback to original data if it can't be serialized.
        }
    }
}

