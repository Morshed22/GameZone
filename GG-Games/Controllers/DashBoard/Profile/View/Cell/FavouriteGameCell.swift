//
//  FavouriteGameCell.swift
//  GG-Games
//
//  Created by Morshed Alam on 31/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxSwift
import RxCocoa

class FavouriteGameCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    
    private var disposeBag: DisposeBag? = DisposeBag()
    
    
    var viewModel: FavoriteGameCellModel? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else { return }
            
            gameTitle.text = viewModel.gameTitle
           
            viewModel.image
                .bind(to: imageView.rx.image)
                .disposed(by: disposeBag)
            
            self.disposeBag = disposeBag
        }
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        disposeBag = nil
    }
}
