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
        let expectation = XCTestExpectation(description: "Wait for initial load")
        
        sut.viewDidLoad()
        
        _ = sut.output.$items.sink { items in
            XCTAssertEqual(items.last?.name, "Ants in my Eyes Johnson")
            XCTAssertEqual(items.count, 20)
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testViewDidRequestForNextPage() {
        sut.viewDidLoad()
        sut.viewDidRequestForNextPage()
        XCTAssertEqual(sut.output.items.last?.name, "Beth's Mytholog")
        XCTAssertEqual(sut.output.items.count, 40)
    }
}
