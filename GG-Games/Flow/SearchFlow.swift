//
//  SearchFlow.swift
//  GG-Games
//
//  Created by Morshed Alam on 4/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
//
//  WishlistFlow.swift
//  RxFlowDemo
//
//  Created by Thibault Wittemberg on 17-09-05.
//  Copyright (c) RxSwiftCommunity. All rights reserved.
//

import RxFlow
import RxSwift
import UIKit

class SearchFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
  
    private let services: GameService
    
    init(withServices services: GameService) {
        self.services = services
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
            
        case .searchList:
            return navigateToSearchScreen()
        
        default:
            return NextFlowItems.none
        }
    }
    
    private func navigateToSearchScreen () -> NextFlowItems {
        let viewModel = SearchViewModel(services: services)
        var searchVC = SearchVC.instantiate()
        searchVC.bindViewModel(to: viewModel)
        self.rootViewController.pushViewController(searchVC, animated: true)
        let colors = [UIColor.colorFrom(hexString: "#3FADFD")!, UIColor.colorFrom(hexString: "#706CE2")!]
        rootViewController.navigationBar.applyNavigationGradient(colors:colors)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: searchVC, nextStepper: searchVC))
    }
    
   
    
//    private func navigateToSettings () -> NextFlowItems {
//        let settingsStepper = SettingsStepper()
//        let settingsFlow = SettingsFlow(withServices: self.services, andStepper: settingsStepper)
//        Flows.whenReady(flow1: settingsFlow, block: { [unowned self] (root: UISplitViewController) in
//            self.rootViewController.present(root, animated: true)
//        })
//        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: settingsFlow, nextStepper: settingsStepper))
//    }
}


