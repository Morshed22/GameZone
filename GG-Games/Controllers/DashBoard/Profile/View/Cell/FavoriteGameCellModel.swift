//
//  FavoriteGameCellModel.swift
//  GG-Games
//
//  Created by Morshed Alam on 31/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxCocoa
import RxSwift



struct FavoriteGameCellModel {
    
    
    var image: Observable<UIImage>
    var gameTitle:String
    
    init(service:GameService, title:String, imageName:String){
        
        image = Observable.just(UIImage())
            .concat(service.getImage(name: imageName))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(UIImage())
        
        gameTitle = title
        
        }
    
    
    
}

