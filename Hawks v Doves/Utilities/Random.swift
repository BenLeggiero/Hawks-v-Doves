//
//  Random.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



extension RandomAccessCollection
    where Index: FixedWidthInteger,
        Self: RangeReplaceableCollection
{
    mutating func removeRandom() -> Element? {
        var generator: RandomNumberGenerator = SystemRandomNumberGenerator()
        return removeRandom(using: &generator)
    }
    
    
    mutating func removeRandom(using generator: inout RandomNumberGenerator) -> Element? {
        guard let randomIndex = self.randomIndex(using: &generator) else {
            return nil
        }
        return self.remove(at: randomIndex)
    }
    
    
    func randomIndex(using generator: inout RandomNumberGenerator) -> Index? {
        return isEmpty
            ? nil
            : Index.init(generator.next(upperBound: UInt(endIndex - startIndex)) + UInt(startIndex))
    }
}
