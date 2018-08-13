//
//  AppStep.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxFlow

enum AppStep:Step{
    
    case login
    case loginIsComplete
    case onBoarding
    case onBoardingIsComplete
    case dashBoard
    case gameList
    case gameCategory
    case gameCategoryComplete(category:Category)
    case searchList
    case storeList
    case profile
    case editProfile
    case popUPinGameList(game:Game)
    case isGamePopUPComplete
    case playGame(game:Game)
    case buyCredit
    case showAlertPopUp
    case exit
    case cancel
    case gameExit
    
}
