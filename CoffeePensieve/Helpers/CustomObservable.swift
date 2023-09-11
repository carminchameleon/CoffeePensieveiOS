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
            observerCallback?(value)
        }
    }
    
    var observerCallback: ((T) -> Void)?

    
    init(_ value: T) {
        self.value = value
    }
    
    func subscribe(callback: @escaping (T)->Void) {
        self.observerCallback = callback
    }
}
