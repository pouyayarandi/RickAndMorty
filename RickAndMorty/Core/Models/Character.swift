//
//  Character.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

struct CharacterListResponse: Codable {
    var info: PageData
    var results: [CharacterResponse]
}

extension CharacterListResponse: PageResponse {
    var pageData: PageData { info }
}

struct CharacterResponse: Codable, Hashable {
    enum Status: String, Codable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown
    }
    
    enum Gender: String, Codable {
        case female = "Female"
        case male = "Male"
        case genderless = "Genderless"
        case unknown
    }
    
    var id: Int
    var name: String
    var status: Status
    var type: String
    var gender: Gender
    var image: String?
}
