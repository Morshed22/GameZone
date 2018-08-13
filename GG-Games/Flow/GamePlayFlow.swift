//
//  GamePlayFlow.swift
//  GG-Games
//
//  Created by Morshed Alam on 2/8/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxFlow
import PopupDialog

class GamePlayFow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private  var rootViewController = UINavigationController()
    
    
    private let services: GameService
    private var gamePlayVC:GamePlayVC?
    
    init(withServices services: GameService) {
        self.services = services
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
            
        case .playGame(let game):
            return navigateToPlayScreen(game:game)
            
        case .showAlertPopUp:
            return naviagteToAlertPopUP()
         
        case .cancel:
            gamePlayVC?.dismiss(animated:true, completion: nil)
            return NextFlowItems.none
            
        case .exit:
            gamePlayVC?.dismiss(animated: true, completion: nil)
            return NextFlowItems.end(withStepForParentFlow: AppStep.gameExit)

        default:
            return NextFlowItems.none
        }
    }
    
    private func navigateToPlayScreen (game:Game) -> NextFlowItems {

        let viewModel = GamePlayViewModel(services: services, game:game)
         gamePlayVC = GamePlayVC.instantiate()
        gamePlayVC?.bindViewModel(to: viewModel)
        rootViewController.pushViewController(gamePlayVC!, animated: true)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: rootViewController, nextStepper: gamePlayVC!))
     
    }
    
    private func naviagteToAlertPopUP()-> NextFlowItems {
        
        let stepper = AlertPopUpStepper()
        let popUpFlow = AlertPopUpFlow()
        Flows.whenReady(flow1: popUpFlow, block: { [unowned self] (root: PopupDialog) in
            self.gamePlayVC?.present(root, animated: true)
        })
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: popUpFlow, nextStepper: stepper))
    }
    
   
    
}


class GamePlayStepper: Stepper, HasDisposeBag {
    
    init(game:Game) {
        self.step.accept(AppStep.playGame(game: game))
    }
    
}


