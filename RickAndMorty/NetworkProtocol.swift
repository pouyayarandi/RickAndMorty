//
//  NetworkProtocol.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

struct NetworkRequestModel {
    enum Method: String {
        case get = "GET"
    }
    
    var url: String
    var method: Method = .get
    var query: [String: String] = [:]
    
    var request: URLRequest? {
        guard var components = URLComponents(string: url) else { return nil }
        components.queryItems = query.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

typealias CompletionHandler<T> = (T) -> Void

protocol NetworkProtocol {
    func request<T: Decodable>(_ requestModel: NetworkRequestModel, completionHandler: CompletionHandler<Result<T, Error>>?)
}
