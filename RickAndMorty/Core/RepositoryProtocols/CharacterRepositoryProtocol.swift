//
//  CharacterRepositoryProtocol.swift
//  RickAndMorty
//
//  Created by Pouya on 11/12/1400 AP.
//

import Foundation

protocol CharacterRepositoryProtocol {
    func getCharactersFirstPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?)
    func getCharactersNextPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?)
    func getCharacter(_ id: Int, completionHandler: CompletionHandler<Result<CharacterResponse, NetworkError>>?)
}
