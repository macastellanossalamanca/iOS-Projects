//
//  Observable.swift
//  2FA iOS App
//
//  Created by Miguel Angel Castellanos Salamanca on 26/10/22.
//

import Foundation

class Observable<T> {
    
    var value : T? {
        didSet {
            listener?(value)
            print("info has changed")
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
