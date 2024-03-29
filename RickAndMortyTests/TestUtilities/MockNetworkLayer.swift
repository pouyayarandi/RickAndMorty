//
//  MockNetworkLayer.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation
@testable import RickAndMorty

class MockNetworkLayer: NetworkProtocol {
    func request<T>(_ requestModel: NetworkRequestModel) async throws -> T where T : Decodable {
        let result = mocks[requestModel]!
        switch result {
        case .success(let data):
            return data as! T
        case .failure(let error):
            throw error
        }
    }
    
    var mocks = [NetworkRequestModel: Result<Codable, NetworkError>]()
    func request<T>(_ requestModel: NetworkRequestModel, completionHandler: CompletionHandler<Result<T, NetworkError>>?) where T : Decodable {
        let result = mocks[requestModel]!
        switch result {
        case .success(let data):
            completionHandler?(.success(data as! T))
        case .failure(let error):
            completionHandler?(.failure(error))
        }
    }
}
