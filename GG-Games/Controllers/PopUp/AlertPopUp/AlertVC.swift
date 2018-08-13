//
//  AlertVC.swift
//  AlertVCExample
//
//  Created by Rumana Rahman on 8/6/18.
//  Copyright © 2018 Rumana Rahman. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

class AlertVC: UIViewController, Stepper{
 
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
   let disposeBag =  DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
       exitButton.rx.tap
        .debounce(0.2, scheduler: MainScheduler.instance)
        .subscribe( onNext:{ [weak self] _  in
            guard let `self` = self else { return }
            self.step.accept(AppStep.exit)
        }).disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe( onNext:{ [weak self] _  in
                guard let `self` = self else { return }
                self.step.accept(AppStep.cancel)
            }).disposed(by: disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
   
}



