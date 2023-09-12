//
//  Observable.swift
//  CoffeePensieve
//
//  Created by Eunji Hwang on 2023/09/11.
//

import Foundation

class Observable<T> {
        
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }
    
    func addObserver(callback: @escaping (T)->Void) {
        self.observer = callback
    }
}
