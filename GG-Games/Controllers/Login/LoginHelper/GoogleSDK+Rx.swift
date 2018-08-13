//
//  GoogleSDK+Rx.swift
//  GG-Games
//
//  Created by Morshed Alam on 11/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxSwift
import RxCocoa
import GoogleSignIn

open class RxGIDSignInDelegateProxy: DelegateProxy<GIDSignIn, GIDSignInDelegate>, DelegateProxyType, GIDSignInDelegate {
    public weak private(set) var gidSignIn: GIDSignIn?
    var signInSubject = PublishSubject<GIDGoogleUser>()
    var disconnectSubject = PublishSubject<GIDGoogleUser>()
    
    public init(gidSignIn: ParentObject) {
        self.gidSignIn = gidSignIn
        super.init(parentObject: gidSignIn, delegateProxy: RxGIDSignInDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxGIDSignInDelegateProxy(gidSignIn: $0) }
    }
    
    open class func currentDelegate(for object: ParentObject) -> GIDSignInDelegate? {
        return object.delegate
    }
    
    open class func setCurrentDelegate(_ delegate: GIDSignInDelegate?, to object: ParentObject) {
        object.delegate = delegate
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let u = user {
            self.signInSubject.on(.next(u))
        } else if let e = error {
            self.signInSubject.on(.error(e))
        }
        self._forwardToDelegate?.sign(signIn, didSignInFor: user, withError: error)
    }
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let u = user {
            self.disconnectSubject.on(.next(u))
        } else if let e = error {
            self.disconnectSubject.on(.error(e))
        }
        self._forwardToDelegate?.sign(signIn, didDisconnectWith: user, withError: error)
    }
    
    deinit {
        self.signInSubject.on(.completed)
        self.disconnectSubject.on(.completed)
    }
}

extension Reactive where Base: GIDSignIn {
    public var delegate: DelegateProxy<GIDSignIn, GIDSignInDelegate> {
        return self.gidSignInDelegate
    }

    var signIn: Single<[String:Any]> {
        let proxy = self.gidSignInDelegate
        proxy.signInSubject = PublishSubject<GIDGoogleUser>()
        return proxy.signInSubject
            .asObservable()
            .do(onSubscribed: {
                proxy.gidSignIn?.signIn()
            }).map{ user  in
                ["login_type": "gplus","\(User.CodingKeys.gplusId.rawValue)":user.userID, "\(User.CodingKeys.userName.rawValue)":user.profile.name,
                                    "\(User.CodingKeys.userPicture.rawValue)":"\(user.profile.imageURL(withDimension: 400))","\(User.CodingKeys.email.rawValue)": user.profile.email
                    ]
            }.take(1)
            .asSingle()
    }

    
     var signOut: Single<GIDGoogleUser> {
        let proxy = self.gidSignInDelegate
        proxy.signInSubject = PublishSubject<GIDGoogleUser>()
        return proxy.disconnectSubject
            .asObservable()
            .do(onSubscribed: {
                proxy.gidSignIn?.signOut()
            })
            .take(1)
            .asSingle()
    }
    
     var gidSignInDelegate: RxGIDSignInDelegateProxy {
        return RxGIDSignInDelegateProxy.proxy(for: base)
    }
}
