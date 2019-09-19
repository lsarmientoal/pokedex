//
//  Codable+Utils.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 18/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

import Foundation

extension Decodable {
    
    init?(JSON: [String: Any]) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = try? JSONSerialization.data(withJSONObject: JSON, options: .prettyPrinted),
            let object = try? decoder.decode(Self.self, from: data) else { return nil}
        self = object
    }

    init?(JSONObject: Any?) {
        guard let JSON = JSONObject as? [String: Any],
            let object = Self.init(JSON: JSON) else { return nil}
        self = object
    }
    
    init?(JSONString: String) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = JSONString.data(using: .utf8),
            let object = try? decoder.decode(Self.self, from: data) else { return nil}
        self = object
    }
}

extension Encodable {
    
    func toJSON() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return [:] }
        return json
    }
    
    func toJSONString(prettyPrint: Bool = false) -> String? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        var ouputFormatting: [JSONEncoder.OutputFormatting] = []
        if prettyPrint {
            ouputFormatting.append(.prettyPrinted)
        }
        if #available(iOS 13.0, *) {
            ouputFormatting.append(.withoutEscapingSlashes)
        }
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Array where Element: Decodable {
    
    init?(JSONArray array: [[String: Any]]) {
        self = array.compactMap {  Element.init(JSON: $0) }
    }
}
