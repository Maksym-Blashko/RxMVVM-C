//
//  NetworkRouter.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    @discardableResult
    func request<T: Decodable>(_ route: EndPoint, responseHandler: RemoteAPIResponseHandler?, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask?
    func cancel()
}
