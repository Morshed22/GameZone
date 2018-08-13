//
//  SearchTableViewCellViewModel.swift
//  GG-Games
//
//  Created by Morshed Alam on 29/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SearchTableViewCellModeling {
    var image: Observable<UIImage> { get }
    var favoriteIconValue:BehaviorRelay<Int>{get}
    var gameTitle:String{get}
    var category:String{get}
}


struct SearchTableViewCellViewModel: SearchTableViewCellModeling{
    
    var favoriteIconValue = BehaviorRelay<Int>(value:0)
    var gameTitle: String
    var category: String
    var image: Observable<UIImage>
    
    init(service:GameService, name:String?, category:String,favorite:Int, icon:String){
        self.gameTitle = name ?? ""
        self.category = category
        self.image = Observable.just(UIImage())
            .concat(service.getImage(name:icon))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(UIImage())
        favoriteIconValue.accept(favorite)
    }

}
