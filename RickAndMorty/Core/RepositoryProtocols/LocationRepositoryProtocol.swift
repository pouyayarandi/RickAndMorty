//
//  LocationRepositoryProtocol.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation

protocol LocationRepositoryProtocol {
    func getLocationsFirstPage(completionHandler: CompletionHandler<Result<LocationListResponse, NetworkError>>?)
    func getLocationsNextPage(completionHandler: CompletionHandler<Result<LocationListResponse, NetworkError>>?)
}
