//
//  RxGADRewardBasedVideoAdDelegateProxy.swift
//  GG-Games
//
//  Created by Morshed Alam on 7/8/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import RxSwift
import RxCocoa



public class RxGADRewardBasedVideoAdDelegateProxy: DelegateProxy<GADRewardBasedVideoAd, GADRewardBasedVideoAdDelegate>, DelegateProxyType, GADRewardBasedVideoAdDelegate {
   
    public weak private(set) var rewardAd: GADRewardBasedVideoAd?
     var isGetRewarded  = BehaviorRelay<Bool>(value: false)
     var isCloseVideo = PublishSubject<Void>()

    init(rewardAd:ParentObject){
        self.rewardAd = rewardAd
        super.init(parentObject: rewardAd, delegateProxy: RxGADRewardBasedVideoAdDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register {  RxGADRewardBasedVideoAdDelegateProxy(rewardAd: $0)}
    }
    
    public static func currentDelegate(for object: GADRewardBasedVideoAd) -> GADRewardBasedVideoAdDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: GADRewardBasedVideoAdDelegate?, to object: GADRewardBasedVideoAd) {
        object.delegate  = delegate
    }
    
    public func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        
        self.isCloseVideo.onNext(())
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        self._forwardToDelegate?.rewardBasedVideoAdDidClose(rewardBasedVideoAd)
    }
    
    public func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
         self.isGetRewarded.accept(true)
        self._forwardToDelegate?.rewardBasedVideoAd(rewardBasedVideoAd, didRewardUserWith: reward)
    }

    
}


extension Reactive where Base: GADRewardBasedVideoAd {
    
    public var delegate: DelegateProxy<GADRewardBasedVideoAd, GADRewardBasedVideoAdDelegate> {
        return self.gadRewardAdDelegate
    }

    var gadRewardAdDelegate: RxGADRewardBasedVideoAdDelegateProxy {
        return RxGADRewardBasedVideoAdDelegateProxy.proxy(for: base)
    }
    
     func showRewardFrom(from: UIViewController?)->Single<Bool>{
        let proxy = self.gadRewardAdDelegate
        return  Observable.just(proxy.rewardAd?.isReady).debug()
                .filter{$0 != nil}
                .skipWhile{$0 == false}
                .map{$0!}
               .do(onSubscribed: {
                proxy.rewardAd?.present(fromRootViewController: from!)
                })
              .asSingle()
        }
    
   
    var isCloseVideoScreen:Observable<Bool>{
        let proxy = self.gadRewardAdDelegate
        return proxy.isCloseVideo.asObservable()
              .withLatestFrom(proxy.isGetRewarded)
    }

}
