//
//  GlobalFunc.swift
//  GG-Games
//
//  Created by Morshed Alam on 9/7/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import RxSwift
import RxCocoa
import SVProgressHUD

func isLoading(for view: UIView) -> AnyObserver<Bool> {
    
    return Binder(view, binding: { (hud, isLoading) in
        switch isLoading {
        case true:
            SVProgressHUD.show()
        case false:
            SVProgressHUD.dismiss()
            break
        }
    }).asObserver()
}
