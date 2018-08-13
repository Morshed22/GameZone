//
//  Array+Extension.swift
//  GG-Games
//
//  Created by Morshed Alam on 12/8/18.
//  Copyright © 2018 Morshed. All rights reserved.
//

import Foundation
extension Array{
    
    mutating func appendAtFirst(newItem : Element){
        let copy = self
        self = []
        self.append(newItem)
        self.append(contentsOf: copy)
    }
    
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
    
}
