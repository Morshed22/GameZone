//
//  GameListCell.swift
//  GG-Games
//
//  Created by Morshed Alam on 23/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

protocol GameListCellModeling {

    var image: Observable<UIImage> { get }
    var favoriteIconValue:BehaviorRelay<Int>{get}
    var gameTitle:String{get}
    var category:String{get}
    var favBtnClickListener:CocoaAction{ get }
    
}


struct GameListCellViewModel:GameListCellModeling{
    
    var favoriteIconValue = BehaviorRelay<Int>(value:0)
    var gameTitle: String
    var category: String
    var image: Observable<UIImage>
    private let service:GameService
    private var gameID:Int
    
    var favBtnClickListener : CocoaAction{
        
        return CocoaAction { _ in
            
            var gameData = GameData()
            guard var favGame = gameData.game else { return Observable.just(())}
            let index = favGame.index(where: {$0.id == self.gameID})
             favGame[index!].favorite = favGame[index!].favorite ==  0 ? 1 : 0
             gameData.game = favGame
             ShareGameData.shared.updatedGames.accept(favGame)
            self.favoriteIconValue.accept(self.favoriteIconValue.value == 0 ? 1 : 0)
            let  user = Observable.of(UserData().user)
                .filter{$0 != nil}
                . map{$0!}
 
           return Observable.combineLatest(user, Observable.of(self.gameID), self.favoriteIconValue.asObservable())
                .flatMapLatest{
                     self.service.favoriteGame(userid: $0.0.userId, gameid: $0.1, type: $0.2)
                 }
        }
    }
    
    init(service:GameService,gameID:Int, name:String?, category:String,favorite:Int, icon:String){
        self.service = service
        self.gameID = gameID
        self.gameTitle = name ?? ""
        self.category = category
        self.image = Observable.just(UIImage())
            .concat(service.getImage(name:icon))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(UIImage())
        favoriteIconValue.accept(favorite)
        
    }


}
    
    

