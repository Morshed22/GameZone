//
//  SearchViewModel.swift
//  GG-Games
//
//  Created by Morshed Alam on 18/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SearchViewModeling {
    
   var gameListCell:Driver<[SearchTableViewCellModeling]>{get}
    var searchQuery:BehaviorRelay<String>{get}
}

struct SearchViewModel:SearchViewModeling {
    var searchQuery =  BehaviorRelay<String>(value:"")
    var gameListCell: SharedSequence<DriverSharingStrategy, [SearchTableViewCellModeling]>
    
    init(services:GameService){
        
        let minimumCharacterCount = 3
        let dueTime = 0.1
        
//
//        let gg = services.getAllGames().map{ gameArray in gameArray.filter({
//            $0.gameuid!.lowercased().contains(query.lowercased())
//        })}
        
        
        gameListCell = searchQuery.asObservable()
            .throttle(dueTime, scheduler: MainScheduler.instance)
            .flatMapLatest { query in
                (query.count >= minimumCharacterCount)
                    ? ShareGameData.shared.updatedGames.asObservable().map{ gameArray in gameArray.filter({
                        $0.category.lowercased().contains(query.lowercased()) ||  $0.gameuid!.lowercased().contains(query.lowercased())
                    })}
                    : ShareGameData.shared.updatedGames.asObservable()
            }.map{allGames in allGames.map{
                SearchTableViewCellViewModel(service: services,name: $0.name, category: $0.category, favorite: $0.favorite, icon: $0.icon)
                }}.asDriver(onErrorJustReturn: [])
            
        
        
//        gameListCell = services.getAllGames().map{allGames in allGames.map{
//            SearchTableViewCellViewModel(service: services,name: $0.name, category: $0.category, favorite: $0.favorite, icon: $0.icon)
//            }}.asDriver(onErrorJustReturn: [])
    }
    
}


