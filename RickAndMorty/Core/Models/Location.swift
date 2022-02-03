//
//  Location.swift
//  RickAndMorty
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation

struct LocationListResponse: Codable {
    var info: PageData
    var results: [LocationResponse]
}

extension LocationListResponse: PageResponse {
    var pageData: PageData { info }
}

struct LocationResponse: Codable {
    var id: Int
    var name: String
    var type: String
    var dimension: String
}
