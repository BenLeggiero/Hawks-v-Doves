//
//  Prisoners' Dilemma.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



struct PrisonersDilemma: Strategy {
    
    let description = "Prisoner's Dilemma"
    
    private let basis = BasicStrategy()
    
    func perform(against player: Player, at location: Location) -> InteractionResult {
        return basis.perform(against: player, at: location)
    }
    
    
    func perform(against players: Players, at location: Location) -> PlayersInteractionResult {
        switch location {
        case .barren,
             .food(amountOfFood: 0),
             .food(amountOfFood: 1):
            break
            
        case .food(amountOfFood: _):
            switch players {
            case (a: .hawk, b: .hawk):
                return (a: .mightSurvive(chance: 0.75), b: .mightSurvive(chance: 0.75))
                
            default:
                break
            }
        }
        
        return basis.perform(against: players, at: location)
    }
}
