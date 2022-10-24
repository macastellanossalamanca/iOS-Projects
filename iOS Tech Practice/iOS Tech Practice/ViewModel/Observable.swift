//
//  Observable.swift
//  iOS Tech Practice
//
//  Created by Miguel Angel Castellanos Salamanca on 23/10/22.
//

import Foundation

class Observable<T> {
    
    var value : T? {
        didSet {
            listener?(value)
        }
    }
    private var listener: ((T?) -> Void)?
    
    init(value: T?) {
        self.value = value
    }
    
    func bind (_ listener: @escaping (T?) -> Void) {
        listener(value)
    }
}
