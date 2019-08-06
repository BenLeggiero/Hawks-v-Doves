//
//  BasicStrategy.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



struct BasicStrategy: Strategy {
    
    let description = "basic"
    
    func perform(against player: Player, at location: Location) -> InteractionResult {
        switch location {
        case .barren,
             .food(amountOfFood: 0):
            return .willDie
            
        case .food(amountOfFood: 1):
            switch player {
            case .dove,
                 .hawk:
                return .willSurvive
            }
            
        case .food(amountOfFood: _):
            switch player {
            case .dove,
                 .hawk:
                return .willReproduce
            }
        }
    }
    
    
    func perform(against players: Players, at location: Location) -> PlayersInteractionResult {
        switch location {
        case .barren,
             .food(amountOfFood: 0):
            return (a: .willDie, b: .willDie)

        case .food(amountOfFood: 1):
            switch players {
            case (a: .dove, b: .dove):
                return (a: .mightSurvive(chance: 0.5), b: .mightSurvive(chance: 0.5))
                
            case (a: .dove, b: .hawk):
                return (a: .mightSurvive(chance: 0.25), b: .mightSurvive(chance: 0.75))
                
            case (a: .hawk, b: .dove):
                return (a: .mightSurvive(chance: 0.75), b: .mightSurvive(chance: 0.25))
                
            case (a: .hawk, b: .hawk):
                return (a: .willDie, b: .willDie)
            }
            
        case .food(amountOfFood: _):
            switch players {
            case (a: .dove, b: .dove):
                return (a: .willSurvive, b: .willSurvive)
                
            case (a: .dove, b: .hawk):
                return (a: .mightSurvive(chance: 0.5), b: .mightReproduce(chance: 0.5))
                    
            case (a: .hawk, b: .dove):
                return (a: .mightReproduce(chance: 0.5), b: .mightSurvive(chance: 0.5))
                
            case (a: .hawk, b: .hawk):
                return (a: .willDie, b: .willDie)
            }
        }
    }
}

