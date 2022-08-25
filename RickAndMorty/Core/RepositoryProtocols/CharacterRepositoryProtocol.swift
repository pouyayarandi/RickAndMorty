//
//  CharacterRepositoryProtocol.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

protocol CharacterRepositoryProtocol {
    func getCharactersFirstPage() async throws -> CharacterListResponse
    func getCharactersNextPage() async throws -> CharacterListResponse?
}
