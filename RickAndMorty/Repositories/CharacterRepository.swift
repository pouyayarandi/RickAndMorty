//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

enum CharacterURLProvider: URLProvider {
    case firstPage
    
    var path: String {
        switch self {
        case .firstPage:
            return String(format: "%@/character", baseURL)
        }
    }
}

class CharacterRepository: CharacterRepositoryProtocol, ListRepositoryProtocol {
    typealias Response = CharacterListResponse
    
    var network: NetworkProtocol
    var lastPageInfo: PageData?
    
    var firstPageRequest: NetworkRequestModel {
        .init(url: CharacterURLProvider.firstPage.path)
    }
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func getCharactersFirstPage() async throws -> CharacterListResponse {
        try await getFirstPage()
    }
    
    func getCharactersNextPage() async throws -> CharacterListResponse? {
        try await getNextPage()
    }
    
    func getCharactersFirstPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?) {
        getFirstPage(completionHandler: completionHandler)
    }
    
    func getCharactersNextPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?) {
        getNextPage(completionHandler: completionHandler)
    }
}
