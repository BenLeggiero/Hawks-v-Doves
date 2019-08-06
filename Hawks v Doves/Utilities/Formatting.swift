//
//  Formatting.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



typealias Formatter<Input> = (Input) -> String



extension BinaryFloatingPoint {
    func formatted(with formatter: Formatter<Self>) -> String {
        return formatter(self)
    }
    
    
    func formatted(with formatter: Foundation.Formatter) -> String {
        return formatter.string(for: self) ?? "\(self)"
    }
    
    
    func percentFormatted(maxFractionDigits: UInt8 = 1) -> String {
        return "\((self * 100).formatted(with: NumberFormatter.simpleFormatter(maxFractionDigits: maxFractionDigits)))%"
    }
}



extension NumberFormatter {
    static func simpleFormatter(maxFractionDigits: UInt8) -> NumberFormatter {
        let percentFormatter = NumberFormatter()
        percentFormatter.maximumFractionDigits = Int(maxFractionDigits)
        return percentFormatter
    }
}



extension String {
    func prefixingEachLine(with linePrefix: String) -> String {
        return linePrefix + self.replacingOccurrences(of: "\n", with: "\n\(linePrefix)")
    }
}
