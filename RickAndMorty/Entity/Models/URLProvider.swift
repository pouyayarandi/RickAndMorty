//
//  URLProvider.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

protocol URLProvider {
    var path: String { get }
}

extension URLProvider {
    var baseURL: String {
        "https://rickandmortyapi.com/api"
    }
}
