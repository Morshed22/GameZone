//
//  LoginViewModel.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import RxFlow

protocol LoginViewModeling{
   
    var fbLoginBtnClickListener:Action<UIViewController, Void>{ get }
    var gmailLoginBtnClickListener:CocoaAction{get}
    var isLoading: Driver<Bool> { get }
    var nextFlowScreen:Driver<Bool>{get}
    
}

struct LoginViewModel: LoginViewModeling {
    var gmailLoginBtnClickListener: CocoaAction
    var nextFlowScreen:Driver<Bool>
    var isLoading: Driver<Bool>
    var fbLoginBtnClickListener: Action<UIViewController, Void>
    
    init(services:GameService){
        let loading = ActivityIndicator()
        self.isLoading = loading.asDriver()
        let nextScreen = PublishSubject<Bool>()
        nextFlowScreen = nextScreen.asDriver(onErrorJustReturn: false)
        
        self.fbLoginBtnClickListener = Action<UIViewController, Void> { controller in
            return LoginManager().login(from:controller).flatMap({ token in
                return  FBSDKGraphRequest.rx.fetchMe(appID: token.appId).flatMapLatest{ param in
                    return services.afterFbOrGmailSignIn(param: param).trackActivity(loading)
                    }.map{nextScreen.onNext($0)}
            })
        }
        
        self.gmailLoginBtnClickListener = CocoaAction{ _ in
            return GIDSignIn.sharedInstance()
                .rx.signIn.flatMap{ parameter in
                    return services.afterFbOrGmailSignIn(param: parameter)
                }.asObservable()
                .trackActivity(loading)
                .map{ nextScreen.onNext($0)}
            
          }
  }

}
//extension LoginViewModel:Stepper{
//    func gotoAnotherScreen(){
//        self.step.accept(AppStep.dashBoard)
//    }
//}

//extension PrimitiveSequenceType where Self.TraitType == RxSwift.SingleTrait {
//    func flatMapToCompletable() -> Completable {
//        return Completable.create { completable -> Disposable in
//            return self.subscribe(onSuccess: { _ in
//                completable(.completed)
//            }, onError: { error in
//                completable(.error(error))
//            })
//        }
//    }
//}
