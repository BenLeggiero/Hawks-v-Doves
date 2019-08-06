//
//  Simulator.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



class Simulator {
    private(set) var playingField: PlayingField
    let strategy: Strategy
    private(set) var totalNumberOfEpochsSimulatedSoFar = 0
    
    private let uuid = UUID()
    private let lockingQueue: DispatchQueue
    
    init(playingField: PlayingField, strategy: Strategy) {
        self.playingField = playingField
        self.strategy = strategy
        self.lockingQueue = DispatchQueue(label: "Simulator \(uuid)")
    }
}



extension Simulator {
    typealias SimulationResult = Simulator
    typealias SimulationCallback = (_ result: SimulationResult) -> Void
}



extension Simulator {
    func step(callback: @escaping SimulationCallback) {
        lockingQueue.async {
//            var remainingLocationsThisEpoch = self.playingField.locations
//            let thisEpochStartingPopulation = self.playingField.population
//            var remainingPopulationToSimulate = thisEpochStartingPopulation
            var nextPopulation = [Player]()
            let thisEpochNumber = self.totalNumberOfEpochsSimulatedSoFar + 1
            
            
            DispatchQueue(label: "Simulation step \(thisEpochNumber)", qos: .userInteractive).async {
                nextPopulation = self.populatedPlayingField().populatedLocations.flatMap { populatedLocation -> [Player] in
                    let location = populatedLocation.location
                    let playerA = populatedLocation.players.a
                    if let playerB = populatedLocation.players.b {
                        return self.strategy.outcomeOfStrategy(against: (a: playerA, b: playerB), at: location)
                    }
                    else {
                        return self.strategy.outcomeOfStrategy(against: playerA, at: location)
                    }
                }
                
                self.lockingQueue.async {
                    self.playingField.population = nextPopulation
                    callback(self)
                }
            }
            
            self.totalNumberOfEpochsSimulatedSoFar = thisEpochNumber
        }
    }
}



private extension Simulator {
    func populatedPlayingField() -> PopulatedPlayingField {
        
        let shouldPitTwoPlayersAgainstEachOther = Bool.random
        
        let allLocations = self.playingField.locations
        var remainingPlayers = self.playingField.population
        
        let populatedLocations = allLocations.compactMap { location -> PopulatedLocation? in
            if let randomlySelectedPlayerA = remainingPlayers.removeRandom() {
                return PopulatedLocation(
                    location: location,
                    players:
                    (a: randomlySelectedPlayerA,
                     b: shouldPitTwoPlayersAgainstEachOther()
                        ? remainingPlayers.removeRandom()
                        : nil)
                )
            }
            else {
                return nil
            }
        }
        
        return PopulatedPlayingField(populatedLocations: populatedLocations)
    }
    
    
    
    typealias PopulatedLocation = PopulatedPlayingField.PopulatedLocation
}



extension Simulator {
    func runSimulation(numberOfEpochs: UInt, callback: @escaping SimulationCallback) {
        
        var remainingEpochCount = Atomic(wrappedValue: numberOfEpochs)
        
        
        func done() {
            callback(self)
        }
        
        
        func summarize(_ result: SimulationResult) {
            let epoch = result.totalNumberOfEpochsSimulatedSoFar
            let playingField = result.playingField
            let populationBreakdown = playingField.population.breakdown
            let doves = populationBreakdown.stats[.dove]!
            let hawks = populationBreakdown.stats[.hawk]!
            
            print("\(epoch),\(doves.count),\(hawks.count),\(populationBreakdown.totalPopulationCount)")
        }
        
        
        func go() {
            step { result in
                summarize(result)
                remainingEpochCount.wrappedValue -= 1
                
                if remainingEpochCount.wrappedValue > 0,
                    !self.playingField.population.isEmpty {
                    go()
                }
                else {
                    done()
                }
            }
        }
        
        print("Epoch,Doves,Hawks,Total")
        
        go()
    }
}



extension Simulator: CustomStringConvertible {
    var description: String {
        return """
        
        
        Simulation
        ==========
        
        Ran for \(totalNumberOfEpochsSimulatedSoFar) epoch\(totalNumberOfEpochsSimulatedSoFar == 1 ? "" : "s")
        
        
        Strategy
        --------
        \(strategy)
        
        
        Playing Field
        -------------
        \(playingField)
        
        """
    }
}
