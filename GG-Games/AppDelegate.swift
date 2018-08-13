//
//  AppDelegate.swift
//  GG-Games
//
//  Created by Morshed Alam on 2/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import GoogleMobileAds



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = Coordinator()
    var appFlow: AppFlow!
    lazy var appServices =  Service()
    let GADApplicationID = "ca-app-pub-3940256099942544~1458002511"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        guard let window = self.window else { return false }
        GADMobileAds.configure(withApplicationID: self.GADApplicationID)
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print ("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        self.appFlow = AppFlow(withWindow: window, andServices: self.appServices)
        
        coordinator.coordinate(flow: self.appFlow, withStepper: AppStepper())
       
     return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

 
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
         //print(url.scheme)
        
        if url.scheme?.range(of: "com.googleusercontent") != nil{
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }else{
            return FBSDKApplicationDelegate.sharedInstance().application(
                app,
                open: url,
                sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
                annotation: options[UIApplicationOpenURLOptionsKey.annotation]
            )
        }

    }
}

