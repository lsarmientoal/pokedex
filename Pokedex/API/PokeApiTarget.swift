//
//  PokeApiTarget.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 17/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

import Foundation
import Moya

enum PokeApiTarget {
    
    case listAllPokemons
    case pokemonInfo(id: Int)
}

extension PokeApiTarget: TargetType {
    
    var baseURL: URL { URL(string: "http://pokeapi.co")! }
    
    var path: String {
        switch self {
        case .listAllPokemons: return "/api/v2/pokemon"
        case .pokemonInfo(let id): return "/api/v2/pokemon/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .listAllPokemons, .pokemonInfo:
            return .get
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task { Task.requestPlain }
    
    var headers: [String : String]? { nil }
}
