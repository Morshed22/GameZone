//
//  ProfileViewModel.swift
//  GG-Games
//
//  Created by Morshed Alam on 31/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxSwift
import RxCocoa

protocol ProfileViewModeling {
    var favoriteGames:Observable<[FavoriteGameCellModel]>{get }
    var userData:Observable<User>{get}
    var recentGames:Observable<[RecentGameCellModel]>{get }
    
    
}


struct ProfileViewModel:ProfileViewModeling {
    var recentGames: Observable<[RecentGameCellModel]>
    var userData: Observable<User>
    var favoriteGames: Observable<[FavoriteGameCellModel]>
    var favouriteArrayCount = BehaviorRelay<Int>(value: 0)

    init(service:GameService){
        
        favoriteGames = ShareGameData.shared
                      .updatedGames
                      .map{$0.filter{$0.favorite == 1}}
                       .map{$0.map{FavoriteGameCellModel(service: service, title: $0.name!, imageName: $0.icon)}}
                       .share(replay: 1)

        userData = Observable.of(UserData().user).filter{$0 != nil}.map{$0!}
        recentGames = ShareGameData.shared.recentsGame
            .asObservable().map{
            games in games.map{
                RecentGameCellModel(service: service, title: $0.name!, imageName: $0.icon)
            }
        }
    }
}
