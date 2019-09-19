//
//  HttpServices.swift
//  Pokedex
//
//  Created by Laura Sarmiento on 17/09/19.
//  Copyright © 2019 Medrar. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire

protocol HttpServicesType {
    
    func request(to target: PokeApiTarget) -> Observable<Response>
    func request(toUrl url: URL) -> Observable<Response>
    func request(imageUrl url: URL) -> Observable<UIImage>
}

let provider = MoyaProvider<PokeApiTarget>()
private let queue = DispatchQueue(label: "com.medrar.ios.pokedex.api.http-services-queue")
private let imageCache = NSCache<AnyObject, UIImage>()

struct HttpServices: HttpServicesType {
    
    func request(toUrl url: URL) -> Observable<Response> {
        .create { (observer: AnyObserver<Response>) -> Disposable in
            AF.request(url).responseData { (response: AFDataResponse<Data>) in
                if let error = response.error {
                    observer.on(.error(error))
                } else if let data = response.data {
                    observer.on(.next(Response(
                        statusCode: response.response?.statusCode ?? 0,
                        data: data
                    )))
                } else {
                    observer.on(.error(RxError.noElements))
                }
            }
            return Disposables.create()
        }
    }
    
    func request(to target: PokeApiTarget) -> Observable<Response> {
        provider.rx.request(target)
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: queue))
            .observeOn(MainScheduler.instance)
            .asObservable()
    }
    
    func request(imageUrl url: URL) -> Observable<UIImage> {
        Observable<UIImage>.create { (observer: AnyObserver<UIImage>) -> Disposable in
            
            if let image = imageCache.object(forKey: url as AnyObject) {
                observer.on(.next(image))
                observer.on(.completed)
                return Disposables.create()
            }
            
            let configuration: URLSessionConfiguration = .default
            let session = URLSession(configuration: configuration)
            
            let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error {
                    observer.on(.error(error))
                    return
                }
                guard
                    (response?.mimeType ?? "").hasPrefix("image"),
                    let data = data,
                    let image = UIImage(data: data)
                    else {
                        observer.on(.error(RxError.noElements))
                        return
                    }
                
                imageCache.setObject(image, forKey: url as AnyObject)
                observer.on(.next(image))
                observer.on(.completed)
            })
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
        .observeOn(MainScheduler.instance)
    }
}
