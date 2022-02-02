//
//  CharacterListViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Pouya on 11/14/1400 AP.
//

import Foundation
@testable import RickAndMorty
import XCTest

fileprivate class MockCharacterRepository: CharacterRepositoryProtocol {
    func getCharactersFirstPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?) {
        let data: CharacterListResponse = FileHelper.objectFromFile("Character-1")
        completionHandler?(.success(data))
    }
    
    func getCharactersNextPage(completionHandler: CompletionHandler<Result<CharacterListResponse, NetworkError>>?) {
        let data: CharacterListResponse = FileHelper.objectFromFile("Character-2")
        completionHandler?(.success(data))
    }
    
    func getCharacter(_ id: Int, completionHandler: CompletionHandler<Result<CharacterResponse, NetworkError>>?) {}
}

class CharacterListViewModelTests: XCTestCase {
    var sut: CharacterListViewModelProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CharacterListViewModel(repository: MockCharacterRepository())
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testViewDidLoad() throws {
        sut.viewDidLoad()
        XCTAssertEqual(sut.items.value.count, 20)
    }
    
    func testViewDidRequestForNextPage() {
        sut.viewDidLoad()
        sut.viewDidRequestForNextPage()
        XCTAssertEqual(sut.items.value.count, 40)
    }
}
