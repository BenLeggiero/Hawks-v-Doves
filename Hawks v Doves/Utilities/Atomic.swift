//
//  Atomic.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



@propertyWrapper
public struct Atomic<WrappedValue> {
    
    private var exclusiveQueue = DispatchQueue(label: "Exclusive atomic accessor \(UUID())", qos: .userInteractive)
    
    private var unsafelyWrappedValue: WrappedValue
    
    public var wrappedValue: WrappedValue {
        get {
            return exclusiveQueue.sync {
                return unsafelyWrappedValue
            }
        }
        set {
            exclusiveQueue.sync {
                unsafelyWrappedValue = newValue
            }
        }
    }
    
    
    public init(wrappedValue: WrappedValue) {
        self.unsafelyWrappedValue = wrappedValue
    }
}
