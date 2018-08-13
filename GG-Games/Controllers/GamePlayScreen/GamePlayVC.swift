//
//  GamePlayVC.swift
//  GG-Games
//
//  Created by Morshed Alam on 2/8/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa
import WebKit
class GamePlayVC: UIViewController,StoryboardSceneBased, Stepper, BindableType {
    
    @IBOutlet weak var cancelBarBtn: UIBarButtonItem!
    @IBOutlet weak var wkWebView: WKWebView!
    static let sceneStoryboard = UIStoryboard(name: "GamePlay", bundle: nil)
    
    var viewModel:GamePlayViewModeling!
    let disposeBag =  DisposeBag()
   //BindableType
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    func bindViewModel() {
     
        viewModel
            .playGame.asObservable()
            .subscribe(onNext: { [weak self] game in
                guard let `self` = self, let uid = game.gameuid, let url = URL(string: "http://game.gagagugu.com/gameplay/\(uid)") else { return }
                print(url)
                self.wkWebView.load(URLRequest(url: url))
            }).disposed(by: disposeBag)

       viewModel.recentGames
        .subscribe(onNext: { games in
            ShareGameData.shared.recentsGame.accept(games)
        }).disposed(by: disposeBag)

        cancelBarBtn.rx.tap
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe( onNext:{ [weak self] _  in
                guard let `self` = self else { return }
                self.step.accept(AppStep.showAlertPopUp)
            }).disposed(by: disposeBag)
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
