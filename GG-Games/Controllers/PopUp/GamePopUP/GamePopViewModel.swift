//
//  GamePopViewModel.swift
//  GG-Games
//
//  Created by Morshed Alam on 1/8/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxSwift
import RxCocoa
import Action
import RxFlow
import GoogleMobileAds


protocol GamePopViewModeling {
    
       var image: Observable<UIImage> { get }
       var isCreditAvailabel:Observable<Bool>{get}
       var game:Observable<Game> {get}
      // var playWithCreditOrByeCredit:Observable<(Bool,Game)>{get}
       var appStep:Observable<AppStep>{get}
       var loadRewardVideoAction:Action<UIViewController, Void>{get}
       var goToGameScreenWithFreePlay:Observable<Step>{get}
    
    
}


struct GamePopViewModel:GamePopViewModeling {
    var goToGameScreenWithFreePlay: Observable<Step>

    var loadRewardVideoAction: Action<UIViewController, Void>{
        return Action(workFactory: { from in
           return  GADRewardBasedVideoAd.sharedInstance().rx.showRewardFrom(from: from).map{_ in}
        })
    }
    
    var appStep: Observable<AppStep>
    
    //var playWithCreditOrByeCredit: Observable<(Bool,Game)>
    
    var isCreditAvailabel: Observable<Bool>

      var game: Observable<Game>
    //var user: SharedSequence<DriverSharingStrategy, User?>

    var image: Observable<UIImage>

    init(service:GameService, game:Game) {
        var user = UserData().user
         self.game = Observable.just(game)
         self.image = Observable.just(UIImage())
            .concat(service.getImage(name:game.largeIcon ?? ""))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(UIImage())

        let userData = Observable.of(user).map{$0!}.share()
        
        isCreditAvailabel = userData.map{$0.totalCoin >= 5}
        
        appStep = isCreditAvailabel.map{$0}
                .flatMap{ status -> Observable<AppStep> in
                
                if status {
                    return service.updateBalance(param: ["access_token":user!.accessToken,"package_code":"game_play"])
                        .do(onSuccess: {
                            if $0.status{
                                var newUser = user!
                                newUser.totalCoin = $0.total_balance
                                user = newUser
                            }
                         })
                         .asObservable()
                         .observeOn(MainScheduler.instance)
                         .map{$0.status ? AppStep.playGame(game: game) : AppStep.isGamePopUPComplete}
                }else{
                   return Observable.just(AppStep.buyCredit)
                }
            }

        goToGameScreenWithFreePlay = GADRewardBasedVideoAd.sharedInstance()
            .rx
            .isCloseVideoScreen
            .flatMap{ isViewed in
                return Observable.just(isViewed ? AppStep.playGame(game: game) : AppStep.isGamePopUPComplete)
            }
        
        
        
//
//        playWithCreditOrByeCredit = Observable<(Bool, Game)>
//                                 .combineLatest(isCreditAvailabel,Observable.just(game)){($0,$1)}
//            .flatMap{ items -> Observable<(Bool, Game)> in
//                if items.0{
//                    let params = ["access_token":user!.accessToken,"package_code":"game_play"]
//                    // return service.updateBalance(param: params).flat
//                    var newUser = user!
//                    newUser.totalCoin = newUser.totalCoin - 5
//                    user = newUser
//                }
//               return Observable.just(items)
//            }
        
     
    }
    
    
}
