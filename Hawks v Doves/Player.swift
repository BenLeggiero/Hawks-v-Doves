//
//  Player.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public enum PlayerKind {
    case hawk
    case dove
}



public typealias Player = PlayerKind



extension Player: CaseIterable {}
extension Player: RandomCaseInitializable {}



extension Player: CustomStringConvertible {
    public var description: String {
        switch self {
        case .dove: return "Dove"
        case .hawk: return "Hawk"
        }
    }
}



extension Array: ExpressibleByIntegerLiteral where Element: RandomCaseInitializable {
    public init(integerLiteral value: UInt) {
        self = (0..<value).map { _ in Element.randomCase() }
    }
}
