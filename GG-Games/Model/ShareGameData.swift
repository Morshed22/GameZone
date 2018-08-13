//
//  ShareGameData.swift
//  GG-Games
//
//  Created by Morshed Alam on 30/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxSwift
import RxCocoa

struct ShareGameData {
    private init() {}
    static let shared = ShareGameData()
    var updatedGames:BehaviorRelay<[Game]> = BehaviorRelay(value: [])
    var recentsGame:BehaviorRelay<[Game]> = BehaviorRelay<[Game]>(value: [])

}

