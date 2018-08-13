//
//  HomeVC.swift
//  GG-Games
//
//  Created by Morshed Alam on 3/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa
import RxDataSources

class HomeVC: UIViewController, StoryboardSceneBased, Stepper, BindableType{

    static let sceneStoryboard = UIStoryboard(name: "Home", bundle: nil)
    
    @IBOutlet weak var categoryImg: UIImageView!
    @IBOutlet weak var cateGoryName: UILabel!
    @IBOutlet weak var categoryIconBtn: UIButton!
    @IBOutlet weak var totalCoinLabel: UILabel!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var gameListTableView: UITableView!
    
    var viewModel: HomeViewModeling!
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    var x = 1
    var containerView:UIView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameListTableView.estimatedRowHeight = UITableViewAutomaticDimension
        gameListTableView.rowHeight = deviceHeight*0.1
        containerView = UIView(frame: self.view.bounds)
        containerView.isHidden = true
        view.addSubview(containerView)
        configureView()
    }

    func configureView(){
       categoryIconBtn.rx.tap
           .debounce(0.1, scheduler: MainScheduler.instance)
           .subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.step.accept(AppStep.gameCategory)
           }.disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindViewModel() {
        
        viewModel.sliderCell.drive(sliderCollectionView.rx.items(cellIdentifier: "SliderCollectionViewCell", cellType: SliderCollectionViewCell.self)){ i, cellModel, cell in
            cell.viewModel = cellModel
            cell.tag = i
            }.disposed(by: disposeBag)
        
        viewModel.gameListCell.drive(gameListTableView.rx.items(cellIdentifier: "GameListTableViewCell", cellType: GameListTableViewCell.self)){ i, cellModel, cell in
            cell.viewModel = cellModel
            }.disposed(by: disposeBag)
        
        
        viewModel.isLoading
            .drive(isLoading(for:self.view))
            .disposed(by: disposeBag)
        
        viewModel.timer.subscribe {[weak self] _ in
            guard let `self` = self else { return }
            self.autoSilde()
            }.disposed(by: disposeBag)
        
        viewModel.isContainerHidden
            .asObservable().subscribe(onNext: { [weak self]isHidden in
                guard let `self` = self else { return }
                self.animateContainer(isHidden: isHidden)
            }).disposed(by: disposeBag)
        
        viewModel.categoryItem.asObservable().subscribe(onNext: { [weak self] category  in
            guard let `self` = self else { return }
            self.cateGoryName.text = category.title
            self.categoryImg.image = category.image
        }).disposed(by: disposeBag)
        
        Observable.of(UserData().user)
            .filter{$0 != nil}
            . map{$0!}
            .subscribe(onNext: {[weak self] user in
                guard let `self` = self else { return }
                self.totalCoinLabel.text = String(user.totalCoin)
            }).disposed(by: disposeBag)

        gameListTableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.cellDidSelect)
            .disposed(by: disposeBag)
        
        
        viewModel.presentGame.subscribe(onNext: { [weak self] game in
            guard let `self` = self else { return }
            self.step.accept(AppStep.popUPinGameList(game: game))
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
    
    
    private func animateContainer(isHidden:Bool){
        if isHidden {
            UIView.animate(withDuration: 0.1, animations: {
                self.containerView.backgroundColor = .clear
            }) {[weak self] _ in
                self?.containerView.isHidden = isHidden
            }
        }else{
            containerView.isHidden = isHidden
            UIView.animate(withDuration: 0.1, animations: {
                self.containerView.backgroundColor = .lightGray
            })
        }

    }
    
    private func autoSilde(){
        let itemsCount = self.sliderCollectionView.numberOfItems(inSection: 0)
        if self.x < itemsCount{
            let indexPath = IndexPath(item: self.x, section: 0)
            self.sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.x = self.x + 1
        } else {
            guard itemsCount > 0 else {
                return
            }
            self.x = 0
            self.sliderCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
        }
    }

}
