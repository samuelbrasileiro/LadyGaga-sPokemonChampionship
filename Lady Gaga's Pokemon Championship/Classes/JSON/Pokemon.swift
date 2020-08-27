//
//  Pokemon.swift
//  Lady Gaga's Pokemon Championship
//
//  Created by Samuel Brasileiro on 27/08/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import Foundation

// MARK: - Pokemon
class Pokemon: Codable {
    let abilities: [Ability]?
    let baseExperience: Int?
    let forms: [Species]?
    let height: Int?
    let locationAreaEncounters: String?
    let name: String?
    let order: Int?
    let species: Species?
    let sprites: Sprites?
    let stats: [Stat]?
    let types: [TypeElement]?
    let weight: Int?

    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case forms, height
        case locationAreaEncounters = "location_area_encounters"
        case name, order, species, sprites,stats, types, weight
    }

    init(abilities: [Ability]?, baseExperience: Int?, forms: [Species]?, height: Int?, locationAreaEncounters: String?, name: String?, order: Int?, species: Species?, sprites: Sprites?, stats: [Stat]?, types: [TypeElement]?, weight: Int?) {
        self.abilities = abilities
        self.baseExperience = baseExperience
        self.forms = forms
        self.height = height
        self.locationAreaEncounters = locationAreaEncounters
        self.name = name
        self.order = order
        self.species = species
        self.sprites = sprites
        self.stats = stats
        self.types = types
        self.weight = weight
    }
}

// MARK: - Ability
class Ability: Codable {
    let ability: Species?
    let isHidden: Bool?
    let slot: Int?

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }

    init(ability: Species?, isHidden: Bool?, slot: Int?) {
        self.ability = ability
        self.isHidden = isHidden
        self.slot = slot
    }
}

// MARK: - Species
class Species: Codable {
    let name: String?
    let url: String?

    init(name: String?, url: String?) {
        self.name = name
        self.url = url
    }
}



// MARK: - VersionDetail
class VersionDetail: Codable {
    let rarity: Int?
    let version: Species?

    init(rarity: Int?, version: Species?) {
        self.rarity = rarity
        self.version = version
    }
}


// MARK: - Sprites
class Sprites: Codable {
    let backDefault: String?
    let frontDefault: String?
    let animated: Sprites?

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case frontDefault = "front_default"
        case animated
    }

    init(backDefault: String?, frontDefault: String?, animated: Sprites?) {
        self.backDefault = backDefault
        self.frontDefault = frontDefault
        self.animated = animated
    }
}


// MARK: - Stat
class Stat: Codable {
    let baseStat, effort: Int?
    let stat: Species?

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }

    init(baseStat: Int?, effort: Int?, stat: Species?) {
        self.baseStat = baseStat
        self.effort = effort
        self.stat = stat
    }
}

// MARK: - TypeElement
class TypeElement: Codable {
    let slot: Int?
    let type: Species?

    init(slot: Int?, type: Species?) {
        self.slot = slot
        self.type = type
    }
}

