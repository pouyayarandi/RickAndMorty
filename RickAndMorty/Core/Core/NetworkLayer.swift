//
//  NetworkLayer.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

class NetworkLayer: NetworkProtocol {
    var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    enum NetworkLayerError: Error {
        case responseIsMissing
        case dataIsMissing
        case requestIsInvalid
    }
    
    func request<T>(_ requestModel: NetworkRequestModel) async throws -> T where T : Decodable {
        try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<T, Error>) in
            self.request(requestModel) { (result: Result<T, NetworkError>) in
                continuation.resume(with: result)
            }
        })
    }
    
    func request<T>(_ requestModel: NetworkRequestModel, completionHandler: CompletionHandler<Result<T, NetworkError>>?) where T : Decodable {
        guard let request = requestModel.request else {
            completionHandler?(.failure(.clientError(NetworkLayerError.requestIsInvalid)))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler?(.failure(.clientError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler?(.failure(.clientError(NetworkLayerError.responseIsMissing)))
                return
            }

            guard response.statusCode.isSuccessfulStatusCode else {
                completionHandler?(.failure(.httpError(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completionHandler?(.failure(.clientError(NetworkLayerError.dataIsMissing)))
                return
            }
            
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completionHandler?(.success(object))
            } catch {
                completionHandler?(.failure(.clientError(error)))
            }
        }.resume()
    }
}

private extension Int {
    var isSuccessfulStatusCode: Bool {
        200...299 ~= self
    }
}
