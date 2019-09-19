//
//  ObserverType+ObjectMapper.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 18/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension ObservableType where Element == Response {
    
    func mapObject<T: Decodable>(_ type: T.Type) -> Observable<T> {
        flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(type))
        }
    }
    
    func mapArray<T: Decodable>(_ type: T.Type) -> Observable<[T]> {
        flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(type))
        }
    }
}
