//
//  PopUPFlow.swift
//  GG-Games
//
//  Created by Morshed Alam on 1/8/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxFlow
import PopupDialog



class PopUpFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    private var gamePopUpVC:GamePopUpVC?
    
    private lazy var rootViewController: PopupDialog = {
        
        gamePopUpVC = GamePopUpVC(nibName: "GamePopUpVC", bundle: nil)
        
        // Create the dialog
        let  popVC =  PopupDialog( viewController: gamePopUpVC!,
                              buttonAlignment: .horizontal,
                              transitionStyle: .bounceDown,
                              preferredWidth: 240,
                              tapGestureDismissal: true,
                              panGestureDismissal: false)
        
        return popVC
    }()
    
    
    
    private let service:GameService
    
    init(withServices services: GameService) {
        self.service = services
    }
    
    
    func navigate(to step: Step) -> NextFlowItems {
        
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
            
        case .popUPinGameList(let game):
            return navigateToPopupScreen(game:game)
         
        case .buyCredit:
            return NextFlowItems.end(withStepForParentFlow: AppStep.buyCredit)
            
        case .playGame(let game):
            
          return  NextFlowItems.end(withStepForParentFlow: AppStep.playGame(game: game))
        
        case .isGamePopUPComplete:
            return NextFlowItems.end(withStepForParentFlow: AppStep.isGamePopUPComplete)
        default:
            return NextFlowItems.none
        }
    }
    
    private func navigateToPopupScreen (game:Game) -> NextFlowItems {
        let gamePopViewModel = GamePopViewModel(service: service, game: game)
        gamePopUpVC!.bindViewModel(to: gamePopViewModel)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: rootViewController, nextStepper: gamePopUpVC!))
    }
    
   
}




class PopUpStepper: Stepper, HasDisposeBag {
    
    init(game:Game) {
        self.step.accept(AppStep.popUPinGameList(game: game))
    }
    
}

