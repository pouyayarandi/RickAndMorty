//
//  LocationRepository.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation

enum LocationURLProvider: URLProvider {
    case firstPage
    
    var path: String {
        switch self {
        case .firstPage:
            return String(format: "%@/location", baseURL)
        }
    }
}

class LocationRepository: LocationRepositoryProtocol, ListRepositoryProtocol {
    typealias Response = LocationListResponse
    
    var network: NetworkProtocol
    var lastPageInfo: PageData?
    
    var firstPageRequest: NetworkRequestModel {
        .init(url: LocationURLProvider.firstPage.path)
    }
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func getLocationsFirstPage(completionHandler: CompletionHandler<Result<LocationListResponse, NetworkError>>?) {
        getFirstPage(completionHandler: completionHandler)
    }
    
    func getLocationsNextPage(completionHandler: CompletionHandler<Result<LocationListResponse, NetworkError>>?) {
        getNextPage(completionHandler: completionHandler)
    }
}
