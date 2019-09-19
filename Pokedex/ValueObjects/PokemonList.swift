//
//  PokemonList.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 18/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

import Foundation

struct PokemonList {
    
    struct Result {
        let name: String
        let url: URL
    }
    
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [Result]
}

extension PokemonList: Decodable {}
extension PokemonList.Result: Decodable {}
