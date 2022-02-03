//
//  PageData.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

struct PageData: Codable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
    
    var hasNextPage: Bool {
        next != nil
    }
}

protocol PageResponse: Codable {
    var pageData: PageData { get }
}
