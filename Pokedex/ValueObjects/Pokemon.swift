//
//  Pokemon.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 17/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

import Foundation
import RxDataSources

struct Pokemon {
    
    let id: Int
    let name: String
    let image: URL?
    let types: [String]
    
    struct PokemonType {
        let name: String
    }
}

extension Pokemon: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id, name, sprites, types
    }
    
    enum SpriteCodingKeys: String, CodingKey {
        case frontDefault
    }
    
    enum TypesCodingKeys: String, CodingKey {
        case type
    }
    
    enum TypeNamedCodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let types = try container.decode([PokemonType].self, forKey: .types)
        self.types = types.map { $0.name }
        
        let spriteContainer = try container.nestedContainer(keyedBy: SpriteCodingKeys.self, forKey: .sprites)
        image = try spriteContainer.decode(URL.self, forKey: .frontDefault)
    }
}

extension Pokemon.PokemonType: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    enum TypeCodingKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeContainer = try container.nestedContainer(keyedBy: TypeCodingKeys.self, forKey: .type)
        name = try typeContainer.decode(String.self, forKey: .name)
    }
}

extension Pokemon: IdentifiableType, Equatable {
    
    var identity: Int {
        id.hashValue
    }
}
