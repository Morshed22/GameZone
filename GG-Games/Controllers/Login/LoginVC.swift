//
//  LoginVC.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit
import RxFlow
import Action
import RxCocoa
import RxSwift
import GoogleSignIn

class LoginVC: UIViewController,GIDSignInUIDelegate, StoryboardBased,BindableType {
    
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var SMLoginView: SMLoginView!
    
    var viewModel:LoginViewModeling!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient()
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    private func setGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 112/255, green: 108/255, blue: 226/255, alpha: 1.0).cgColor, UIColor(red: 63/255, green: 173/255, blue: 253/255, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindViewModel() {
        
        SMLoginView.fbBtn
            .rx
            .bind(to: viewModel.fbLoginBtnClickListener){ _ in return self}

        
        viewModel.nextFlowScreen.drive(onNext: { isSuccess in
            if isSuccess {
            self.gotoNextflow(step: AppStep.loginIsComplete)
            }else{
                print("Something went wrong for go to next Step")
            }
        }).disposed(by: disposeBag)
        
        
        SMLoginView.gmailBtn
            .rx
            .action = viewModel.gmailLoginBtnClickListener
        
        viewModel.isLoading
            .drive(isLoading(for:self.view))
            .disposed(by: disposeBag)
        
    }
        
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LoginVC: Stepper {
    func gotoNextflow(step:AppStep){
        self.step.accept(step)
    }
}

