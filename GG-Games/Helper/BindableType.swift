//
//  BindableType.swift
//  GG-Games
//
//  Created by Morshed Alam on 5/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import UIKit

protocol BindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
