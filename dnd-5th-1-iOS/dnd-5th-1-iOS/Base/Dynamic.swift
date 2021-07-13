//
//  Dynamic.swift
//  dnd-5th-1-iOS
//
//  Created by taeuk on 2021/07/12.
//

import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ varible: T) {
        value = varible
    }
}
