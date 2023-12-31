//
//  NetworkLogger.swift
//  RXMVVMC
//
//  Created by Vitalii Shkliar on 06.11.2019.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import os.log

///Logs the network requests and responses
struct NetworkLogger {
    static func log(request: URLRequest) {
        var data: String {
            guard let data = request.httpBody else {  return "--" }
            return String(data: data, encoding: .utf8) ?? ""
        }
        let logString = "\(request.url?.absoluteString ?? "--")\nheaders:\(request.allHTTPHeaderFields ?? [:])\ndata:\(data)"
        os_log("Request: %{PUBLIC}@", log: .network, type: .info, logString)
    }
    
    static func log(response: URLResponse?, data: Data?) {
        guard let httpURLResponse = response as? HTTPURLResponse else { return }
        os_log("Status Code: %{PUBLIC}d", log: .network, type: .info, httpURLResponse.statusCode)
        if let data = data {
            NetworkLogger.log(responseData: data)
        }
    }
    
    static private func log(responseData data: Data) {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
            os_log("Response json: %{PUBLIC}@", log: .network, type: .info, json)
        } catch {
            os_log("RESPONSE DATA CANNOT BE CONVERTED TO JSON", log: .network, type: .info)
        }
    }
}
