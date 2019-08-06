//
//  Prefabs.swift
//  Hawks v Doves
//
//  Created by Ben Leggiero on 8/5/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



extension Array where Element == Player {
    init(doves: UInt, hawks: UInt) {
        self =
            (0..<doves).map { _ in .dove } +
            (0..<hawks).map { _ in .hawk }
    }
}
