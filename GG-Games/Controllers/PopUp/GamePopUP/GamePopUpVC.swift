//
//  GamePopUpVC.swift
//  GG-Games
//
//  Created by Morshed Alam on 1/8/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa


class GamePopUpVC: UIViewController, Stepper, BindableType {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var playWithCreditBtn: UIButton!
    @IBOutlet weak var freePlayBtn: UIButton!
    @IBOutlet weak var coinLabel: UILabel!
    let disposeBag = DisposeBag()
    
    var viewModel: GamePopViewModeling!
    
    
    
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
        
        viewModel.image
            .bind(to: gameImageView.rx.image)
            .disposed(by: disposeBag)
        
//        freePlayBtn.rx.tap
//            .debounce(0.2, scheduler: MainScheduler.instance)
//            .withLatestFrom(viewModel.game)
//            .subscribe( onNext:{ [weak self]  game  in
//                guard let `self` = self else { return }
//                self.step.accept(AppStep.playGame(game:game))
//            }).disposed(by: disposeBag)
        
        freePlayBtn.rx.tap
           .debounce(0.2, scheduler: MainScheduler.instance)
           .subscribe {[weak self] _  in
            guard let `self` = self else { return }
            self.viewModel.loadRewardVideoAction.execute(self)
          }.disposed(by: disposeBag)
            
        viewModel.goToGameScreenWithFreePlay.subscribe(onNext: { [weak self] step  in
            guard let `self` = self else { return }
            self.step.accept(step)
        }).disposed(by: disposeBag)
            
        
        
        viewModel.isCreditAvailabel
            .subscribe(onNext: { [weak self] isAvailable in
             guard let `self` = self else { return }
             let title  = isAvailable ? "Play with 5 Credit" : "Buy Credit"
            self.playWithCreditBtn.setTitle(title, for: .normal)
        }).disposed(by: disposeBag)
        
        playWithCreditBtn.rx.tap
            .debounce(0.2, scheduler: MainScheduler.instance)
            .withLatestFrom(viewModel.appStep)
            .subscribe( onNext:{ [weak self]  step  in
                guard let `self` = self else { return }
                self.step.accept(step)
            }).disposed(by: disposeBag)

    }
}
