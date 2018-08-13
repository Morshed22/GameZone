//
//  GameListTableViewCell.swift
//  GG-Games
//
//  Created by Morshed Alam on 23/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class GameListTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonOverImage: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gameImgView: UIImageView!
    @IBOutlet weak var favIconImgView: UIImageView!
    
     private var disposeBag: DisposeBag? = DisposeBag()
    
    
    var viewModel: GameListCellModeling? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else { return }
            
            nameLabel.text =  viewModel.gameTitle
            descriptionLabel.text = viewModel.category
            viewModel.image
                .bind(to: gameImgView.rx.image)
                .disposed(by: disposeBag)
           
            viewModel.favoriteIconValue
                .asObservable()
                .subscribe( onNext:{ [weak self] itemValue  in
                    self?.favIconImgView.image = itemValue == 0 ? #imageLiteral(resourceName: "star") : #imageLiteral(resourceName: "star1")
               }).disposed(by: disposeBag)
            
            buttonOverImage.rx.tap
                .debounce(0.2, scheduler: MainScheduler.instance)
                .subscribe( onNext:{  _  in
                   viewModel.favBtnClickListener.execute(())
                }).disposed(by: disposeBag)
            
            
            self.disposeBag = disposeBag
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        disposeBag = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
