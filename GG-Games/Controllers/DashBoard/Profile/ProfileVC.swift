//
//  ProfileVC.swift
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

class ProfileVC: UIViewController,StoryboardSceneBased, Stepper, BindableType {
    
 static let sceneStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    
    @IBOutlet weak var recentGameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favouriteHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var userEditBtn: UIButton!
    
    @IBOutlet weak var userGmailLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    
    @IBOutlet weak var totalCoinsLabel: UILabel!
    
    @IBOutlet weak var totalPlayedLabel: UILabel!
 
    
    @IBOutlet weak var favouriteEditBtn: UIButton!
    
    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    
    @IBOutlet weak var recentGamesCollectionView: UICollectionView!
    var viewModel: ProfileViewModeling!
    let disposeBag = DisposeBag()
    
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
        
        viewModel.userData.subscribe(onNext: { [weak self] user in
            guard let `self` = self else { return }
            self.userGmailLabel.text = user.email ?? ""
            self.userNameLabel.text = user.userName
            self.totalCoinsLabel.text = String(user.totalCoin)
            self.totalPlayedLabel.text = String(user.totoalPlayed)
        }).disposed(by:disposeBag)
        
        
        let favouriteDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, FavoriteGameCellModel>>(configureCell: {
            dataSource, collectionView, indexPath, cellModel in
            let cell = collectionView.dequeueReusableCell(for: indexPath) as FavouriteGameCell
            cell.viewModel = cellModel
            return cell
        })
        
        viewModel.favoriteGames
            .do(onNext: { [weak self] items in
                guard let `self` = self else { return }
                self.favouriteHeightConstraints.constant = items.count == 0 ? 0: 128
            })
            .map{[SectionModel(model: "FavouriteItems", items: $0)]}
            .bind(to: favouriteCollectionView.rx.items(dataSource: favouriteDataSource))
            .disposed(by: disposeBag)
        
        let recenGameDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, RecentGameCellModel>>(configureCell: {
            dataSource, collectionView, indexPath, cellModel in
            let cell = collectionView.dequeueReusableCell(for: indexPath) as RecentGameCell
            cell.viewModel = cellModel
            return cell
        })
        
        viewModel.recentGames
            .do(onNext: { [weak self] items in
                guard let `self` = self else { return }
                self.recentGameHeightConstraint.constant = items.count == 0 ? 0: 128
            })
            .map{[SectionModel(model: "RecentItems", items: $0)]}
            .bind(to: recentGamesCollectionView.rx.items(dataSource: recenGameDataSource))
            .disposed(by: disposeBag)

    }
    
    
    

}
