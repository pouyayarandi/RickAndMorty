//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

enum CharacterURLProvider: URLProvider {
    case firstPage
    case character(_ id: Int)
    
    var path: String {
        switch self {
        case .firstPage:
            return String(format: "%@/character", baseURL)
        case .character(let id):
            return String(format: "%@/character/%d", baseURL, id)
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
    
    var nextPageRequest: NetworkRequestModel? {
        guard let path = lastPageInfo?.next else { return nil }
        return .init(url: path)
    }
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func getCharactersFirstPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?) {
        getFirstPage(completionHandler: completionHandler)
    }
    
    func getCharactersNextPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?) {
        getNextPage(completionHandler: completionHandler)
    }
    
    func getCharacter(_ id: Int, completionHandler: CompletionHandler<Result<CharacterResponse, NetworkError>>?) {
        network.request(.init(url: CharacterURLProvider.character(id).path)) { (result: Result<CharacterResponse, NetworkError>) in
            completionHandler?(result)
        }
    }
}
