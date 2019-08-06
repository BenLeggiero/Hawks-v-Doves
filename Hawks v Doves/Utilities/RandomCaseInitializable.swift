//
//  RandomCaseInitializable.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public protocol RandomCaseInitializable {
    static func randomCase() -> Self
}



public extension RandomCaseInitializable where Self: CaseIterable {
    static func randomCase() -> Self {
        guard let randomCase = allCases.randomElement() else {
            preconditionFailure("all cases had no cases???")
        }
        return randomCase
    }
}
