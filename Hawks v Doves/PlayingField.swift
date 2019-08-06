//
//  PlayingField.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



struct PlayingField {
    var population: [Player]
    let locations: [Location]
    
    init(population: [Player], locations: [Location]) {
        self.population = population
        self.locations = locations
    }
}



extension PlayingField: CustomStringConvertible {
    var description: String {
        return """
        Population: \(population.breakdown)
        Food locations: \(locations.count)
        """
    }
}



struct PopulatedPlayingField {
    
    let populatedLocations: PopulatedLocations
    
    
    
    typealias PopulatedLocations = [PopulatedLocation]
    typealias PopulatedLocation = (location: Location, players: Players)
    typealias Players = (a: Player, b: Player?)
}



extension Collection where Element == Player {
    var breakdown: PlayerCollectionBreakdown {
        return PlayerCollectionBreakdown(self)
    }
}



struct PlayerCollectionBreakdown {
    let totalPopulationCount: UInt
    let stats: [PlayerKind : Statistic]
    
    init<Players>(_ players: Players)
        where Players: Collection,
            Players.Element == Player
    {
        let totalNumberOfPlayers = CGFloat(players.count)
        let kindsAndStats = Player.allCases.map { playerKind -> (PlayerKind, Statistic) in
            let count = UInt(players.filter { $0 == playerKind }.count)
            return (playerKind,
                    (count: count,
                     proportion: CGFloat(count) / totalNumberOfPlayers)
            )
        }
        
        self.totalPopulationCount = UInt(players.count)
        self.stats = Dictionary(uniqueKeysWithValues: kindsAndStats)
    }
    
    
    typealias Statistic = (count: UInt, proportion: CGFloat)
}



extension PlayerCollectionBreakdown: CustomStringConvertible {
    var description: String {
        return totalPopulationCount.description +
            stats
            .map { key, value in "\n\t\(key): \(value.count) (\(value.proportion.percentFormatted()))" }
            .joined()
    }
}
