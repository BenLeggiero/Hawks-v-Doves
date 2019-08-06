//
//  main.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation

let playingField = PlayingField(population: 20, locations: [Location](repeating: .food(amountOfFood: 2), count: 20))
//let playingField = PlayingField(population: .init(doves: 19, hawks: 1), locations: [Location](repeating: .food(amountOfFood: 2), count: 20))

let semaphoreThatKeepsTheProgramInMemoryWhileItRunsBackgroundThreads = DispatchSemaphore(value: 0)

let simulator = Simulator(playingField: playingField, strategy: BasicStrategy())
//let simulator = Simulator(playingField: playingField, strategy: PrisonersDilemma())

let startDate = Date()
simulator.runSimulation(numberOfEpochs: 500) { result in
    let endDate = Date()
    print(result)
    print("Simulation took", endDate.timeIntervalSince(startDate), "seconds")
    semaphoreThatKeepsTheProgramInMemoryWhileItRunsBackgroundThreads.signal()
}

semaphoreThatKeepsTheProgramInMemoryWhileItRunsBackgroundThreads.wait()
