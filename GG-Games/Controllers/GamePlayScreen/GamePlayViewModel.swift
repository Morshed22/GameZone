//
//  GamePlayViewModel.swift
//  GG-Games
//
//  Created by Morshed Alam on 9/8/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import Action

protocol GamePlayViewModeling {
    var playGame:Driver<Game>{get}
    var recentGames:Observable<[Game]>{get}
}

struct GamePlayViewModel:GamePlayViewModeling {
    var recentGames: Observable<[Game]>

    var playGame: SharedSequence<DriverSharingStrategy, Game>
    
    init(services:GameService, game:Game){
        playGame = Driver.just(game)
       recentGames = ShareGameData.shared.recentsGame
        .asObservable()
        .observeOn(MainScheduler.instance)
           .flatMap{ games  -> Observable<[Game]> in
            var recentGames = games
            var gameData = GameData()
            let isAlreadyExist = recentGames.contains(obj:game)
            if !isAlreadyExist && recentGames.count < 10{
                recentGames.appendAtFirst(newItem:game)
            }else if recentGames.count >= 10{
                recentGames.removeLast()
                recentGames.appendAtFirst(newItem: game)
            }
            gameData.recentGame = recentGames
            return Observable.just(recentGames)
        }
    }
    
}

