//
//  AlertPopUpFlow.swift
//  GG-Games
//
//  Created by Morshed Alam on 9/8/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxFlow
import PopupDialog



class AlertPopUpFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    private var alertVC:AlertVC?
    
    private lazy var rootViewController: PopupDialog = {
        
        alertVC = AlertVC(nibName: "AlertVC", bundle: nil)
        
        let  popVC =  PopupDialog( viewController: alertVC!,
                                   buttonAlignment: .horizontal,
                                   transitionStyle: .bounceUp,
                                   preferredWidth: 240,
                                   tapGestureDismissal: false,
                                   panGestureDismissal: false)
        
        return popVC
    }()

    init() { }
    
    
    func navigate(to step: Step) -> NextFlowItems {
        
        guard let step = step as? AppStep else { return NextFlowItems.none }
        
        switch step {
        case .showAlertPopUp:
            return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: rootViewController, nextStepper: alertVC!))

        case .cancel:
            return NextFlowItems.end(withStepForParentFlow: AppStep.cancel)
        case .exit:
            return NextFlowItems.end(withStepForParentFlow: AppStep.exit)
            
        default:
            return NextFlowItems.none
        }
    }

}

class AlertPopUpStepper: Stepper, HasDisposeBag {
    
    init() {
        self.step.accept(AppStep.showAlertPopUp)
    }
    
}
