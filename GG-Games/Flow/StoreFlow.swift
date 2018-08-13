//
//  StoreFlow.swift
//  GG-Games
//
//  Created by Morshed Alam on 4/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxFlow
import RxSwift
import UIKit


class StoreFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController = StoreVC.instantiate()
    
    private let  storeViewModel:StoreViewModel
    
    init(withServices services: GameService) {
        self.storeViewModel = StoreViewModel(service: services)
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
            
        case .storeList:
            return navigateToStoreScreen()
            //        case .gameCategory:
            //            return navigateToCategoryScreen()
            //        case .gameCategoryComplete(let category):
        //            return completeCategoryScreen(with:category)
        default:
            return NextFlowItems.none
        }
    }
    
    private func navigateToStoreScreen () -> NextFlowItems {
        rootViewController.bindViewModel(to:storeViewModel)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: rootViewController, nextStepper: rootViewController))
    }
    
    //    private func navigateToCategoryScreen() -> NextFlowItems{
    //        let containerView = rootViewController.containerView
    //        homeViewmodel.isContainerHidden.onNext(false)
    //        let categoryVC = CategoryVC()
    //        rootViewController.addChildViewController(categoryVC)
    //        containerView?.addSubview(categoryVC.view)
    //        categoryVC.didMove(toParentViewController: rootViewController)
    //        let height = containerView?.frame.height
    //        let width = containerView?.frame.width
    //        categoryVC.view.frame = CGRect(x: 0, y: (containerView?.frame.maxY)!, width: width!, height: height!)
    //        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: categoryVC, nextStepper: categoryVC))
    //
    //    }
    
    //    private func completeCategoryScreen(with category:Category)->NextFlowItems{
    //        homeViewmodel.isContainerHidden.onNext(true)
    //        homeViewmodel.categoryItem.accept(category)
    //        let categoryVC = rootViewController.childViewControllers.last
    //        categoryVC?.willMove(toParentViewController: nil)
    //        categoryVC?.view.removeFromSuperview()
    //        categoryVC?.removeFromParentViewController()
    //        return NextFlowItems.none
    //    }
    //
    
    
    
    
}


