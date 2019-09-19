//
//  StubsService.swift
//  PokedexTests
//
//  Created by Laura Sarmiento on 17/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

@testable import Pokedex
import Foundation
import OHHTTPStubs
import Moya

enum ResponseType {
    case succeeded, serverError, notFound, unauthorized
    
    var statusCode: Int32 {
        switch self {
        case .succeeded: return 200
        case .serverError: return 500
        case .notFound: return 404
        case .unauthorized: return 401
        }
    }
}

class StubsService {
    
    static func mock(forTarget target: TargetType, responseType: ResponseType) {
        print("\(target)_\(responseType)")
        stub(condition: isHost(target.baseURL.host!) && isPath(target.path)) { (request: URLRequest) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(
                fileAtPath: OHPathForFile("\(target.caseName)_\(responseType).json", StubsService.self)!,
                statusCode: responseType.statusCode,
                headers: ["Content-Type":"application/json"]
            )
        }
    }
}

extension TargetType {
    
    var caseName: String {
        return Mirror(reflecting: self).children.first?.label ?? "\(self)"
    }
}
