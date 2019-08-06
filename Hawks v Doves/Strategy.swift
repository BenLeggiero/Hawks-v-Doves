//
//  Strategy.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



enum InteractionResult {
    case willDie
    case mightSurvive(chance: CGFloat)
    case willSurvive
    case mightReproduce(chance: CGFloat)
    case willReproduce
}



protocol Strategy: CustomStringConvertible {
    func perform(against player: Player, at location: Location) -> InteractionResult
    func perform(against players: Players, at location: Location) -> PlayersInteractionResult
    
    typealias Players = (a: Player, b: Player)
    typealias PlayersInteractionResult = (a: InteractionResult, b: InteractionResult)
}



extension InteractionResult {
    func apply(to player: Player) -> [Player] {
        switch self {
        case .willDie:
            return []
            
        case .willSurvive:
            return [player]
            
        case .willReproduce:
            return [player, player]
            
        case .mightSurvive(let chance):
            let willSurvive = chance.roll()
            return willSurvive ? [player] : []
            
        case .mightReproduce(let chance):
            let willReproduce = chance.roll()
            return willReproduce ? [player, player] : [player]
        }
    }
}



extension Strategy {
    func outcomeOfStrategy(against player: Player, at location: Location) -> [Player] {
        return self.perform(against: player, at: location).apply(to: player)
    }
    
    
    func outcomeOfStrategy(against players: Players, at location: Location) -> [Player] {
        let resultOfStrategy = self.perform(against: players, at: location)
        return resultOfStrategy.a.apply(to: players.a) + resultOfStrategy.b.apply(to: players.b)
    }
}



extension BinaryFloatingPoint where Self.RawSignificand : FixedWidthInteger {
    func roll(possibilitySpace: ClosedRange<Self> = 0...1) -> Bool {
        return self < Self.random(in: possibilitySpace)
    }
}
