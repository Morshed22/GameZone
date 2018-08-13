//
//  HomeFlow.swift
//  GG-Games
//
//  Created by Morshed Alam on 4/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation

import RxFlow
import RxSwift
import UIKit
import PopupDialog

class HomeFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController = HomeVC.instantiate()
    //private let homeStepper: HomeStepper
   // private let services: GameService
   
    private let  homeViewmodel:HomeViewModel
    private let service:GameService
    
    init(withServices services: GameService) {
        self.service = services
        self.homeViewmodel = HomeViewModel(services:services)
        
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
            
        case .gameList:
            return navigateToHomeScreen()
        case .gameCategory:
            return navigateToCategoryScreen()
        case .gameCategoryComplete(let category):
            return completeCategoryScreen(with:category)
        case .popUPinGameList(let game):
            return navigateToGamePopUP(game: game)
        case .isGamePopUPComplete:
            self.rootViewController.dismiss(animated: true, completion: nil)
            return NextFlowItems.none
        case .buyCredit:
             return  NextFlowItems.none
        case .playGame(let game):
            return navigateToPlayScreen(game: game)
            
        case .gameExit:
            self.rootViewController.dismiss(animated: true, completion: nil)
            return NextFlowItems.none
            
        default:
            return NextFlowItems.none
        }
    }
    
    private func navigateToHomeScreen () -> NextFlowItems {
        rootViewController.bindViewModel(to:homeViewmodel)
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: rootViewController, nextStepper: rootViewController))
    }
    
    private func navigateToCategoryScreen() -> NextFlowItems{
        let containerView = rootViewController.containerView
        homeViewmodel.isContainerHidden.onNext(false)
        let categoryVC = CategoryVC()
        rootViewController.addChildViewController(categoryVC)
        containerView?.addSubview(categoryVC.view)
        categoryVC.didMove(toParentViewController: rootViewController)
        let height = containerView?.frame.height
        let width = containerView?.frame.width
        categoryVC.view.frame = CGRect(x: 0, y: (containerView?.frame.maxY)!, width: width!, height: height!)
       return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: categoryVC, nextStepper: categoryVC))
        
    }
    
    private func completeCategoryScreen(with category:Category)->NextFlowItems{
        homeViewmodel.isContainerHidden.onNext(true)
        homeViewmodel.categoryItem.accept(category)
        let categoryVC = rootViewController.childViewControllers.last
        categoryVC?.willMove(toParentViewController: nil)
        categoryVC?.view.removeFromSuperview()
        categoryVC?.removeFromParentViewController()
        return NextFlowItems.none
    }
    
    private func navigateToGamePopUP (game:Game) -> NextFlowItems {
        let stepper = PopUpStepper(game: game)
        let popUpFlow = PopUpFlow(withServices: self.service)
        Flows.whenReady(flow1: popUpFlow, block: { [unowned self] (root: PopupDialog) in
            self.rootViewController.present(root, animated: true)
        })
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: popUpFlow, nextStepper: stepper))
    }
    
    private func navigateToPlayScreen(game:Game)->NextFlowItems{
        self.rootViewController.dismiss(animated: true, completion: nil)
        
        let stepper = GamePlayStepper(game: game)
        let gamePlayFlow = GamePlayFow(withServices: self.service)
        Flows.whenReady(flow1: gamePlayFlow, block: { [unowned self] (root: UINavigationController) in
            self.rootViewController.present(root, animated: true)
        })
        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: gamePlayFlow, nextStepper: stepper))
        
        
     
    }
    
    
    
//    private func navigateToGamePlayScreen(with gameID:Int) -> NextFlowItems{
//
//        let viewController = MovieDetailViewController.instantiate(withViewModel: MovieDetailViewModel(withMovieId: movieId), andServices: self.services)
//        viewController.title = viewController.viewModel.title
//        self.rootViewController.pushViewController(viewController, animated: true)
//        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: viewController, nextStepper: viewController.viewModel))
//    }
    
//    private func navigateToCastDetailScreen (with castId: Int) -> NextFlowItems {
//        let viewController = CastDetailViewController.instantiate(withViewModel: CastDetailViewModel(withCastId: castId), andServices: self.services)
//        viewController.title = viewController.viewModel.name
//        self.rootViewController.pushViewController(viewController, animated: true)
//        return NextFlowItems.none
//    }
//
//    private func navigateToSettings () -> NextFlowItems {
//        let settingsStepper = SettingsStepper()
//        let settingsFlow = SettingsFlow(withServices: self.services, andStepper: settingsStepper)
//        Flows.whenReady(flow1: settingsFlow, block: { [unowned self] (root: UISplitViewController) in
//            self.rootViewController.present(root, animated: true)
//        })
//        return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: settingsFlow, nextStepper: settingsStepper))
//    }
}

class HomeStepper: Stepper, HasDisposeBag {

    init() {
        self.step.accept(AppStep.gameList)

        // example of a periodic check of something to could lead to a global navigation action
        // for instance it could be an Interval in which we check the session validity. In case of
        // invalidity we could trigger a new Step (sessionInvalid for instance) that would lead to
        // a login popup
        //        Observable<Int>.interval(5, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self] (_) in
        //            self.step.accept(DemoStep.settings)
        //        }).disposed(by: self.disposeBag)
    }

//    @objc func settings () {
//        self.step.accept(DemoStep.settings)
//    }
}
