//
//  OnboardingFlow.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import UIKit
import RxFlow

class OnboardingFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
     private var rootViewController = LoginVC.instantiate()
    
   // private let services: GameService
    private let  loginViewmodel:LoginViewModel
    
    init(withServices services: GameService) {
        
        loginViewmodel = LoginViewModel(services: services)
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
        case .login:
            return navigationToLoginScreen()
        case .loginIsComplete:
            return NextFlowItems.end(withStepForParentFlow: AppStep.onBoardingIsComplete)
        default:
            return NextFlowItems.none
        }
    }
    
    private func navigationToLoginScreen () -> NextFlowItems {
        rootViewController.bindViewModel(to: loginViewmodel)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: rootViewController, nextStepper: rootViewController))
    }
    
//    private func navigationToApiScreen () -> NextFlowItems {
//        let settingsViewModel = SettingsApiKeyViewModel()
//        let settingsViewController = SettingsApiKeyViewController.instantiate(withViewModel: settingsViewModel, andServices: self.services)
//        settingsViewController.title = "Api Key"
//        self.rootViewController.pushViewController(settingsViewController, animated: true)
//        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: settingsViewController, nextStepper: settingsViewModel))
//    }
    
}
