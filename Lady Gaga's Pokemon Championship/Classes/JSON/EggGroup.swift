//
//  EggGroup.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 27/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import Foundation

// MARK: - EggGroup

class EggGroup: Codable {
    let id: Int?
    let name: String?
    let names: [Name]?
    let pokemonSpecies: [PokemonSpecy]?

    enum CodingKeys: String, CodingKey {
        case id, name, names
        case pokemonSpecies = "pokemon_species"
    }

    init(id: Int?, name: String?, names: [Name]?, pokemonSpecies: [PokemonSpecy]?) {
        self.id = id
        self.name = name
        self.names = names
        self.pokemonSpecies = pokemonSpecies
    }
}

// MARK: - Name
class Name: Codable {
    let language: PokemonSpecy?
    let name: String?

    init(language: PokemonSpecy?, name: String?) {
        self.language = language
        self.name = name
    }
}

// MARK: - PokemonSpecy
class PokemonSpecy: Codable {
    let name: String?
    let url: String?

    init(name: String?, url: String?) {
        self.name = name
        self.url = url
    }
}
