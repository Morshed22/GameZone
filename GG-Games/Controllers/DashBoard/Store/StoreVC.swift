//
//  StoreVC.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow

class StoreVC: UIViewController,StoryboardSceneBased, Stepper, BindableType {
    
    static let sceneStoryboard = UIStoryboard(name: "Store", bundle: nil)

    var viewModel: StoreViewModeling!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func bindViewModel() {
        
    }
}
