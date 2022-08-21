//
//  CharacterRepositoryProtocol.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

protocol CharacterRepositoryProtocol {
    @available(*, deprecated, message: "Use async method instead")
    func getCharactersFirstPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?)
    func getCharactersFirstPage() async throws -> CharacterListResponse
    @available(*, deprecated, message: "Use async method instead")
    func getCharactersNextPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?)
    func getCharactersNextPage() async throws -> CharacterListResponse?
    func getCharacter(_ id: Int, completionHandler: CompletionHandler<Result<CharacterResponse, NetworkError>>?)
}
