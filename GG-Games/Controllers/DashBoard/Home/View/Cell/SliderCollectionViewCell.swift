//
//  SliderCollectionViewCell.swift
//  GG-Games
//
//  Created by Morshed Alam on 18/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SliderCollectionViewCell: UICollectionViewCell {
    
    private var disposeBag: DisposeBag? = DisposeBag()
    
    @IBOutlet weak var SliderImgView: UIImageView!
    
    var viewModel: SliderCellModeling? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else { return }
            
            viewModel.image
                .bind(to: SliderImgView.rx.image)
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
