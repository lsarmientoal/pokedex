//
//  Observable+ObjectMapper.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 18/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

import Foundation
import Moya

extension Response {
    
    func mapObject<T: Decodable>(_ type: T.Type) throws -> T {
        guard let JSON = try mapJSON() as? [String : Any],
            let object = T(JSON: JSON) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
    
    func mapArray<T: Decodable>(_ type: T.Type) throws -> [T] {
        guard let JSON = try mapJSON() as? [[String : Any]],
            let array = [T](JSONArray: JSON) else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
