//
//  HomeViewModel.swift
//  GG-Games
//
//  Created by Morshed Alam on 18/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action



protocol HomeViewModeling{
    
    var isLoading: Driver<Bool> {get}
    var sliderCell : Driver<[SliderCellModeling]>{get}
    var timer:Observable<Int>{get}
    var gameListCell:Driver<[GameListCellModeling]>{get}
    var isContainerHidden:PublishSubject<Bool>{get set }
    var categoryItem:BehaviorRelay<Category>{get set }
    var cellDidSelect:PublishSubject<Int>{get}
    var presentGame: Observable<Game> { get }
    
}


struct HomeViewModel:HomeViewModeling {
    
    var presentGame: Observable<Game>
    var categoryItem =  BehaviorRelay(value: CategoryList.catergories[0])
    var isContainerHidden = PublishSubject<Bool>()
    var timer: Observable<Int>{
        return  Observable<Int>.interval(2.0, scheduler: MainScheduler.instance)
    }
    var sliderCell: Driver<[SliderCellModeling]>
    var isLoading: Driver<Bool>
    var gameListCell: SharedSequence<DriverSharingStrategy, [GameListCellModeling]>
    let cellDidSelect: PublishSubject<Int> = PublishSubject<Int>()
    let disposeBag = DisposeBag()
    
    init(services:GameService){
        
        let loading = ActivityIndicator()
        self.isLoading = loading.asDriver()
        
        let gameData  = services.getAllGames()
            .observeOn(MainScheduler.instance)
            .trackActivity(loading)
            .share(replay: 1)
        sliderCell = gameData.map{ allGames in
            allGames.filter{ $0.slider != nil}
            }.map{ filterGame  in
                filterGame.map{SliderCellViewModel(service: services, name: $0.slider!)}
            }.asDriver(onErrorJustReturn: [])
        
        gameListCell  = Observable.combineLatest(categoryItem.asObservable(), gameData){($0, $1)}
            .flatMap { datas  -> Observable<[Game]> in
                if datas.0.title == "All Games"{
                    return Observable.just(datas.1)
                }else{
                    return Observable.just(datas.1.filter{game in game.category == datas.0.title})
                }
            }.map{allGames in allGames.map{
               GameListCellViewModel(service: services,gameID:$0.id,name: $0.name, category: $0.category, favorite: $0.favorite, icon: $0.icon)
                }}.asDriver(onErrorJustReturn: [])
        
       presentGame = cellDidSelect
              .withLatestFrom(gameData){ index, games in games[index]}
        
        
        
    }
    
    
}
