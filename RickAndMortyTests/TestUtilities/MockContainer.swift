//
//  MockContainer.swift
//  RickAndMortyTests
//
//  Created by Pouya on 6/3/1401 AP.
//

import Foundation
import Swinject
@testable import RickAndMorty

fileprivate class MockCharacterRepository: CharacterRepositoryProtocol {
    func getCharactersFirstPage() async throws -> CharacterListResponse {
        let data: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        return data
    }
    
    func getCharactersNextPage() async throws -> CharacterListResponse? {
        let data: CharacterListResponse = FileHelper.objectFromFile("Character-2")
        return data
    }
    
    func getCharactersFirstPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?) {
        let data: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        completionHandler?(.success(data))
    }
    
    func getCharactersNextPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?) {
        let data: CharacterListResponse = FileHelper.objectFromFile("Character-2")
        completionHandler?(.success(data))
    }
}

struct MockContainer: IoCContainer {
    var container: Container
    
    init() {
        let appContianer = AppContainer()
        appContianer.registerServices()
        
        self.container = .init(parent: appContianer.container)
        registerServices()
    }
    
    func registerServices() {
        container.register(CharacterRepositoryProtocol.self) { _ in
            MockCharacterRepository()
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        container.resolve(type)
    }
}
