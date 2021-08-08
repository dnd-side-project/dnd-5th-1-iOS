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
    
    var observers = [String: Listener]()
    
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
            self.notify()
        }
    }
    
    init(_ varible: T) {
        value = varible
    }
    
    // MARK: - Observer Method
    
    /// Method to add observer on datasource to update its data
    
    public func addObserver(_ observer: NSObject, completionHandler: @escaping Listener) {
        observers[observer.description] = completionHandler
    }
    
    /// Add and notify observer method update data and notify the listner
    
    public func addAndNotify(observer: NSObject, completionHandler: @escaping Listener) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    /// Method to notify datasource listner to update UI or perform required action
    
    private func notify() {
        observers.forEach({ $0.value(value) })
    }
    
    // MARK: - De-Initializer
    
    deinit {
        observers.removeAll()
    }
}
