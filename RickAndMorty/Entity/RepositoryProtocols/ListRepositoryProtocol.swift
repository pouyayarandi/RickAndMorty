//
//  ListRepositoryProtocol.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

protocol ListRepositoryProtocol: AnyObject {
    associatedtype Response: PageResponse
    
    var network: NetworkProtocol { get }
    var lastPageInfo: PageData? { get set }
    
    var firstPageRequest: NetworkRequestModel { get }
    var nextPageRequest: NetworkRequestModel? { get }
}

extension ListRepositoryProtocol {
    var hasNextPage: Bool {
        lastPageInfo?.hasNextPage ?? false
    }
    
    func getFirstPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?) {
        network.request(firstPageRequest) { [weak self] (result: Result<CharacterListResponse, NetworkError>) in
            if case .success(let response) = result {
                self?.lastPageInfo = response.pageData
            }
            completionHandler?(result)
        }
    }
    
    func getNextPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?) {
        guard let nextPageRequest = nextPageRequest else { return }
        network.request(nextPageRequest) { [weak self] (result: Result<CharacterListResponse, NetworkError>) in
            if case .success(let response) = result {
                self?.lastPageInfo = response.pageData
            }
            completionHandler?(result)
        }
    }
    
    func resetPage() {
        lastPageInfo = nil
    }
}
