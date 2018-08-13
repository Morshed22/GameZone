//
//  DashboardFlow.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import UIKit
import RxFlow

class DashboardFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UITabBarController()
    private let services: GameService
    
    init(withServices services: GameService) {
        self.services = services
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
        case .dashBoard:
            return navigateToDashboard()
        default:
            return NextFlowItems.none
        }
    }
    
    private func navigateToDashboard () -> NextFlowItems {
        
        //let homeStepper = HomeStepper()
        let homeFlow = HomeFlow(withServices: services)
        let searchFlow = SearchFlow(withServices: services)
        let storeFlow = StoreFlow(withServices: services)
        let profileFlow = ProfileFlow(withServices: services)
        
        
        Flows.whenReady(flow1: homeFlow, flow2: searchFlow,flow3: storeFlow, flow4: profileFlow, block: { [unowned self] (root1: UIViewController, root2: UINavigationController, root3: UIViewController, root4: UIViewController) in
            
            let tabBarItem1 = UITabBarItem(title: nil, image:#imageLiteral(resourceName: "home_inactive_icon"), selectedImage:#imageLiteral(resourceName: "home_active_icon"))
            let tabBarItem2 = UITabBarItem(title: nil, image:#imageLiteral(resourceName: "search_inactive_icon"), selectedImage: #imageLiteral(resourceName: "search_active_icon"))
            let tabBarItem3 = UITabBarItem(title: nil, image:#imageLiteral(resourceName: "store_inactive_icon"), selectedImage:#imageLiteral(resourceName: "store_active_icon"))
            let tabBarItem4 = UITabBarItem(title: nil, image:#imageLiteral(resourceName: "profile_inactive_icon"), selectedImage: #imageLiteral(resourceName: "profile_active_icon"))
            
            
            root1.tabBarItem = tabBarItem1
            root2.tabBarItem = tabBarItem2
            root3.tabBarItem = tabBarItem3
            root4.tabBarItem = tabBarItem4
            
            self.rootViewController.setViewControllers([root1, root2, root3, root4], animated: false)
        })
        
        return NextFlowItems.multiple(flowItems: [
            NextFlowItem(nextPresentable: homeFlow, nextStepper:OneStepper(withSingleStep: AppStep.gameList)),
            NextFlowItem(nextPresentable: searchFlow, nextStepper: OneStepper(withSingleStep: AppStep.searchList)),
            NextFlowItem(nextPresentable: storeFlow, nextStepper:OneStepper(withSingleStep: AppStep.storeList)),
            NextFlowItem(nextPresentable: profileFlow, nextStepper: OneStepper(withSingleStep: AppStep.profile))
            ])
        
    }
}
