//
//  PokemonList.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 27/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import Foundation

// MARK: - PokemonList
class PokemonList: Codable {
    let count: Int?
    let next, previous: String?
    let results: [Result]?

    init(count: Int?, next: String?, previous: String?, results: [Result]?) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

