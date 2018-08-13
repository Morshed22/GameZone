//
//  SliderCellViewModel.swift
//  GG-Games
//
//  Created by Morshed Alam on 22/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SliderCellModeling {
    
    var image: Observable<UIImage> { get }
    
}

struct SliderCellViewModel:SliderCellModeling{
    
    var image: Observable<UIImage>
    
    init(service:GameService, name:String){
       image = Observable.just(UIImage())
               .concat(service.getImage(name: name))
               .observeOn(MainScheduler.instance)
               .catchErrorJustReturn(UIImage())
    }
}

