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
    var nextPageRequest: NetworkRequestModel? {
        guard let path = lastPageInfo?.next else { return nil }
        return .init(url: path)
    }
    
    var hasNextPage: Bool {
        lastPageInfo?.hasNextPage ?? false
    }
    
    func getFirstPage() async throws -> Response {
        let response: Response = try await network.request(firstPageRequest)
        lastPageInfo = response.pageData
        return response
    }
    
    func getNextPage() async throws -> Response? {
        guard hasNextPage, let nextPageRequest = nextPageRequest else { return nil }
        let response: Response = try await network.request(nextPageRequest)
        lastPageInfo = response.pageData
        return response
    }
    
    @available(*, deprecated, message: "Use async method instead")
    func getFirstPage(completionHandler: CompletionHandler<Result<Response, NetworkError>>?) {
        network.request(firstPageRequest) { [weak self] (result: Result<Response, NetworkError>) in
            if case .success(let response) = result {
                self?.lastPageInfo = response.pageData
            }
            completionHandler?(result)
        }
    }
    
    @available(*, deprecated, message: "Use async method instead")
    func getNextPage(completionHandler: CompletionHandler<Result<Response, NetworkError>>?) {
        guard hasNextPage, let nextPageRequest = nextPageRequest else { return }
        network.request(nextPageRequest) { [weak self] (result: Result<Response, NetworkError>) in
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
