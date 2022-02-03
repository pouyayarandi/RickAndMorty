//
//  NetworkProtocol.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

struct NetworkRequestModel: Hashable, Equatable {
    enum Method: String {
        case get = "GET"
    }
    
    var url: String
    var method: Method = .get
    var query: [String: String] = [:]
    
    var request: URLRequest? {
        guard var components = URLComponents(string: url) else { return nil }
        let additionalQueries = query.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        if components.queryItems == nil {
            components.queryItems = additionalQueries
        } else {
            components.queryItems?.append(contentsOf: additionalQueries)
        }
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

enum NetworkError: Error {
    case httpError(_ statusCode: Int)
    case clientError(_ error: Error)
    
    var localizedDescription: String {
        switch self {
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode)"
        case .clientError(let error):
            return error.localizedDescription
        }
    }
}

typealias CompletionHandler<T> = (T) -> Void

protocol NetworkProtocol {
    func request<T: Decodable>(_ requestModel: NetworkRequestModel, completionHandler: CompletionHandler<Result<T, NetworkError>>?)
}
