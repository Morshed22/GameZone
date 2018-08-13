//
//  AppFlow.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import UIKit
import RxFlow
import FBSDKLoginKit
import GoogleSignIn

class AppFlow: Flow {
    
    var root: Presentable {
        return self.rootWindow
    }
    
    private let rootWindow: UIWindow
    private let services: GameService
    
    init(withWindow window: UIWindow, andServices services: GameService) {
        self.rootWindow = window
        self.services = services
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
        case .onBoarding:
            return navigationToOnboardingScreen()
        case .onBoardingIsComplete, .dashBoard:
            return navigationToDashboardScreen()
        default:
            return NextFlowItems.none
            
        }
    }
    
    private func navigationToOnboardingScreen () -> NextFlowItems {
        let onboardingFlow = OnboardingFlow(withServices: self.services)
        Flows.whenReady(flow1: onboardingFlow) { [unowned self] (root) in
            self.rootWindow.rootViewController = root
        }
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: onboardingFlow, nextStepper: OneStepper(withSingleStep: AppStep.login)))
    }
    
    private func navigationToDashboardScreen () -> NextFlowItems {
        let dashboardFlow = DashboardFlow(withServices: self.services)
        Flows.whenReady(flow1: dashboardFlow) { [unowned self] (root) in
            self.rootWindow.rootViewController = root
        }
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: dashboardFlow, nextStepper: OneStepper(withSingleStep: AppStep.dashBoard)))
    }
    
}

class AppStepper: Stepper {
    //business logic for if user is already login
    
    init() {
        self.step.accept(AppStep.onBoarding)
        
        if FBSDKAccessToken.current() != nil {
            self.step.accept(AppStep.dashBoard)
            
        }else if GIDSignIn.sharedInstance().hasAuthInKeychain(){
                self.step.accept(AppStep.dashBoard)
            
        }else{
            self.step.accept(AppStep.onBoarding)
        }

    }
}
